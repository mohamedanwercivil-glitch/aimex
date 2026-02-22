import 'sale_invoice.dart';
import 'purchase_invoice.dart';
import 'expense_record.dart';
import 'withdrawal_record.dart';
import 'customer_payment_record.dart';
import 'transfer_record.dart';

class DailyRecords {
  final List<SaleInvoice> sales = [];
  final List<PurchaseInvoice> purchases = [];
  final List<ExpenseRecord> expenses = [];
  final List<WithdrawalRecord> withdrawals = [];
  final List<CustomerPaymentRecord> customerPayments = [];
  final List<TransferRecord> transfers = [];

  void recordSale(SaleInvoice invoice) {
    sales.add(invoice);
  }

  void recordPurchase(PurchaseInvoice invoice) {
    purchases.add(invoice);
  }

  void recordExpense(ExpenseRecord record) {
    expenses.add(record);
  }

  void recordWithdrawal(WithdrawalRecord record) {
    withdrawals.add(record);
  }

  void recordCustomerPayment(CustomerPaymentRecord record) {
    customerPayments.add(record);
  }

  void recordTransfer(TransferRecord record) {
    transfers.add(record);
  }

  void clear() {
    sales.clear();
    purchases.clear();
    expenses.clear();
    withdrawals.clear();
    customerPayments.clear();
    transfers.clear();
  }
}