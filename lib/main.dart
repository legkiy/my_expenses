import 'package:flutter/material.dart';
import 'package:my_expenses/database/expense_databse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseDatabase.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Expenses',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
