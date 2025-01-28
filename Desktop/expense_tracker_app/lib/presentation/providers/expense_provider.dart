import 'package:expense_tracker_app/data/data_sources/expense_db_helper.dart';
import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:expense_tracker_app/presentation/providers/total_expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> _filteredExpenses = [];
  bool _isLoading = false;

  List<Expense> get expenses =>
      _filteredExpenses.isNotEmpty ? _filteredExpenses : _expenses;
  bool get isLoading => _isLoading;

  Future<void> loadExpenses(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    _expenses = await ExpenseDbHelper().fetchExpenses();
    debugPrint('Expenses Loaded: $_expenses'); 

    _filteredExpenses.clear();
    _isLoading = false;
    notifyListeners();

    Provider.of<TotalExpenseProvider>(context, listen: false)
        .loadTotalExpense();
  }

  // Get total expenses
  double get totalExpenses {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Add new expense
  Future<void> addExpense(BuildContext context, Expense expense) async {
    await ExpenseDbHelper().insertExpense(expense);
    await loadExpenses(context);
  }

  // Edit expense
  Future<void> editExpense(BuildContext context, Expense updatedExpense) async {
    await ExpenseDbHelper().updateExpense(updatedExpense);
    await loadExpenses(context);
  }

  // Delete expense
  Future<void> deleteExpense(BuildContext context, int id) async {
    await ExpenseDbHelper().deleteExpense(id);
    await loadExpenses(context);
  }

  // Filter expenses by date
  void filterExpensesByDate(DateTime startDate, DateTime endDate) {
    _filteredExpenses = _expenses.where((expense) {
      DateTime expenseDate = DateTime.parse(expense.date);
      return expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          expenseDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    notifyListeners();
  }

  // Get summarized expenses by category
  Map<String, double> getExpenseSummary() {
    Map<String, double> summary = {};
    for (var expense in expenses) {
      summary[expense.category] =
          (summary[expense.category] ?? 0) + expense.amount;
    }
    return summary;
  }

  // Get weekly expenses summary by category
  Map<String, double> getWeeklyExpenseSummary() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    Map<String, double> summary = {
      "Sun": 0.0,
      "Mon": 0.0,
      "Tue": 0.0,
      "Wed": 0.0,
      "Thu": 0.0,
      "Fri": 0.0,
      "Sat": 0.0
    };

    for (var expense in _expenses) {
      DateTime expenseDate = DateTime.parse(expense.date);
      if (expenseDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          expenseDate.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        String day =
            DateFormat('E').format(expenseDate); 
        summary[day] = (summary[day] ?? 0) + expense.amount;
      }
    }

    return summary;
  }

  // Get yearly expenses summary by category
  Map<String, double> getYearlyExpenseSummary() {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    // Initialize months with 0.0
    Map<String, double> summary = {
      for (int i = 1; i <= 12; i++)
        DateFormat('MMM').format(DateTime(currentYear, i)): 0.0
    };

    for (var expense in _expenses) {
      DateTime expenseDate = DateTime.parse(expense.date);
      if (expenseDate.year == currentYear) {
        String month = DateFormat('MMM')
            .format(expenseDate);
        summary[month] = (summary[month] ?? 0) + expense.amount;
      }
    }

    return summary;
  }

  Future<void> clearAllExpenses(BuildContext context) async {
    await ExpenseDbHelper().clearAllExpenses();
    _expenses.clear();
    _filteredExpenses.clear();
    notifyListeners();

    Provider.of<TotalExpenseProvider>(context, listen: false)
        .clearAllExpenses();
  }
}
