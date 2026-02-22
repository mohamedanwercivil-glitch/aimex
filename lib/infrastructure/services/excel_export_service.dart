import 'dart:io';
import 'package:excel/excel.dart';

import '../../domain/entities/daily_records.dart';
import '../../domain/entities/day_session.dart';
import '../../core/value_objects/money.dart';
import '../../core/rules/daily_equation.dart';

class ExcelExportService {
  static Future<File> exportDay({
    required DailyRecords records,
    required DaySession session,
    required DailyEquationResult equation,
    required String filePath,
  }) async {
    final excel = Excel.createExcel();

    _buildSummarySheet(excel, records, session, equation);
    _buildSalesSheet(excel, records);
    _buildPurchasesSheet(excel, records);
    _buildExpensesSheet(excel, records);
    _buildWithdrawalsSheet(excel, records);
    _buildCustomerPaymentsSheet(excel, records);
    _buildTransfersSheet(excel, records);

    final fileBytes = excel.save();

    final file = File(filePath);
    await file.writeAsBytes(fileBytes!);

    return file;
  }

  // =========================
  // SUMMARY
  // =========================

  static void _buildSummarySheet(
      Excel excel,
      DailyRecords records,
      DaySession session,
      DailyEquationResult equation,
      ) {
    final sheet = excel['ملخص اليوم'];

    int row = 0;

    sheet.appendRow(["أرصدة البداية"]);
    for (final entry in session.openingBalances.entries) {
      sheet.appendRow([entry.key.value, entry.value.amount]);
    }

    sheet.appendRow([]);
    sheet.appendRow(["إجمالي بداية اليوم", _sum(session.openingBalances.values)]);

    sheet.appendRow(["إجمالي مبيعات", _sumSales(records)]);
    sheet.appendRow(["إجمالي مدفوع من العملاء", _sumCustomerPayments(records)]);
    sheet.appendRow(["إجمالي مشتريات", _sumPurchases(records)]);
    sheet.appendRow(["إجمالي مدفوع للموردين", _sumSupplierPayments(records)]);
    sheet.appendRow(["إجمالي مصروفات", _sumExpenses(records)]);
    sheet.appendRow(["إجمالي مسحوبات", _sumWithdrawals(records)]);

    sheet.appendRow([]);
    sheet.appendRow(["النهاية النظرية", equation.theoreticalClosing.amount]);
    sheet.appendRow(["النهاية الفعلية", equation.actualClosing.amount]);
    sheet.appendRow(["الفرق", equation.difference.amount]);

    sheet.appendRow([]);
    sheet.appendRow(["أرصدة النهاية"]);

    for (final entry in session.currentBalances.entries) {
      sheet.appendRow([entry.key.value, entry.value.amount]);
    }
  }

  // =========================
  // SALES
  // =========================

  static void _buildSalesSheet(Excel excel, DailyRecords records) {
    final sheet = excel['المبيعات'];
    sheet.appendRow(["العميل", "الصنف", "الكمية", "السعر", "الإجمالي"]);

    for (final invoice in records.sales) {
      for (final item in invoice.items) {
        sheet.appendRow([
          invoice.customerName,
          item.productName,
          item.quantity.value,
          item.unitPrice.amount,
          item.total.amount,
        ]);
      }
    }
  }

  // =========================
  // PURCHASES
  // =========================

  static void _buildPurchasesSheet(Excel excel, DailyRecords records) {
    final sheet = excel['المشتريات'];
    sheet.appendRow(["المورد", "الصنف", "الكمية", "السعر", "الإجمالي"]);

    for (final invoice in records.purchases) {
      for (final item in invoice.items) {
        sheet.appendRow([
          invoice.supplierName,
          item.productName,
          item.quantity.value,
          item.unitPrice.amount,
          item.total.amount,
        ]);
      }
    }
  }

  // =========================
  // EXPENSES
  // =========================

  static void _buildExpensesSheet(Excel excel, DailyRecords records) {
    final sheet = excel['المصروفات'];
    sheet.appendRow(["البيان", "المبلغ", "من خزنة"]);

    for (final record in records.expenses) {
      sheet.appendRow([
        record.description,
        record.amount.amount,
        record.fromCashBox.value,
      ]);
    }
  }

  // =========================
  // WITHDRAWALS
  // =========================

  static void _buildWithdrawalsSheet(Excel excel, DailyRecords records) {
    final sheet = excel['المسحوبات'];
    sheet.appendRow(["الشخص", "المبلغ", "من خزنة", "بيان"]);

    for (final record in records.withdrawals) {
      sheet.appendRow([
        record.personName,
        record.amount.amount,
        record.fromCashBox.value,
        record.note ?? "",
      ]);
    }
  }

  // =========================
  // CUSTOMER PAYMENTS
  // =========================

  static void _buildCustomerPaymentsSheet(Excel excel, DailyRecords records) {
    final sheet = excel['سداد العملاء'];
    sheet.appendRow(["العميل", "المبلغ", "إلى خزنة"]);

    for (final record in records.customerPayments) {
      sheet.appendRow([
        record.customerName,
        record.amount.amount,
        record.toCashBox.value,
      ]);
    }
  }

  // =========================
  // TRANSFERS
  // =========================

  static void _buildTransfersSheet(Excel excel, DailyRecords records) {
    final sheet = excel['التحويلات'];
    sheet.appendRow(["من", "إلى", "المبلغ"]);

    for (final record in records.transfers) {
      sheet.appendRow([
        record.from.value,
        record.to.value,
        record.amount.amount,
      ]);
    }
  }

  // =========================
  // SUM HELPERS
  // =========================

  static double _sum(Iterable<Money> values) {
    double total = 0;
    for (final v in values) {
      total += v.amount;
    }
    return total;
  }

  static double _sumSales(DailyRecords records) {
    double total = 0;
    for (final invoice in records.sales) {
      total += invoice.total.amount;
    }
    return total;
  }

  static double _sumPurchases(DailyRecords records) {
    double total = 0;
    for (final invoice in records.purchases) {
      total += invoice.total.amount;
    }
    return total;
  }

  static double _sumCustomerPayments(DailyRecords records) {
    double total = 0;
    for (final record in records.customerPayments) {
      total += record.amount.amount;
    }
    return total;
  }

  static double _sumSupplierPayments(DailyRecords records) {
    double total = 0;
    for (final invoice in records.purchases) {
      total += invoice.paidAmount.amount;
    }
    return total;
  }

  static double _sumExpenses(DailyRecords records) {
    double total = 0;
    for (final record in records.expenses) {
      total += record.amount.amount;
    }
    return total;
  }

  static double _sumWithdrawals(DailyRecords records) {
    double total = 0;
    for (final record in records.withdrawals) {
      total += record.amount.amount;
    }
    return total;
  }
}