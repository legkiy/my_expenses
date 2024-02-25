import 'package:flutter/material.dart';
import 'current_bar_chart.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseBarChart extends StatefulWidget {
  final List<double> manthlySummary;
  final int startMonth;

  const ExpenseBarChart({
    super.key,
    required this.manthlySummary,
    required this.startMonth,
  });

  @override
  State<ExpenseBarChart> createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  List<CurrentBarChart> barData = [];

  void initializeBarData() {
    barData = List.generate(
      widget.manthlySummary.length,
      (index) => CurrentBarChart(x: index, y: widget.manthlySummary[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(maxY: 100, minY: 0),
    );
  }
}
