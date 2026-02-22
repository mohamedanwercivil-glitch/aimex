import '../../domain/entities/day_session.dart';
import '../../domain/entities/inventory.dart';
import '../../domain/entities/sale_invoice.dart';
import '../../domain/entities/purchase_invoice.dart';
import '../../domain/entities/expense_record.dart';
import '../../domain/entities/withdrawal_record.dart';
import '../../domain/entities/customer_payment_record.dart';
import '../../domain/entities/transfer_record.dart';
import '../../domain/entities/daily_records.dart';

import '../../core/value_objects/money.dart';
import '../../core/value_objects/cash_box_id.dart';
import '../../core/rules/daily_equation.dart';
import '../../core/errors/financial_errors.dart';

class DayLifecycleService {
  DaySession _currentSession = DaySession.closed();

  final Inventory inventory;
  final DailyRecords dailyRecords = DailyRecords();

  DayLifecycleService({
    required this.inventory,
  });

  DaySession get currentSession => _currentSession;
  bool get isDayOpen => _currentSession.isOpen;

  Money _salesReceived = Money.zero();
  Money _customerPayments = Money.zero();
  Money _supplierPayments = Money.zero();
  Money _expenses = Money.zero();
  Money _withdrawals = Money.zero();

  // =========================
  // OPEN / CLOSE
  // =========================

  void openDay(Map<CashBoxId, Money> openingBalances) {
    if (_currentSession.isOpen) {
      throw const DayAlreadyOpenError();
    }

    _resetDailyTotals();
    dailyRecords.clear();

    _currentSession = DaySession.open(openingBalances);
  }

  void closeDay() {
    _ensureDayOpen();

    final result = DailyEquation.calculate(
      openingTotal: _calculateOpeningTotal(),
      salesReceived: _salesReceived,
      customerPayments: _customerPayments,
      supplierPayments: _supplierPayments,
      expenses: _expenses,
      withdrawals: _withdrawals,
      actualClosing: _currentSession.getTotalCurrentBalance(),
    );

    if (result.hasMismatch) {
      throw const EquationMismatchError();
    }

    dailyRecords.clear();
    _currentSession = DaySession.closed();
  }

  // =========================
  // SALES
  // =========================

  void registerSale(SaleInvoice invoice, CashBoxId? toCashBox) {
    _ensureDayOpen();
    invoice.validateBeforeSave();

    // خصم من المخزون
    for (final item in invoice.items) {
      inventory.decreaseStock(item.productName, item.quantity);
    }

    // إضافة للخزنة لو فيه دفع
    if (invoice.paidAmount.amount > 0 && toCashBox != null) {
      addToCashBox(toCashBox, invoice.paidAmount);
      _salesReceived = _salesReceived.add(invoice.paidAmount);
    }

    dailyRecords.recordSale(invoice);
  }

  // =========================
  // PURCHASE
  // =========================

  void registerPurchase(
      PurchaseInvoice invoice,
      CashBoxId? fromCashBox,
      ) {
    _ensureDayOpen();
    invoice.validateBeforeSave();

    // زيادة المخزون
    for (final item in invoice.items) {
      inventory.increaseStock(
        item.productName,
        item.quantity,
        item.unitPrice,
      );
    }

    // خصم من الخزنة لو فيه دفع
    if (invoice.paidAmount.amount > 0 && fromCashBox != null) {
      deductFromCashBox(fromCashBox, invoice.paidAmount);
      _supplierPayments = _supplierPayments.add(invoice.paidAmount);
    }

    dailyRecords.recordPurchase(invoice);
  }

  // =========================
  // EXPENSE
  // =========================

  void registerExpense(ExpenseRecord record) {
    _ensureDayOpen();

    deductFromCashBox(record.fromCashBox, record.amount);
    _expenses = _expenses.add(record.amount);

    dailyRecords.recordExpense(record);
  }

  // =========================
  // WITHDRAWAL
  // =========================

  void registerWithdrawal(WithdrawalRecord record) {
    _ensureDayOpen();

    deductFromCashBox(record.fromCashBox, record.amount);
    _withdrawals = _withdrawals.add(record.amount);

    dailyRecords.recordWithdrawal(record);
  }

  // =========================
  // CUSTOMER PAYMENT
  // =========================

  void registerCustomerPayment(CustomerPaymentRecord record) {
    _ensureDayOpen();

    addToCashBox(record.toCashBox, record.amount);
    _customerPayments = _customerPayments.add(record.amount);

    dailyRecords.recordCustomerPayment(record);
  }

  // =========================
  // TRANSFER
  // =========================

  void registerTransfer(TransferRecord record) {
    _ensureDayOpen();

    deductFromCashBox(record.from, record.amount);
    addToCashBox(record.to, record.amount);

    dailyRecords.recordTransfer(record);
  }

  // =========================
  // CASH BOX OPERATIONS
  // =========================

  void addToCashBox(CashBoxId id, Money amount) {
    final current = _currentSession.currentBalances[id] ?? Money.zero();
    final updated = current.add(amount);

    _currentSession.currentBalances[id] = updated;
  }

  void deductFromCashBox(CashBoxId id, Money amount) {
    final current = _currentSession.currentBalances[id] ?? Money.zero();
    final updated = current.subtract(amount);

    if (updated.isNegative) {
      throw const NegativeBalanceError();
    }

    _currentSession.currentBalances[id] = updated;
  }

  // =========================
  // HELPERS
  // =========================

  Money _calculateOpeningTotal() {
    Money total = Money.zero();
    for (final balance in _currentSession.openingBalances.values) {
      total = total.add(balance);
    }
    return total;
  }

  void _resetDailyTotals() {
    _salesReceived = Money.zero();
    _customerPayments = Money.zero();
    _supplierPayments = Money.zero();
    _expenses = Money.zero();
    _withdrawals = Money.zero();
  }

  void _ensureDayOpen() {
    if (!_currentSession.isOpen) {
      throw const DayNotOpenError();
    }
  }
}