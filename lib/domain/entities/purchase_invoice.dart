import 'purchase_invoice_item.dart';
import '../../core/value_objects/money.dart';
import '../../core/errors/app_error.dart';

class EmptyPurchaseInvoiceError extends AppError {
  const EmptyPurchaseInvoiceError()
      : super("لا يمكن حفظ فاتورة شراء فارغة");
}

class PurchaseInvoice {
  final String supplierName;
  final List<PurchaseInvoiceItem> _items = [];

  Money _paidAmount = Money.zero();

  PurchaseInvoice({
    required this.supplierName,
  });

  List<PurchaseInvoiceItem> get items => List.unmodifiable(_items);

  void addItem(PurchaseInvoiceItem item) {
    _items.add(item);
  }

  void setPaidAmount(Money amount) {
    _paidAmount = amount;
  }

  Money get total {
    Money sum = Money.zero();
    for (final item in _items) {
      sum = sum.add(item.total);
    }
    return sum;
  }

  Money get paidAmount => _paidAmount;

  Money get difference {
    return _paidAmount.subtract(total);
  }

  void validateBeforeSave() {
    if (_items.isEmpty) {
      throw const EmptyPurchaseInvoiceError();
    }
  }
}