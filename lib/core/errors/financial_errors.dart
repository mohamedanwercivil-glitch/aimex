import 'app_error.dart';

class DayAlreadyOpenError extends AppError {
  const DayAlreadyOpenError() : super("اليوم مفتوح بالفعل");
}

class DayNotOpenError extends AppError {
  const DayNotOpenError() : super("لا يوجد يوم مفتوح");
}

class NegativeBalanceError extends AppError {
  const NegativeBalanceError() : super("لا يسمح برصيد سالب");
}

class EquationMismatchError extends AppError {
  const EquationMismatchError()
      : super("لا يمكن إغلاق اليوم: يوجد فرق في المعادلة");
}