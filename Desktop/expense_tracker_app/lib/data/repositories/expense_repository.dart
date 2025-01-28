import 'package:expense_tracker_app/data/data_sources/expense_db_helper.dart';
import 'package:expense_tracker_app/domain/entities/expense_entity.dart';

class ExpenseRepository {
  final ExpenseDbHelper _dbHelper;

  ExpenseRepository(this._dbHelper);

  Future<List<Expense>> fetchExpenses() async {
    return await _dbHelper.fetchExpenses();
  }

  Future<void> insertExpense(Expense expense) async {
    await _dbHelper.insertExpense(expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
  }

  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
  }

  Future<void> clearAllExpenses() async {
    await _dbHelper.clearAllExpenses();
  }

  getExpenseById(int expenseId) {}
}