import '../../core/value_objects/quantity.dart';
import '../../core/value_objects/money.dart';

class PurchaseInvoiceItem {
  final String productName;
  final Quantity quantity;
  final Money unitPrice;

  const PurchaseInvoiceItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  Money get total {
    return Money(unitPrice.amount * quantity.value);
  }
}