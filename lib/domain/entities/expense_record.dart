import '../../core/value_objects/money.dart';
import '../../core/value_objects/cash_box_id.dart';

class ExpenseRecord {
  final String description;
  final Money amount;
  final CashBoxId fromCashBox;

  const ExpenseRecord({
    required this.description,
    required this.amount,
    required this.fromCashBox,
  });
}