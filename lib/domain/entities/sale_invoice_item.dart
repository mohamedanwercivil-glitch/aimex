import '../../core/value_objects/quantity.dart';
import '../../core/value_objects/money.dart';

class SaleInvoiceItem {
  final String productName;
  final Quantity quantity;
  final Money unitPrice;

  const SaleInvoiceItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  Money get total {
    return Money(unitPrice.amount * quantity.value);
  }
}