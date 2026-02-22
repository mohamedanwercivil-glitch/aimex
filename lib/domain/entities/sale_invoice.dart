import 'sale_invoice_item.dart';
import 'payment_method.dart';
import '../../core/value_objects/money.dart';
import '../../core/errors/app_error.dart';

class EmptyInvoiceError extends AppError {
  const EmptyInvoiceError() : super("لا يمكن حفظ فاتورة فارغة");
}

class SaleInvoice {
  final String customerName;
  final List<SaleInvoiceItem> _items = [];

  PaymentMethod? _paymentMethod;
  Money _paidAmount = Money.zero();

  SaleInvoice({
    required this.customerName,
  });

  List<SaleInvoiceItem> get items => List.unmodifiable(_items);

  void addItem(SaleInvoiceItem item) {
    _items.add(item);
  }

  void setPayment({
    required PaymentMethod method,
    Money? paidAmount,
  }) {
    _paymentMethod = method;

    if (method == PaymentMethod.deferred) {
      _paidAmount = Money.zero();
    } else {
      _paidAmount = paidAmount ?? Money.zero();
    }
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

  PaymentMethod? get paymentMethod => _paymentMethod;

  void validateBeforeSave() {
    if (_items.isEmpty) {
      throw const EmptyInvoiceError();
    }
  }
}