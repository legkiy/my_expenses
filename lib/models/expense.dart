import 'package:isar/isar.dart';

// need to generate isar file
// run cmd in terminal: dart run build_runner build
part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;
  final String name;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });
}
