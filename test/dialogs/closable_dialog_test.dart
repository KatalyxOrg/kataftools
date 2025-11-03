import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('ClosableDialog', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClosableDialog(child: Text('Test Content')),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('renders DialogHeader with title when title is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Title',
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(DialogHeader), findsOneWidget);
    });

    testWidgets('renders DialogHeader without title when title is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClosableDialog(title: null, child: Text('Content')),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(DialogHeader), findsOneWidget);
    });

    testWidgets('renders all action widgets in footer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      actions: [
                        TextButton(onPressed: () {}, child: Text('Cancel')),
                        FilledButton(onPressed: () {}, child: Text('Confirm')),
                      ],
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('actions are aligned to the right', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      actions: [
                        TextButton(onPressed: () {}, child: Text('Action')),
                      ],
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Find the Row containing actions
      final rows = tester.widgetList<Row>(find.byType(Row));
      final actionsRow = rows.firstWhere(
        (row) => row.mainAxisAlignment == MainAxisAlignment.end,
      );
      expect(actionsRow.mainAxisAlignment, MainAxisAlignment.end);
    });

    testWidgets('respects maxWidth constraint', (WidgetTester tester) async {
      const customMaxWidth = 500.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      maxWidth: customMaxWidth,
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final Container container = tester.widget(
        find
            .descendant(
              of: find.byType(Dialog),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.maxWidth, customMaxWidth);
    });

    testWidgets('uses default maxWidth when not specified', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClosableDialog(child: Text('Content')),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final Container container = tester.widget(
        find
            .descendant(
              of: find.byType(Dialog),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.maxWidth, 670);
    });

    testWidgets('close button appears when isClosable is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      isClosable: true,
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('close button hidden when isClosable is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      isClosable: false,
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('clicking close button dismisses dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      isClosable: true,
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('uses ScreenHelper horizontalPadding', (
      WidgetTester tester,
    ) async {
      // Set a specific screen size
      ScreenHelper.instance.setValues(800); // Desktop

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final Container container = tester.widget(
        find
            .descendant(
              of: find.byType(Dialog),
              matching: find.byType(Container),
            )
            .first,
      );

      final padding = container.padding as EdgeInsets;
      expect(padding.horizontal, ScreenHelper.instance.horizontalPadding * 2);
    });

    testWidgets('vertical padding differs when title is provided vs null', (
      WidgetTester tester,
    ) async {
      ScreenHelper.instance.setValues(800);

      // Test with title
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final Container containerWithTitle = tester.widget(
        find
            .descendant(
              of: find.byType(Dialog),
              matching: find.byType(Container),
            )
            .first,
      );

      final paddingWithTitle = containerWithTitle.padding as EdgeInsets;
      expect(
        paddingWithTitle.vertical,
        ScreenHelper.instance.horizontalPadding * 2,
      );

      // Close dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Test without title
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClosableDialog(title: null, child: Text('Content')),
                  );
                },
                child: const Text('Show Dialog 2'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog 2'));
      await tester.pumpAndSettle();

      final Container containerWithoutTitle = tester.widget(
        find
            .descendant(
              of: find.byType(Dialog),
              matching: find.byType(Container),
            )
            .first,
      );

      final paddingWithoutTitle = containerWithoutTitle.padding as EdgeInsets;
      expect(paddingWithoutTitle.vertical, 40); // 20 * 2
    });

    testWidgets('uses theme surface colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClosableDialog(child: Text('Content')),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final Dialog dialog = tester.widget(find.byType(Dialog));
      expect(dialog.backgroundColor, isNotNull);
      expect(dialog.surfaceTintColor, isNotNull);
    });

    testWidgets('has rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClosableDialog(child: Text('Content')),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final Dialog dialog = tester.widget(find.byType(Dialog));
      final shape = dialog.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(8.0));
    });

    testWidgets('child is wrapped in Flexible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClosableDialog(child: Text('Content')),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Find Flexible widget containing the child
      expect(find.byType(Flexible), findsOneWidget);

      final flexible = tester.widget<Flexible>(find.byType(Flexible));
      expect(
        find.descendant(
          of: find.byWidget(flexible),
          matching: find.text('Content'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('has correct spacing between elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ClosableDialog(
                      title: 'Test Dialog',
                      actions: [
                        TextButton(onPressed: () {}, child: Text('OK')),
                      ],
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Should have SizedBox with height 12 after title
      // Should have SizedBox with height 20 before actions
      final sizeBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizeBoxes.any((box) => box.height == 12), isTrue);
      expect(sizeBoxes.any((box) => box.height == 20), isTrue);
    });
  });
}
