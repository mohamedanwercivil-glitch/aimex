import '../../core/value_objects/money.dart';
import '../../core/value_objects/cash_box_id.dart';

class WithdrawalRecord {
  final String personName;
  final Money amount;
  final CashBoxId fromCashBox;
  final String? note;

  const WithdrawalRecord({
    required this.personName,
    required this.amount,
    required this.fromCashBox,
    this.note,
  });
}