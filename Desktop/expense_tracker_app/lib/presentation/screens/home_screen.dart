import 'package:expense_tracker_app/core/widgets/constants/constants.dart';
import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:expense_tracker_app/presentation/providers/theme_provider.dart';
import 'package:expense_tracker_app/presentation/providers/user_provider.dart';
import 'package:expense_tracker_app/presentation/screens/add_expense_screen.dart';
import 'package:expense_tracker_app/presentation/screens/all_expenses_screen.dart';
import 'package:expense_tracker_app/presentation/screens/reminder.dart';
import 'package:expense_tracker_app/presentation/widgets/expense_summary.dart';
import 'package:expense_tracker_app/presentation/widgets/expense_filter.dart';
import 'package:expense_tracker_app/presentation/widgets/expense_list.dart';
import 'package:expense_tracker_app/presentation/widgets/loading_indicator.dart';
import 'package:expense_tracker_app/presentation/screens/expense_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).loadExpenses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    List<Expense> displayedExpenses = expenseProvider.expenses.length > 5
        ? expenseProvider.expenses.take(5).toList()
        : expenseProvider.expenses;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expenzy',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showReminderDialog(context);
            },
            icon: const Icon(Icons.access_alarm),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            context.read<ThemeProvider>().toggleTheme();
          },
          icon: const Icon(Icons.dark_mode),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const ExpenseSummary(),
            ExpenseFilter(
              onDateRangeSelected: (startDate, endDate) {
                setState(() {
                  expenseProvider.filterExpensesByDate(startDate, endDate);
                });
              },
            ),
            expenseProvider.isLoading
                ? const LoadingIndicator()
                : Column(
                    children: [
                      if (expenseProvider.expenses.length > 5)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllExpensesScreen(),
                              ),
                            );
                          },
                          child: Text("View All",
                              style: Theme.of(context).textTheme.labelSmall),
                        ),
                      SizedBox(
                        height: 400, // Fixed height to avoid layout issues
                        child: ExpenseList(
                          expenses: displayedExpenses,
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
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return FloatingActionButton(
                onPressed: () {
                  userProvider.logout(context);
                },
                child: const Icon(Icons.logout),
              );
            },
          ),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddExpenseScreen(),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
