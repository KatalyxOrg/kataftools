import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('ConfirmationDialog', () {
    testWidgets('renders with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ConfirmationDialog(title: 'Confirm Action'),
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

      expect(find.text('Confirm Action'), findsOneWidget);
    });

    testWidgets('displays default cancel button with "Annuler" text', (
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
                    builder: (context) => ConfirmationDialog(title: 'Confirm'),
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

      expect(find.text('Annuler'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Annuler'), findsOneWidget);
    });

    testWidgets('displays default confirm button with "Continuer" text', (
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
                    builder: (context) => ConfirmationDialog(title: 'Confirm'),
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

      expect(find.text('Continuer'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Continuer'), findsOneWidget);
    });

    testWidgets('cancel button returns false when clicked', (
      WidgetTester tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmationDialog(title: 'Confirm'),
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

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('confirm button returns true when clicked', (
      WidgetTester tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmationDialog(title: 'Confirm'),
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

      await tester.tap(find.text('Continuer'));
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('uses custom cancel button label when provided', (
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
                    builder: (context) => ConfirmationDialog(
                      title: 'Confirm',
                      cancelButtonLabel: 'Custom Cancel',
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

      expect(find.text('Custom Cancel'), findsOneWidget);
      expect(find.text('Annuler'), findsNothing);
    });

    testWidgets('uses custom validation button label when provided', (
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
                    builder: (context) => ConfirmationDialog(
                      title: 'Confirm',
                      validationButtonLabel: 'Custom Confirm',
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

      expect(find.text('Custom Confirm'), findsOneWidget);
      expect(find.text('Continuer'), findsNothing);
    });

    group('Deletion Confirmation', () {
      testWidgets(
        'shows "Supprimer" as default confirm button text when isDeletationConfirmation is true',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Delete Item',
                          isDeletationConfirmation: true,
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

          expect(find.text('Supprimer'), findsOneWidget);
          expect(find.text('Continuer'), findsNothing);
        },
      );

      testWidgets(
        'applies red styling to confirm button when isDeletationConfirmation is true',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Delete Item',
                          isDeletationConfirmation: true,
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

          final FilledButton confirmButton = tester.widget(
            find.widgetWithText(FilledButton, 'Supprimer'),
          );

          final ButtonStyle? style = confirmButton.style;
          expect(style, isNotNull);

          // Check that backgroundColor is set to red
          final backgroundColor = style!.backgroundColor?.resolve({});
          expect(backgroundColor, Colors.red);

          // Check that foregroundColor is set to white
          final foregroundColor = style.foregroundColor?.resolve({});
          expect(foregroundColor, Colors.white);
        },
      );

      testWidgets(
        'shows default deletion content when isDeletationConfirmation is true and no custom content',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Delete Item',
                          isDeletationConfirmation: true,
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

          expect(
            find.text('Êtes-vous sûr de vouloir supprimer ?'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'does not apply red styling when isDeletationConfirmation is false',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Confirm',
                          isDeletationConfirmation: false,
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

          final FilledButton confirmButton = tester.widget(
            find.widgetWithText(FilledButton, 'Continuer'),
          );

          final ButtonStyle? style = confirmButton.style;

          // Check that backgroundColor is null (uses default theme color)
          final backgroundColor = style?.backgroundColor?.resolve({});
          expect(backgroundColor, isNull);

          // Check that foregroundColor is null (uses default theme color)
          final foregroundColor = style?.foregroundColor?.resolve({});
          expect(foregroundColor, isNull);
        },
      );

      testWidgets(
        'custom validationButtonLabel overrides "Supprimer" even when isDeletationConfirmation is true',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Delete Item',
                          isDeletationConfirmation: true,
                          validationButtonLabel: 'Remove Forever',
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

          expect(find.text('Remove Forever'), findsOneWidget);
          expect(find.text('Supprimer'), findsNothing);
        },
      );
    });

    testWidgets('displays custom content when provided', (
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
                    builder: (context) => ConfirmationDialog(
                      title: 'Confirm',
                      content: 'This is custom content',
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

      expect(find.text('This is custom content'), findsOneWidget);
    });

    testWidgets(
      'shows default content when content is null and isDeletationConfirmation is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ConfirmationDialog(title: 'Confirm'),
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

        expect(
          find.text('Êtes-vous sûr de vouloir continuer ?'),
          findsOneWidget,
        );
      },
    );

    testWidgets('uses ClosableDialog as base', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(title: 'Confirm'),
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

      expect(find.byType(ClosableDialog), findsOneWidget);
    });

    testWidgets('has close button (from ClosableDialog)', (
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
                    builder: (context) => ConfirmationDialog(title: 'Confirm'),
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

    testWidgets('buttons are in correct order (cancel, then confirm)', (
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
                    builder: (context) => ConfirmationDialog(title: 'Confirm'),
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
      final cancelButton = find.widgetWithText(TextButton, 'Annuler');
      final confirmButton = find.widgetWithText(FilledButton, 'Continuer');

      expect(cancelButton, findsOneWidget);
      expect(confirmButton, findsOneWidget);

      // Get positions to verify order
      final cancelOffset = tester.getTopLeft(cancelButton);
      final confirmOffset = tester.getTopLeft(confirmButton);

      // Cancel should be to the left of Confirm
      expect(cancelOffset.dx < confirmOffset.dx, isTrue);
    });
  });
}
