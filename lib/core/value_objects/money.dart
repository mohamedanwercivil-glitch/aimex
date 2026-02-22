class Money {
  final double amount;

  const Money(this.amount);

  factory Money.zero() {
    return const Money(0);
  }

  Money add(Money other) {
    return Money(amount + other.amount);
  }

  Money subtract(Money other) {
    return Money(amount - other.amount);
  }

  bool get isNegative => amount < 0;

  @override
  String toString() {
    return amount.toStringAsFixed(2);
  }
}