import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/formatters.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../add/add_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ExpenseProvider>().loadAllExpenses());
  }

  // Muestra diálogo de confirmación antes de eliminar
  Future<void> _confirmDelete(BuildContext context, Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: Text(
            '¿Eliminar ${expense.category} por ${AppFormatters.amount(expense.amount)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<ExpenseProvider>().deleteExpense(expense.id!);
    }
  }

  // Abre AddScreen en modo edición con el gasto seleccionado
  void _openEdit(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddScreen(expense: expense)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.expenses.isEmpty
              ? const Center(child: Text('Sin gastos registrados'))
              : ListView.separated(
                  itemCount: provider.expenses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final expense = provider.expenses[index];
                    return _ExpenseTile(
                      expense: expense,
                      onDelete: () => _confirmDelete(context, expense),
                      onEdit: () => _openEdit(context, expense),
                    );
                  },
                ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ExpenseTile({
    required this.expense,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.category),
      subtitle: Text(
        '${expense.date.day}/${expense.date.month}/${expense.date.year}'
        '${expense.note != null ? ' · ${expense.note}' : ''}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppFormatters.amount(expense.amount),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
      onLongPress: onEdit,
    );
  }
}