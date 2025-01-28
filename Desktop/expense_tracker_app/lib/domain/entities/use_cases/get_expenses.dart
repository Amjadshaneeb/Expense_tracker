import 'package:expense_tracker_app/data/repositories/expense_repository.dart';
import 'package:expense_tracker_app/domain/entities/expense_entity.dart';

class LoadExpenses {
  final ExpenseRepository repository;

  LoadExpenses(this.repository);

  Future<List<Expense>> execute() async {
    return await repository.fetchExpenses();
  }
}
