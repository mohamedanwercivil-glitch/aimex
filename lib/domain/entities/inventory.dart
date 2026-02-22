import 'product.dart';
import '../../core/value_objects/quantity.dart';
import '../../core/value_objects/money.dart';
import '../../core/errors/app_error.dart';

class ProductAlreadyExistsError extends AppError {
  const ProductAlreadyExistsError() : super("الصنف موجود بالفعل");
}

class ProductNotFoundError extends AppError {
  const ProductNotFoundError() : super("الصنف غير موجود");
}

class Inventory {
  final Map<String, Product> _products;

  Inventory(this._products);

  factory Inventory.empty() {
    return Inventory({});
  }

  List<Product> get allProducts => _products.values.toList();

  Product getByName(String name) {
    final product = _products[name];
    if (product == null) {
      throw const ProductNotFoundError();
    }
    return product;
  }

  void addNewProduct(String name, Quantity quantity, Money purchasePrice) {
    if (_products.containsKey(name)) {
      throw const ProductAlreadyExistsError();
    }

    final product = Product(
      name: name,
      initialQuantity: quantity,
      lastPurchasePrice: purchasePrice,
    );

    _products[name] = product;
  }

  void increaseStock(String name, Quantity quantity, Money purchasePrice) {
    final product = _products[name];

    if (product == null) {
      addNewProduct(name, quantity, purchasePrice);
      return;
    }

    product.increaseStock(quantity, purchasePrice: purchasePrice);
  }

  void decreaseStock(String name, Quantity quantity) {
    final product = _products[name];

    if (product == null) {
      throw const ProductNotFoundError();
    }

    product.decreaseStock(quantity);
  }
}