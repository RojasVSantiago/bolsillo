import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository _repository = ExpenseRepository();

  // Listas privadas
  List<Expense> _expenses = [];
  List<Expense> _monthlyExpenses = [];
  bool _isLoading = false;

  // Getters públicos
  List<Expense> get expenses => _expenses;
  List<Expense> get monthlyExpenses => _monthlyExpenses;
  bool get isLoading => _isLoading;

  // Getter calculado — suma por categoría del mes actual
  Map<String, double> get monthlyTotalsByCategory {
    final totals = <String, double>{};
    for (final expense in _monthlyExpenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  // Carga todos los gastos
  Future<void> loadAllExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await _repository.getAllExpenses();

    _isLoading = false;
    notifyListeners();
  }

  // Carga gastos filtrados por mes
  Future<void> loadMonthlyExpenses(int year, int month) async {
    _isLoading = true;
    notifyListeners();

    _monthlyExpenses = await _repository.getExpensesByMonth(year, month);

    _isLoading = false;
    notifyListeners();
  }

  // Agrega un gasto y recarga las listas
  Future<void> addExpense(Expense expense) async {
    await _repository.insertExpense(expense);
    await loadAllExpenses();
    final now = DateTime.now();
    await loadMonthlyExpenses(now.year, now.month);
  }

  // Elimina un gasto y recarga las listas
  Future<void> deleteExpense(int id) async {
    await _repository.deleteExpense(id);
    await loadAllExpenses();
    final now = DateTime.now();
    await loadMonthlyExpenses(now.year, now.month);
  }

  // Actualiza un gasto y recarga las listas
  Future<void> updateExpense(Expense expense) async {
    await _repository.updateExpense(expense);
    await loadAllExpenses();
    final now = DateTime.now();
    await loadMonthlyExpenses(now.year, now.month);
  }
}