import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/categories.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';

class AddScreen extends StatefulWidget {
  // Si expense no es null, la pantalla entra en modo edición
  final Expense? expense;

  const AddScreen({super.key, this.expense});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedCategory = AppCategories.all.first;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  // Indica si estamos editando un gasto existente
  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    // Si hay un gasto existente, prellenar los campos
    if (_isEditing) {
      _amountController.text = widget.expense!.amount.toStringAsFixed(0);
      _noteController.text = widget.expense!.note ?? '';
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Abre el selector de fecha y actualiza el estado
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Valida el formulario, guarda o actualiza el gasto y cierra la pantalla
  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final expense = Expense(
      id: _isEditing ? widget.expense!.id : null,
      amount: double.parse(_amountController.text.trim()),
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    if (_isEditing) {
      await context.read<ExpenseProvider>().updateExpense(expense);
    } else {
      await context.read<ExpenseProvider>().addExpense(expense);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar gasto' : 'Agregar gasto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo monto
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa un monto';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Ingresa un número válido';
                }
                if (double.parse(value.trim()) <= 0) {
                  return 'El monto debe ser mayor a cero';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Selector de categoría
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: AppCategories.all
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 16),

            // Selector de fecha
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo nota (opcional)
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Nota (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Botón guardar o actualizar
            FilledButton(
              onPressed: _isSaving ? null : _saveExpense,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Actualizar gasto' : 'Guardar gasto'),
            ),
          ],
        ),
      ),
    );
  }
}