import 'package:flutter/material.dart';
import 'package:my_expenses/database/expense_databse.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:my_expenses/utils/utils.dart';
import 'package:provider/provider.dart';

class CreateNewExpense extends StatelessWidget {
  const CreateNewExpense({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    void handaleClearBtn() {
      Navigator.pop(context);
      nameController.clear();
      amountController.clear();
    }

    void saveNewExpense() async {
      if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
        Navigator.pop(context);

        // Create new expense
        Expense newExpense = Expense(
          name: nameController.text,
          amount: convertStringToDouble(amountController.text),
          date: DateTime.now(),
        );

        await context.read<ExpenseDatabase>().createNewExpense(newExpense);
        nameController.clear();
        amountController.clear();
      }
    }

    return AlertDialog(
      title: const Text('New Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(hintText: 'Amount'),
          ),
        ],
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            handaleClearBtn();
          },
          child: const Text('Cancel'),
        ),
        MaterialButton(
          onPressed: () {
            saveNewExpense();
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}
