class Quantity {
  final int value;

  const Quantity(this.value);

  factory Quantity.zero() {
    return const Quantity(0);
  }

  bool get isValid => value > 0;

  bool isGreaterThan(Quantity other) {
    return value > other.value;
  }

  Quantity add(Quantity other) {
    return Quantity(value + other.value);
  }

  Quantity subtract(Quantity other) {
    return Quantity(value - other.value);
  }

  @override
  String toString() {
    return value.toString();
  }
}