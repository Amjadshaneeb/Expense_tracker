import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';
import '../../data/data_sources/expense_db_helper.dart';

class TotalExpenseProvider extends ChangeNotifier {
  double _totalExpense = 0.0;
  bool _isLoading = false;

  double get totalExpense => _totalExpense;
  bool get isLoading => _isLoading;

  // Fetch total expense from the database
  Future<void> loadTotalExpense() async {
    _isLoading = true;
    notifyListeners(); 

    List<Expense> expenses = await ExpenseDbHelper().fetchExpenses();

    _totalExpense = expenses.fold(0, (sum, expense) => sum + expense.amount);
    
    _isLoading = false;
    notifyListeners(); 
  }

  // Add an expense and update total
  Future<void> addExpense(Expense expense) async {
    await ExpenseDbHelper().insertExpense(expense);
    await loadTotalExpense(); 
  }

  // Edit an expense and update total
  Future<void> editExpense(Expense updatedExpense) async {
    await ExpenseDbHelper().updateExpense(updatedExpense);
    await loadTotalExpense();
  }

  // Delete an expense and update total
  Future<void> deleteExpense(int id) async {
    await ExpenseDbHelper().deleteExpense(id);
    await loadTotalExpense(); 
  }

  // Clear all expenses and reset total
  Future<void> clearAllExpenses() async {
    await ExpenseDbHelper().clearAllExpenses();
    _totalExpense = 0.0;
    notifyListeners();
  }
}
