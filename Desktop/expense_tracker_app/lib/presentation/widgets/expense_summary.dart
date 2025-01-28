import 'package:expense_tracker_app/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatefulWidget {
  const ExpenseSummary({super.key});

  @override
  ExpenseSummaryState createState() => ExpenseSummaryState();
}

class ExpenseSummaryState extends State<ExpenseSummary> {
  bool showWeekly = true; 

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        var summary = showWeekly
            ? provider.getWeeklyExpenseSummary() 
            : provider.getYearlyExpenseSummary(); 

       

        double totalExpense = summary.values
            .fold(0, (sum, amount) => sum + amount);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Expenses',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Total Expense Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '₹${totalExpense.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showWeekly = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text('Weekly',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors
                          .white, 
                    ),),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showWeekly = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text('Monthly',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors
                          .white, 
                    ),),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                showWeekly ? 'Weekly Summary' : 'Monthly Summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              _buildExpenseChart(summary, showWeekly),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpenseChart(Map<String, double> summary, bool isWeekly) {
    List<String> labels = isWeekly
        ? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'] 
        : _getLastSixMonths(); 

    Map<String, double> formattedSummary = {
      for (var label in labels) label: summary[label] ?? 0.0,
    };


    double maxValue = formattedSummary.values.isNotEmpty
        ? formattedSummary.values.reduce((a, b) => a > b ? a : b)
        : 1;


    String centerItem = isWeekly ? _getCurrentDay() : _getCurrentMonth();

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: formattedSummary.entries.map((entry) {
          double barHeight = (entry.value / maxValue) * 150;
          barHeight = barHeight.isFinite && barHeight > 0
              ? barHeight
              : 10; 


          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (entry.value > 0)
                Text(
                  '₹${entry.value.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              const SizedBox(height: 4),

              Container(
                width:
                    entry.key == centerItem ? 30 : 20, 
                height: barHeight,
                decoration: BoxDecoration(
                  color: entry.key == centerItem && entry.value > 100
                      ? Colors.red 
                      : Colors.yellow, 
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 4),

              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: entry.key == centerItem
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _getCurrentDay() {
    int weekday = DateTime.now().weekday;
    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7]; 
  }

  List<String> _getLastSixMonths() {
    DateTime now = DateTime.now();
    List<String> months = [];
    for (int i = 5; i >= 0; i--) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      months.add(_monthToString(month.month));
    }
    return months;
  }

  String _getCurrentMonth() {
    DateTime now = DateTime.now();
    return _monthToString(now.month);
  }

  String _monthToString(int month) {
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }
}
