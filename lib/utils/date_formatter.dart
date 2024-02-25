import 'package:intl/intl.dart';

String dateFormatter(DateTime date) {
  return DateFormat('H:m, d MMM y').format(date);
}
