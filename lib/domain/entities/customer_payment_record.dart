import '../../core/value_objects/money.dart';
import '../../core/value_objects/cash_box_id.dart';

class CustomerPaymentRecord {
  final String customerName;
  final Money amount;
  final CashBoxId toCashBox;

  const CustomerPaymentRecord({
    required this.customerName,
    required this.amount,
    required this.toCashBox,
  });
}