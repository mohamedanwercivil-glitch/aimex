import '../../core/value_objects/money.dart';
import '../../core/value_objects/cash_box_id.dart';
import '../../core/errors/app_error.dart';

class InvalidTransferError extends AppError {
  const InvalidTransferError()
      : super("لا يمكن التحويل لنفس الخزنة");
}

class TransferRecord {
  final CashBoxId from;
  final CashBoxId to;
  final Money amount;

  TransferRecord({
    required this.from,
    required this.to,
    required this.amount,
  }) {
    if (from.value == to.value) {
      throw const InvalidTransferError();
    }
  }
}