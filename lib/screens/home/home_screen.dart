import 'package:flutter/material.dart';
import 'package:my_expenses/database/expense_databse.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:my_expenses/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpense();
    super.initState();
  }

  void _openNewExpenseCard() {
    showDialog(
      context: context,
      builder: (context) => const ExpenseCardForm(
        title: 'New Expense',
        createNew: true,
      ),
    );
  }

  void _openEditExpenseCard(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => ExpenseCardForm(
        title: 'Edit Expense',
        expense: expense,
      ),
    );
  }

  void _openDeleteDialog(int expenseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<ExpenseDatabase>().deleteExpense(expenseId);
            },
            child: const Text('Delete'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        body: SafeArea(
          child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                    height: 2,
                  ),
              itemCount: value.allExpense.length,
              itemBuilder: (context, index) {
                final Expense currentExpense = value.allExpense[index];
                return ExpenseTile(
                    name: currentExpense.name,
                    amount: currentExpense.amount,
                    date: currentExpense.date,
                    onDelete: (context) {
                      _openDeleteDialog(currentExpense.id);
                    },
                    onEdit: (context) {
                      _openEditExpenseCard(currentExpense);
                    });
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openNewExpenseCard();
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
