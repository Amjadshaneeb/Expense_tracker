import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:expense_tracker_app/presentation/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Function(Expense) onExpenseTap;

  const ExpenseList(
      {super.key, required this.expenses, required this.onExpenseTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Column(
          children: [
            ExpenseItem(
              expense: expense,
              onTap: () => onExpenseTap(expense),
            ),
            const Divider(thickness: 0.3,)
          ],
        );
      },
    );
  }
}
