import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _allExpenses = [];

  // SETUP

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  // GETTERS

  List<Expense> get allExpense => _allExpenses;

  // OPERATIONS

  /// Create expense
  Future<void> createNewExpense(Expense newExpense) async {
    // add to isar db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    await readExpense();
  }

  /// Read expenses
  Future<void> readExpense() async {
    List<Expense> fetchExpense = await isar.expenses.where().findAll();

    _allExpenses.clear();
    _allExpenses.addAll(fetchExpense);

    notifyListeners();
  }

  /// Update expense
  Future<void> updateExpense(
      {required int id, required Expense updatedExpense}) async {
    updatedExpense.id = id;

    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    await readExpense();
  }

  /// Delete expense
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    await readExpense();
  }

  // HELPERS

  /// calculate total expense for each month
  Future<Map<int, double>> calculateMonthlyTotals() async {
    await readExpense();
    Map<int, double> monthlyTotal = {};

    for (var expense in _allExpenses) {
      int month = expense.date.month;

      if (!monthlyTotal.containsKey(month)) {
        monthlyTotal[month] = 0;
      }

      monthlyTotal[month] = monthlyTotal[month]! + expense.amount;
    }
    return monthlyTotal;
  }

  /// Get start month
  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().month;
    }

    _allExpenses.sort((a, b) => a.date.compareTo(b.date));

    return _allExpenses.first.date.month;
  }

  /// get start yaer
  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().year;
    }

    _allExpenses.sort((a, b) => a.date.compareTo(b.date));

    return _allExpenses.first.date.year;
  }
}
