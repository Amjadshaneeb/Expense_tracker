import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../screens/expense_detail_screen.dart';
import '../widgets/expense_list.dart';

class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // Fetch category-wise expenses using getExpenseSummary
    Map<String, double> categoryExpenses = expenseProvider.getExpenseSummary();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Expenses',
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          // Category-wise Expenses
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const SizedBox(height: 8),
                ...categoryExpenses.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${entry.key}: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '₹${entry.value.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          expenseProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Flexible(
                child: ExpenseList(
                    expenses: expenseProvider.expenses,
                    onExpenseTap: (expense) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExpenseDetailScreen(expense: expense),
                        ),
                      );
                    },
                  ),
              ),
        ],
      ),
    );
  }
}
