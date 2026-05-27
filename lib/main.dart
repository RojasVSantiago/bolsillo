import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const BolsilloApp());
}

class BolsilloApp extends StatelessWidget {
  const BolsilloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseProvider(),
      child: MaterialApp(
        title: 'Bolsillo',
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}