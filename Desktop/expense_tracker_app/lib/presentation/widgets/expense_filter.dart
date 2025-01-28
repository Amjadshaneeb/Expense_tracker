import 'package:flutter/material.dart';

class ExpenseFilter extends StatelessWidget {
  final Function(DateTime, DateTime) onDateRangeSelected;

  const ExpenseFilter({super.key, required this.onDateRangeSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                backgroundColor:
                    Theme.of(context).primaryColor, 
                textStyle:
                    Theme.of(context).textTheme.bodyMedium, 
              ),
              onPressed: () async {
                DateTimeRange? pickedDateRange = await showDateRangePicker(
                  context: context,
                  initialDateRange: DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now().add(const Duration(days: 1)),
                  ),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDateRange != null) {
                  DateTime startDate = DateTime(
                      pickedDateRange.start.year,
                      pickedDateRange.start.month,
                      pickedDateRange.start.day,
                      0,
                      0,
                      0);
                  DateTime endDate = DateTime(
                      pickedDateRange.end.year,
                      pickedDateRange.end.month,
                      pickedDateRange.end.day,
                      23,
                      59,
                      59);

                  onDateRangeSelected(startDate, endDate);
                }
              },
              child: Text(
                'Filter by Date',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors
                          .white, 
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
