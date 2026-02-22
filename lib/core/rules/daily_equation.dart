import '../value_objects/money.dart';

class DailyEquationResult {
  final Money theoreticalClosing;
  final Money actualClosing;
  final Money difference;

  const DailyEquationResult({
    required this.theoreticalClosing,
    required this.actualClosing,
    required this.difference,
  });

  bool get hasMismatch => difference.amount != 0;
}

class DailyEquation {

  static DailyEquationResult calculate({
    required Money openingTotal,
    required Money salesReceived,
    required Money customerPayments,
    required Money supplierPayments,
    required Money expenses,
    required Money withdrawals,
    required Money actualClosing,
  }) {

    Money theoretical = openingTotal
        .add(salesReceived)
        .add(customerPayments)
        .subtract(supplierPayments)
        .subtract(expenses)
        .subtract(withdrawals);

    Money diff = actualClosing.subtract(theoretical);

    return DailyEquationResult(
      theoreticalClosing: theoretical,
      actualClosing: actualClosing,
      difference: diff,
    );
  }
}