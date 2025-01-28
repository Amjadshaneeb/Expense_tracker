
class Expense {
  final int id;
  final double amount;
  final String category;
  final String description;
  final String date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: map['category'] ?? 'Unknown', 
      description: map['description'] ?? 'No description',
      date: map['date'] ?? DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date,
    };
  }
}
