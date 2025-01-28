import 'package:expense_tracker_app/domain/entities/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/number_pad.dart';
import '../../core/utils/date_utils.dart' as custom_date_utils;
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  AddExpenseBottomSheetState createState() => AddExpenseBottomSheetState();
}

class AddExpenseBottomSheetState extends State<AddExpenseScreen> {
  String _amount = '0';
  String _description = '';
  String _paymentMethod = 'Cash';
  String _category = 'Shopping';  // Default category
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amount = widget.expense!.amount.toStringAsFixed(2);
      _description = widget.expense!.description;
      _category = widget.expense!.category;
      _selectedDate =
          custom_date_utils.DateUtils.parseDate(widget.expense!.date);
    }
  }

  void _onKeypadPress(String value) {
    setState(() {
      if (value == '⌫') {
        _amount =
            _amount.length > 1 ? _amount.substring(0, _amount.length - 1) : '0';
      } else if (value == ',') {
        if (!_amount.contains('.')) _amount += '.';
      } else {
        _amount = _amount == '0' ? value : _amount + value;
      }
    });
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpense() {
    final amount = double.tryParse(_amount) ?? 0.0;
    if (amount <= 0) return;

    final expense = Expense(
      id: widget.expense?.id ?? DateTime.now().millisecondsSinceEpoch,
      amount: amount,
      description: _description,
      category: _category,
      date: custom_date_utils.DateUtils.formatDate(_selectedDate),
    );

    if (widget.expense == null) {
      context.read<ExpenseProvider>().addExpense(context, expense);
    } else {
      context.read<ExpenseProvider>().editExpense(context, expense);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('\u20B9$_amount',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                style:
                                    const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              const Icon(Icons.calendar_month_outlined,
                                  color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Add description...',
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) => _description = value,
                      ),
                      const SizedBox(height: 10),
                      _buildToggleButton(
                          ['Cash', 'Card', 'UPI'], _paymentMethod, (value) {
                        setState(() => _paymentMethod = value);
                      }),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _category,
                        onChanged: (String? newValue) {
                          setState(() {
                            _category = newValue!;
                          });
                        },
                        items: <String>['Food', 'Shopping','Transportation','Utilities','Entertainment', 'Others']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      NumberPad(onKeypadPress: _onKeypadPress),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitExpense,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(), backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.all(24),
                        ),
                        child: const Text('✔'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    List<String> options, String selected, Function(String) onSelected) {
  return ToggleButtons(
    isSelected: options.map((e) => e == selected).toList(),
    onPressed: (index) => onSelected(options[index]),
    borderRadius: BorderRadius.circular(20),
    color: Colors.grey,  // Unselected text color
    selectedColor: Colors.white, // Selected text color
    fillColor: Theme.of(context).primaryColor, // Selected background color
    borderWidth: 1.5,
    selectedBorderColor: Theme.of(context).primaryColor, // Selected border color
    children: options
        .map((e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              e,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )))
        .toList(),
  );
}

}
