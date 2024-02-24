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

  // Create
  Future<void> createNewExpense(Expense newExpense) async {
    // add to isar db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    await readExpense();
  }

  // Read
  Future<void> readExpense() async {
    List<Expense> fetchExpense = await isar.expenses.where().findAll();

    _allExpenses.clear();
    _allExpenses.addAll(fetchExpense);

    notifyListeners();
  }

  // Update
  Future<void> updateExpense(
      {required int id, required Expense updatedExpense}) async {
    updatedExpense.id = id;

    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    await readExpense();
  }

  // Delete
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    await readExpense();
  }
}
