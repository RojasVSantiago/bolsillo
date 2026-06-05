import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../add/add_screen.dart';
import '../../config/formatters.dart';
import '../history/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    Future.microtask(
      () => context.read<ExpenseProvider>().loadMonthlyExpenses(
        now.year,
        now.month,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final totals = provider.monthlyTotalsByCategory;
    final grandTotal = totals.values.fold(0.0, (sum, v) => sum + v);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolsillo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _TotalCard(grandTotal: grandTotal),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Por categoría',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: totals.isEmpty
                      ? const Center(child: Text('Sin gastos este mes'))
                      : ListView.builder(
                          itemCount: totals.length,
                          itemBuilder: (context, index) {
                            final category = totals.keys.elementAt(index);
                            final amount = totals.values.elementAt(index);
                            return _CategoryTile(
                              category: category,
                              amount: amount,
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double grandTotal;

  const _TotalCard({required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '${months[now.month - 1]} ${now.year}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              AppFormatters.amount(grandTotal),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text('Total del mes'),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String category;
  final double amount;

  const _CategoryTile({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category),
      trailing: Text(
        AppFormatters.amount(amount),

        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
