import '../../core/value_objects/quantity.dart';
import '../../core/value_objects/money.dart';
import '../../core/errors/app_error.dart';

class InsufficientStockError extends AppError {
  const InsufficientStockError() : super("الكمية غير كافية في المخزون");
}

class Product {
  final String name;
  Quantity _quantity;
  Money? _lastPurchasePrice;
  Money? _previousPurchasePrice;

  Product({
    required this.name,
    required Quantity initialQuantity,
    Money? lastPurchasePrice,
    Money? previousPurchasePrice,
  })  : _quantity = initialQuantity,
        _lastPurchasePrice = lastPurchasePrice,
        _previousPurchasePrice = previousPurchasePrice;

  Quantity get quantity => _quantity;

  Money? get lastPurchasePrice => _lastPurchasePrice;

  Money? get previousPurchasePrice => _previousPurchasePrice;

  void increaseStock(Quantity qty, {Money? purchasePrice}) {
    _quantity = _quantity.add(qty);

    if (purchasePrice != null) {
      _previousPurchasePrice = _lastPurchasePrice;
      _lastPurchasePrice = purchasePrice;
    }
  }

  void decreaseStock(Quantity qty) {
    if (qty.isGreaterThan(_quantity)) {
      throw const InsufficientStockError();
    }

    _quantity = _quantity.subtract(qty);
  }
}