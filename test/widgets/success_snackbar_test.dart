import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('SuccessSnackbar', () {
    testWidgets('shows snackbar when show is called', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, 'Test success message');
                  },
                  child: const Text('Show Success'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the snackbar
      await tester.tap(find.text('Show Success'));
      await tester.pump();

      // Verify snackbar is displayed
      expect(find.text('Test success message'), findsOneWidget);
    });

    testWidgets('displays correct success message', (WidgetTester tester) async {
      const successMessage = 'Operation completed successfully';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, successMessage);
                  },
                  child: const Text('Show Success'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      expect(find.text(successMessage), findsOneWidget);
    });

    testWidgets('uses green background color', (WidgetTester tester) async {
      const successMessage = 'Success message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, successMessage);
                  },
                  child: const Text('Show Success'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      // Find the SnackBar widget
      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, Colors.green[50]);
    });

    testWidgets('uses dark green text color', (WidgetTester tester) async {
      const successMessage = 'Success message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, successMessage);
                  },
                  child: const Text('Show Success'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      // Find the Text widget inside the snackbar
      final textFinder = find.text(successMessage);
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.color, Colors.green[900]);
    });

    testWidgets('works with ScaffoldMessenger', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, 'Test');
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      // Verify the snackbar is in the widget tree
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('handles multiple consecutive calls', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        SuccessSnackbar.show(context, 'First success');
                      },
                      child: const Text('Show First'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SuccessSnackbar.show(context, 'Second success');
                      },
                      child: const Text('Show Second'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show First'));
      await tester.pumpAndSettle();

      expect(find.text('First success'), findsOneWidget);

      // Note: ScaffoldMessenger queues snackbars
      await tester.tap(find.text('Show Second'));
      await tester.pump();

      // Second snackbar is queued
      expect(find.byType(SnackBar), findsWidgets);
    });

    testWidgets('handles long success messages', (WidgetTester tester) async {
      const longMessage = 'This is a very long success message that should still be displayed correctly in the snackbar without any issues';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, longMessage);
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('handles empty success message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, '');
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      // Snackbar should still be created even with empty message
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('works in MaterialApp without explicit theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SuccessSnackbar.show(context, 'Default theme success');
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Default theme success'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('alternating with error snackbar works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        SuccessSnackbar.show(context, 'Success');
                      },
                      child: const Text('Show Success'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ErrorSnackbar.show(context, 'Error');
                      },
                      child: const Text('Show Error'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Show success first
      await tester.tap(find.text('Show Success'));
      await tester.pump();
      expect(find.text('Success'), findsOneWidget);

      // Show error (gets queued/shown)
      await tester.tap(find.text('Show Error'));
      await tester.pump();

      // Both snackbars exist in the queue
      expect(find.byType(SnackBar), findsWidgets);
    });
  });
}
