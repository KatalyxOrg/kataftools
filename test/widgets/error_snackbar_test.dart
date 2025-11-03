import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('ErrorSnackbar', () {
    testWidgets('shows snackbar when show is called', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, 'Test error message');
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the snackbar
      await tester.tap(find.text('Show Error'));
      await tester.pump();

      // Verify snackbar is displayed
      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('displays correct error message', (WidgetTester tester) async {
      const errorMessage = 'This is a specific error message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, errorMessage);
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('uses theme errorContainer color for background', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Error message';

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              errorContainer: Color(0xFFFFDAD6),
            ),
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, errorMessage);
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      // Find the SnackBar widget
      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, const Color(0xFFFFDAD6));
    });

    testWidgets('uses theme onErrorContainer color for text', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Error message';

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              errorContainer: Color(0xFFFFDAD6),
              onErrorContainer: Color(0xFF410002),
            ),
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, errorMessage);
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      // Find the Text widget inside the snackbar
      final textFinder = find.text(errorMessage);
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.color, const Color(0xFF410002));
    });

    testWidgets('works with ScaffoldMessenger', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, 'Test');
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

    testWidgets('handles multiple consecutive calls', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ErrorSnackbar.show(context, 'First error');
                      },
                      child: const Text('Show First'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ErrorSnackbar.show(context, 'Second error');
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

      expect(find.text('First error'), findsOneWidget);

      // Note: ScaffoldMessenger queues snackbars, so showing second immediately
      // may not fully replace the first in all scenarios. Just verify it appears.
      await tester.tap(find.text('Show Second'));
      await tester.pump();

      // Second snackbar is queued
      expect(find.byType(SnackBar), findsWidgets);
    });

    testWidgets('handles long error messages', (WidgetTester tester) async {
      const longMessage =
          'This is a very long error message that should still be displayed correctly in the snackbar without any issues';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, longMessage);
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

    testWidgets('handles empty error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, '');
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

    testWidgets('works with dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ErrorSnackbar.show(context, 'Dark theme error');
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

      expect(find.text('Dark theme error'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
