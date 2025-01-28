import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onKeypadPress;

  const NumberPad({required this.onKeypadPress, super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      '⌫'
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        final button = buttons[index];
        return GestureDetector(
          onTap: () => onKeypadPress(button),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: button == '⌫' ? Colors.red.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              button,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
