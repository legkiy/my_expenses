import 'package:flutter/material.dart';
import 'package:my_expenses/utils/utils.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final double amount;

  const ExpenseTile({super.key, required this.name, required this.amount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(convertNumberToPrice(amount)),
    );
  }
}
