import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExpenseDbHelper {
  static final ExpenseDbHelper _instance = ExpenseDbHelper._internal();
  factory ExpenseDbHelper() => _instance;
  ExpenseDbHelper._internal();

  static Database? _database;
  static const String _tableName = 'expenses';

  static const String _createTableQuery = '''
  CREATE TABLE $_tableName (
    id INTEGER PRIMARY KEY,
    amount REAL,
    category TEXT,
    description TEXT,
    date TEXT
  )
  ''';

  Future<Database> openDb() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), 'expenses.db');
    _database = await openDatabase(
      path,
      version: 1, 
      onCreate: (db, version) async {
        await db.execute(_createTableQuery);
      },
    );

    return _database!;
  }

  Future<void> insertExpense(Expense expense) async {
    final db = await openDb();
    await db.insert(
      _tableName,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await openDb();
    int rowsUpdated = await db.update(
      _tableName,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    return rowsUpdated;  
  }

  Future<List<Expense>> fetchExpenses() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((expenseMap) => Expense.fromMap(expenseMap)).toList();
  }

  Future<int> deleteExpense(int id) async {
    final db = await openDb();
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllExpenses() async {
    final db = await openDb();
    await db.delete(_tableName);
  }
}
