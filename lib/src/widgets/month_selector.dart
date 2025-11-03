import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final DateTime selectedMonth;
  final void Function(DateTime) onMonthSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 12),
          iconSize: 12,
          onPressed: () {
            onMonthSelected(DateTime(selectedMonth.year, selectedMonth.month - 1));
          },
        ),
        Flexible(
          child: DropdownButtonFormField(
            value: selectedMonth,
            onChanged: (DateTime? newValue) {
              if (newValue != null) {
                onMonthSelected(newValue);
              }
            },
            items: [
              for (int i = 0; i < 7; ++i)
                if (DateTime(selectedMonth.year, selectedMonth.month + (i - 2)).isBefore(DateTime.now()))
                  DropdownMenuItem(
                    value: DateTime(selectedMonth.year, selectedMonth.month + (i - 2)),
                    child: Text(DateFormat("MMMM yyyy").format(DateTime(selectedMonth.year, selectedMonth.month + (i - 2)))),
                  ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 12),
          iconSize: 12,
          // NOTE : here we can't go to month after current month
          onPressed: (selectedMonth.year == DateTime.now().year && selectedMonth.month == DateTime.now().month)
              ? null
              : () {
                  onMonthSelected(DateTime(selectedMonth.year, selectedMonth.month + 1));
                },
        ),
      ],
    );
  }
}
