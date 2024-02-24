import 'package:flutter/material.dart';
import 'package:my_expenses/database/expense_databse.dart';
import 'package:my_expenses/screens/screens.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseDatabase(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'My Expenses',
        debugShowCheckedModeBanner: false,
        home: HomeScreen());
  }
}
