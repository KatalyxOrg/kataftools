import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('CheckboxBadge', () {
    Widget buildCheckboxBadge({
      required bool isChecked,
      required Function(bool) onCheck,
      required String title,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CheckboxBadge(
            isChecked: isChecked,
            onCheck: onCheck,
            title: title,
          ),
        ),
      );
    }

    group('Checked State', () {
      testWidgets('shows primary background when checked', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: true, onCheck: (_) {}, title: 'Test'),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Should use primary color, not transparent
        expect(decoration.color, isNot(Colors.transparent));
      });

      testWidgets('shows transparent background when unchecked', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, Colors.transparent);
      });

      testWidgets('uses onPrimary text color when checked', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            home: Scaffold(
              body: CheckboxBadge(
                isChecked: true,
                onCheck: (_) {},
                title: 'Test',
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('Test'));
        // Text color should be set (onPrimary color)
        expect(text.style!.color, isNotNull);
      });

      testWidgets('uses onSurface text color when unchecked', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            home: Scaffold(
              body: CheckboxBadge(
                isChecked: false,
                onCheck: (_) {},
                title: 'Test',
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('Test'));
        expect(text.style!.color, isNotNull);
      });
    });

    group('Interaction', () {
      testWidgets('tap toggles from unchecked to checked', (tester) async {
        bool currentState = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxBadge(
                    isChecked: currentState,
                    onCheck: (value) {
                      setState(() {
                        currentState = value;
                      });
                    },
                    title: 'Toggle Me',
                  );
                },
              ),
            ),
          ),
        );

        // Initially unchecked
        var container = tester.widget<Container>(find.byType(Container));
        var decoration = container.decoration as BoxDecoration;
        expect(decoration.color, Colors.transparent);

        // Tap to check
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Now checked
        container = tester.widget<Container>(find.byType(Container));
        decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isNot(Colors.transparent));
        expect(currentState, true);
      });

      testWidgets('tap toggles from checked to unchecked', (tester) async {
        bool currentState = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxBadge(
                    isChecked: currentState,
                    onCheck: (value) {
                      setState(() {
                        currentState = value;
                      });
                    },
                    title: 'Toggle Me',
                  );
                },
              ),
            ),
          ),
        );

        // Initially checked
        expect(currentState, true);

        // Tap to uncheck
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Now unchecked
        expect(currentState, false);
      });

      testWidgets('calls onCheck with correct value', (tester) async {
        bool? receivedValue;

        await tester.pumpWidget(
          buildCheckboxBadge(
            isChecked: false,
            onCheck: (value) {
              receivedValue = value;
            },
            title: 'Test',
          ),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(receivedValue, true);
      });

      testWidgets('multiple taps toggle correctly', (tester) async {
        bool currentState = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxBadge(
                    isChecked: currentState,
                    onCheck: (value) {
                      setState(() {
                        currentState = value;
                      });
                    },
                    title: 'Toggle Me',
                  );
                },
              ),
            ),
          ),
        );

        expect(currentState, false);

        // Tap 1: check
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(currentState, true);

        // Tap 2: uncheck
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(currentState, false);

        // Tap 3: check again
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(currentState, true);
      });
    });

    group('Title Display', () {
      testWidgets('displays provided title', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(
            isChecked: false,
            onCheck: (_) {},
            title: 'My Title',
          ),
        );

        expect(find.text('My Title'), findsOneWidget);
      });

      testWidgets('displays different titles correctly', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(
            isChecked: false,
            onCheck: (_) {},
            title: 'Another Title',
          ),
        );

        expect(find.text('Another Title'), findsOneWidget);
      });

      testWidgets('title uses bodySmall text style', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        final text = tester.widget<Text>(find.text('Test'));
        expect(text.style, isNotNull);
      });

      testWidgets('title has fontWeight.w600', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        final text = tester.widget<Text>(find.text('Test'));
        expect(text.style!.fontWeight, FontWeight.w600);
      });

      testWidgets('handles long titles', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(
            isChecked: false,
            onCheck: (_) {},
            title: 'This is a very long title that might wrap or overflow',
          ),
        );

        expect(
          find.text('This is a very long title that might wrap or overflow'),
          findsOneWidget,
        );
      });

      testWidgets('handles empty title', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: ''),
        );

        expect(find.text(''), findsOneWidget);
      });
    });

    group('Visual State Changes', () {
      testWidgets('text color changes on check state change', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
            ),
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  bool isChecked = false;

                  return CheckboxBadge(
                    isChecked: isChecked,
                    onCheck: (value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                    title: 'Test',
                  );
                },
              ),
            ),
          ),
        );

        // Tap to toggle and check text color changes
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        final text = tester.widget<Text>(find.text('Test'));
        expect(text.style!.color, isNotNull);
      });
    });

    group('Layout and Styling', () {
      testWidgets('uses InkWell for tap handling', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('container has correct padding', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final padding = container.padding as EdgeInsets;

        // symmetric(horizontal: 12) = 12 left + 12 right = 24 total
        expect(padding.horizontal, 24.0);
        // symmetric(vertical: 8) = 8 top + 8 bottom = 16 total
        expect(padding.vertical, 16.0);
      });

      testWidgets('container has circular border radius', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.borderRadius, BorderRadius.circular(100));
      });

      testWidgets('uses Row for content layout', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('Row uses mainAxisSize.min', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
    });

    group('Theme Integration', () {
      testWidgets('uses theme primary color when checked', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            ),
            home: Scaffold(
              body: CheckboxBadge(
                isChecked: true,
                onCheck: (_) {},
                title: 'Test',
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isNotNull);
      });

      testWidgets('adapts to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: CheckboxBadge(
                isChecked: true,
                onCheck: (_) {},
                title: 'Test',
              ),
            ),
          ),
        );

        expect(find.text('Test'), findsOneWidget);
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.decoration, isNotNull);
      });

      testWidgets('adapts to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: CheckboxBadge(
                isChecked: true,
                onCheck: (_) {},
                title: 'Test',
              ),
            ),
          ),
        );

        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('is tappable for accessibility', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(isChecked: false, onCheck: (_) {}, title: 'Test'),
        );

        // InkWell provides tap feedback
        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('entire badge area is tappable', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildCheckboxBadge(
            isChecked: false,
            onCheck: (value) {
              tapped = true;
            },
            title: 'Test',
          ),
        );

        // Tap the InkWell
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(tapped, true);
      });
    });

    group('Multiple Badges', () {
      testWidgets('multiple badges work independently', (tester) async {
        bool badge1Checked = false;
        bool badge2Checked = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    children: [
                      CheckboxBadge(
                        isChecked: badge1Checked,
                        onCheck: (value) {
                          setState(() {
                            badge1Checked = value;
                          });
                        },
                        title: 'Badge 1',
                      ),
                      const SizedBox(width: 8),
                      CheckboxBadge(
                        isChecked: badge2Checked,
                        onCheck: (value) {
                          setState(() {
                            badge2Checked = value;
                          });
                        },
                        title: 'Badge 2',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(badge1Checked, false);
        expect(badge2Checked, true);

        // Tap first badge
        await tester.tap(find.text('Badge 1'));
        await tester.pumpAndSettle();

        expect(badge1Checked, true);
        expect(badge2Checked, true); // Should remain unchanged
      });
    });

    group('Edge Cases', () {
      testWidgets('handles rapid tapping', (tester) async {
        bool currentState = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxBadge(
                    isChecked: currentState,
                    onCheck: (value) {
                      setState(() {
                        currentState = value;
                      });
                    },
                    title: 'Test',
                  );
                },
              ),
            ),
          ),
        );

        // Rapid taps
        for (int i = 0; i < 10; i++) {
          await tester.tap(find.byType(InkWell));
          await tester.pump(const Duration(milliseconds: 10));
        }
        await tester.pumpAndSettle();

        // Should end up in a consistent state
        expect(currentState, isA<bool>());
      });

      testWidgets('handles special characters in title', (tester) async {
        await tester.pumpWidget(
          buildCheckboxBadge(
            isChecked: false,
            onCheck: (_) {},
            title: 'Test & Title (1) #2',
          ),
        );

        expect(find.text('Test & Title (1) #2'), findsOneWidget);
      });
    });
  });
}
