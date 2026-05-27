class Expense {
  final int? id;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  // Constructor
  const Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  // Constructor SQLite
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'note': note,
    };
  }

  // Constructor o conversor
  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int?,
      amount: map['amount'] as double,
      category: map['category'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      note: map['note'] as String?,
    );
  }
}