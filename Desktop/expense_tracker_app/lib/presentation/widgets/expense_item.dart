import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseItem({super.key, required this.expense, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        title: Text(
          expense.description,
          style: Theme.of(context).textTheme.bodyLarge, 
        ),
        subtitle: Text(
          '\u20B9${expense.amount}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), 
              ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              expense.category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              expense.date,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6), 
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
