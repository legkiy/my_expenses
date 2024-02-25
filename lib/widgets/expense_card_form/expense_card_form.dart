import 'package:flutter/material.dart';
import 'package:my_expenses/database/expense_databse.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:my_expenses/utils/utils.dart';
import 'package:provider/provider.dart';

class ExpenseCardForm extends StatelessWidget {
  final String title;
  final bool? createNew;
  final Expense? expense;

  const ExpenseCardForm({
    super.key,
    required this.title,
    this.createNew = false,
    this.expense,
  }) : assert(expense != null || createNew != null);

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
      // if its new expense

      if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
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

    void saveEditExpense() async {
      if (nameController.text.isNotEmpty || amountController.text.isNotEmpty) {
        Expense updatedExpense = Expense(
          name: nameController.text.isNotEmpty
              ? nameController.text
              : expense!.name,
          amount: amountController.text.isNotEmpty
              ? convertStringToDouble(amountController.text)
              : expense!.amount,
          date: DateTime.now(),
        );

        int existingId = expense!.id;

        await context
            .read<ExpenseDatabase>()
            .updateExpense(id: existingId, updatedExpense: updatedExpense);
      }
    }

    final String hintName =
        expense?.name.isNotEmpty ?? false ? expense!.name : 'Name';
    final String hintAmount = expense?.amount.toString().isNotEmpty ?? false
        ? expense!.amount.toString()
        : 'Amount';

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: hintName),
          ),
          TextField(
            controller: amountController,
            decoration: InputDecoration(hintText: hintAmount),
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
            if (createNew == true) {
              saveNewExpense();
            } else {
              saveEditExpense();
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}
