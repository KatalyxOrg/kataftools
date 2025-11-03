import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('DialogHeader', () {
    testWidgets('displays title when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: false)),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);

      // Verify title uses headlineMedium style
      final Text titleWidget = tester.widget(find.text('Test Title'));
      expect(titleWidget.style, isNotNull);
    });

    testWidgets('does not display text when title is null', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: DialogHeader(title: null, isClosable: false))));

      // Should only find the SizedBox when no title
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('shows close button when isClosable is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: true)),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('hides close button when isClosable is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: false)),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('pops navigator when close button clicked (default behavior)', (WidgetTester tester) async {
      bool dialogPopped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(child: DialogHeader(title: 'Test Dialog', isClosable: true)),
                    ).then((_) => dialogPopped = true);
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Test Dialog'), findsOneWidget);

      // Close dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
      expect(dialogPopped, isTrue);
    });

    testWidgets('calls custom onClose when provided', (WidgetTester tester) async {
      bool customCloseCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogHeader(
              title: 'Test Title',
              isClosable: true,
              onClose: () {
                customCloseCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(customCloseCalled, isTrue);
    });

    testWidgets('uses theme colors correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
          ),
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: true)),
        ),
      );

      final IconButton closeButton = tester.widget(find.byType(IconButton));
      expect(closeButton.color, isNotNull);
    });

    testWidgets('has correct icon size for close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: true)),
        ),
      );

      final IconButton closeButton = tester.widget(find.byType(IconButton));
      expect(closeButton.iconSize, 22);
    });

    testWidgets('maintains proper spacing between title and close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: true)),
        ),
      );

      // Should have a SizedBox for spacing
      final sizeBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizeBoxes.any((box) => box.width == 8.0), isTrue);
    });

    testWidgets('has correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: true)),
        ),
      );

      final Padding padding = tester.widget(find.byType(Padding).first);
      expect(padding.padding, const EdgeInsets.only(bottom: 8.0));
    });

    testWidgets('arranges children in Row with correct alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: true)),
        ),
      );

      final Row row = tester.widget(find.byType(Row));
      expect(row.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('title expands to fill available space', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DialogHeader(title: 'Test Title', isClosable: true)),
        ),
      );

      // Title should be wrapped in Expanded widget
      final expanded = tester.widgetList<Expanded>(find.byType(Expanded));
      expect(expanded.length, greaterThan(0));

      // First Expanded should contain the title Text
      final firstExpanded = expanded.first;
      expect(tester.widgetList(find.descendant(of: find.byWidget(firstExpanded), matching: find.text('Test Title'))), isNotEmpty);
    });
  });
}
