import '../../core/value_objects/money.dart';
import '../../core/value_objects/cash_box_id.dart';

class DaySession {
  final Map<CashBoxId, Money> openingBalances;
  final Map<CashBoxId, Money> currentBalances;
  final bool isOpen;

  const DaySession({
    required this.openingBalances,
    required this.currentBalances,
    required this.isOpen,
  });

  factory DaySession.closed() {
    return const DaySession(
      openingBalances: {},
      currentBalances: {},
      isOpen: false,
    );
  }

  factory DaySession.open(Map<CashBoxId, Money> balances) {
    return DaySession(
      openingBalances: balances,
      currentBalances: Map.from(balances),
      isOpen: true,
    );
  }

  Money getTotalCurrentBalance() {
    Money total = Money.zero();
    for (final balance in currentBalances.values) {
      total = total.add(balance);
    }
    return total;
  }
}