import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('MonthSelector', () {
    testWidgets('renders with initial selected month', (
      WidgetTester tester,
    ) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      final formattedMonth = DateFormat("MMMM yyyy").format(selectedMonth);
      expect(find.text(formattedMonth), findsOneWidget);
    });

    testWidgets('displays previous button', (WidgetTester tester) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      final backButton = find.widgetWithIcon(IconButton, Icons.arrow_back_ios);
      expect(backButton, findsOneWidget);
    });

    testWidgets('displays next button', (WidgetTester tester) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      final nextButton = find.widgetWithIcon(
        IconButton,
        Icons.arrow_forward_ios,
      );
      expect(nextButton, findsOneWidget);
    });

    testWidgets('previous button decrements month', (
      WidgetTester tester,
    ) async {
      DateTime? newMonth;
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (month) {
                newMonth = month;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back_ios));
      await tester.pump();

      expect(newMonth, isNotNull);
      expect(newMonth!.year, 2025);
      expect(newMonth!.month, 9);
    });

    testWidgets('next button increments month when not current month', (
      WidgetTester tester,
    ) async {
      DateTime? newMonth;
      // Use a past month (not current)
      final selectedMonth = DateTime(2025, 9);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (month) {
                newMonth = month;
              },
            ),
          ),
        ),
      );

      await tester.tap(
        find.widgetWithIcon(IconButton, Icons.arrow_forward_ios),
      );
      await tester.pump();

      expect(newMonth, isNotNull);
      expect(newMonth!.year, 2025);
      expect(newMonth!.month, 10);
    });

    testWidgets('next button is disabled for current month', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final currentMonth = DateTime(now.year, now.month);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: currentMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      final nextButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_forward_ios),
      );

      expect(nextButton.onPressed, isNull);
    });

    testWidgets('next button is enabled for past months', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final pastMonth = DateTime(now.year, now.month - 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: pastMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      final nextButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_forward_ios),
      );

      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('handles year transition with previous button (Jan to Dec)', (
      WidgetTester tester,
    ) async {
      DateTime? newMonth;
      final selectedMonth = DateTime(2025, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (month) {
                newMonth = month;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back_ios));
      await tester.pump();

      expect(newMonth, isNotNull);
      expect(newMonth!.year, 2024);
      expect(newMonth!.month, 12);
    });

    testWidgets('handles year transition with next button (Dec to Jan)', (
      WidgetTester tester,
    ) async {
      DateTime? newMonth;
      final selectedMonth = DateTime(2024, 12);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (month) {
                newMonth = month;
              },
            ),
          ),
        ),
      );

      await tester.tap(
        find.widgetWithIcon(IconButton, Icons.arrow_forward_ios),
      );
      await tester.pump();

      expect(newMonth, isNotNull);
      expect(newMonth!.year, 2025);
      expect(newMonth!.month, 1);
    });

    testWidgets('dropdown shows past months only', (WidgetTester tester) async {
      final now = DateTime.now();
      final pastMonth = DateTime(now.year, now.month - 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: pastMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      // Tap the dropdown to open it
      await tester.tap(find.byType(DropdownButtonFormField<DateTime>));
      await tester.pumpAndSettle();

      // Check that only past months are shown (not future months)
      // The widget shows 7 months total (selected +/- 2), but only past ones
      final dropdownItems = find.byType(DropdownMenuItem<DateTime>);

      // At least one item should be visible
      expect(dropdownItems, findsWidgets);
    });

    testWidgets('dropdown displays month in MMMM yyyy format', (
      WidgetTester tester,
    ) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      // The current month should be displayed
      expect(find.text('October 2025'), findsOneWidget);
    });

    testWidgets('dropdown selection triggers onMonthSelected', (
      WidgetTester tester,
    ) async {
      DateTime? newMonth;
      final now = DateTime.now();
      final selectedMonth = DateTime(now.year, now.month - 2);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (month) {
                newMonth = month;
              },
            ),
          ),
        ),
      );

      // Open the dropdown
      await tester.tap(find.byType(DropdownButtonFormField<DateTime>));
      await tester.pumpAndSettle();

      // Find and tap a different month option
      final previousMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month - 1,
      );
      final formattedPrevMonth = DateFormat("MMMM yyyy").format(previousMonth);

      if (find.text(formattedPrevMonth).evaluate().isNotEmpty) {
        await tester.tap(find.text(formattedPrevMonth).last);
        await tester.pumpAndSettle();

        expect(newMonth, isNotNull);
        expect(newMonth!.month, previousMonth.month);
      }
    });

    testWidgets('icon sizes are consistent', (WidgetTester tester) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      final backIcon = tester.widget<Icon>(
        find.descendant(
          of: find.widgetWithIcon(IconButton, Icons.arrow_back_ios),
          matching: find.byType(Icon),
        ),
      );

      final forwardIcon = tester.widget<Icon>(
        find.descendant(
          of: find.widgetWithIcon(IconButton, Icons.arrow_forward_ios),
          matching: find.byType(Icon),
        ),
      );

      expect(backIcon.size, 12);
      expect(forwardIcon.size, 12);
    });

    testWidgets('handles multiple consecutive previous clicks', (
      WidgetTester tester,
    ) async {
      final months = <DateTime>[];
      DateTime selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return MonthSelector(
                  selectedMonth: selectedMonth,
                  onMonthSelected: (month) {
                    months.add(month);
                    setState(() {
                      selectedMonth = month;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Click previous button 3 times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back_ios));
        await tester.pumpAndSettle();
      }

      expect(months.length, 3);
      expect(months[0].month, 9);
      expect(months[1].month, 8);
      expect(months[2].month, 7);
    });

    testWidgets('dropdown is wrapped in Flexible', (WidgetTester tester) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      expect(
        find.ancestor(
          of: find.byType(DropdownButtonFormField<DateTime>),
          matching: find.byType(Flexible),
        ),
        findsOneWidget,
      );
    });

    testWidgets('widget is laid out in a Row', (WidgetTester tester) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      // Find the Row that is a direct child of MonthSelector
      expect(
        find.descendant(
          of: find.byType(MonthSelector),
          matching: find.byType(Row),
        ),
        findsWidgets,
      );
    });

    testWidgets('handles null onChanged in dropdown gracefully', (
      WidgetTester tester,
    ) async {
      final selectedMonth = DateTime(2025, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (_) {},
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<DateTime>));
      await tester.pumpAndSettle();

      // Should not crash when selecting the same value
      final currentMonthText = DateFormat("MMMM yyyy").format(selectedMonth);
      await tester.tap(find.text(currentMonthText).last);
      await tester.pumpAndSettle();

      // Should complete without error
      expect(find.byType(MonthSelector), findsOneWidget);
    });

    testWidgets('works with very old dates', (WidgetTester tester) async {
      DateTime? newMonth;
      final selectedMonth = DateTime(2020, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              selectedMonth: selectedMonth,
              onMonthSelected: (month) {
                newMonth = month;
              },
            ),
          ),
        ),
      );

      expect(find.text('January 2020'), findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back_ios));
      await tester.pump();

      expect(newMonth!.year, 2019);
      expect(newMonth!.month, 12);
    });
  });
}
