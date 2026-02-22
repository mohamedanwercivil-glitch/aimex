import '../value_objects/cash_box_id.dart';

class CashBoxes {
  static const CashBoxId vodafone32 = CashBoxId("فودافون محمد 32");
  static const CashBoxId vodafone57 = CashBoxId("فودافون محمد 57");
  static const CashBoxId weMohamed = CashBoxId("وي محمد");
  static const CashBoxId insta015 = CashBoxId("انستا محمد 015");
  static const CashBoxId vodafoneOmar = CashBoxId("فودافون عمر");
  static const CashBoxId cash = CashBoxId("نقدي");

  static const List<CashBoxId> all = [
    vodafone32,
    vodafone57,
    weMohamed,
    insta015,
    vodafoneOmar,
    cash,
  ];
}