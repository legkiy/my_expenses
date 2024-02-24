import 'package:flutter/material.dart';
import 'package:my_expenses/database/expense_databse.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:my_expenses/utils/utils.dart';
import 'package:my_expenses/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openNewExpenseBox() {
    showDialog(
        context: context, builder: (context) => const CreateNewExpense());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        body: SafeArea(
          child: ListView.builder(
              itemCount: value.allExpense.length,
              itemBuilder: (context, index) {
                final Expense individualExpense = value.allExpense[index];
                return ExpenseTile(
                    name: individualExpense.name,
                    amount: individualExpense.amount);
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openNewExpenseBox();
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
