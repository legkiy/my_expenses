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
  Future<Map<int, double>>? _monthlyTotalFuture;

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpense();
    refreshChartData();
    super.initState();
  }

  void refreshChartData() {
    _monthlyTotalFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
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
      builder: (context, value, child) {
        int startMonth = value.getStartMonth();
        int startYear = value.getStartYear();

        int currentMonth = DateTime.now().month;
        int currentYear = DateTime.now().year;

        int monthCount = calculateMonthCount(
          startYear: startYear,
          startMonth: startMonth,
          currentYear: currentYear,
          currentMonth: currentMonth,
        );

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Expense chart
                SizedBox(
                  height: 200,
                  child: FutureBuilder(
                    future: _monthlyTotalFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final Map<int, double> monthlyTotals =
                            snapshot.data ?? {};

                        List<double> monthlySummary = List.generate(
                            monthCount,
                            (index) =>
                                monthlyTotals[startMonth + index] ?? 0.0);

                        return ExpenseBarChart(
                          manthlySummary: monthlySummary,
                          startMonth: startMonth,
                        );
                      } else {
                        return const Center(
                          child: Text('Loading...'),
                        );
                      }
                    },
                  ),
                ),

                // Expense list
                Expanded(
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
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _openNewExpenseCard();
            },
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }
}
