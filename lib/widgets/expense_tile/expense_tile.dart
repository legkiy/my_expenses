import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_expenses/utils/utils.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final double amount;
  final DateTime date;
  final void Function(BuildContext)? onDelete;
  final void Function(BuildContext)? onEdit;

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.date,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: onEdit,
            icon: Icons.mode_edit_outline_rounded,
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          SlidableAction(
            onPressed: onDelete,
            icon: Icons.delete_forever_rounded,
            foregroundColor: Colors.redAccent.shade700,
            backgroundColor: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          )
        ],
      ),
      child: ListTile(
        title: Text(name),
        subtitle: Text(dateFormatter(date)),
        trailing: Text(convertNumberToPrice(amount)),
      ),
    );
  }
}
