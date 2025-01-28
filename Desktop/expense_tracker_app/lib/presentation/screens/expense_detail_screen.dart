import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart'; 

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color cardColor = theme.brightness == Brightness.dark
        ? Colors.grey[800]! 
        : Colors.grey[200]!; 

    Color textColor = theme.brightness == Brightness.dark
        ? Colors.white 
        : Colors.black; 
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Detail',
          style: theme.appBarTheme.titleTextStyle,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9, 
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                color: cardColor, 
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: textColor, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\u20B9${expense.amount.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        expense.date,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),

                  
                      Text(
                        expense.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: textColor.withOpacity(0.8), 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddExpenseScreen(expense: expense),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit, color: theme.iconTheme.color),
                  label: Text(
                    'Edit',
                    style: theme.textTheme.labelLarge?.copyWith(color: theme.iconTheme.color),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ExpenseProvider>().deleteExpense(context, expense.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    'Delete',
                    style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
