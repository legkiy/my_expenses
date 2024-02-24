import 'package:intl/intl.dart';

String convertNumberToPrice(double amount) {
  final format =
      NumberFormat.currency(locale: 'ru_RU', symbol: '\₽', decimalDigits: 2);
  return format.format(amount);
}
