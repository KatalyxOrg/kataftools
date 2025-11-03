import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('LoadingOverlay', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingOverlay(child: Text('Test Child'))));

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('is hidden by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingOverlay(child: Text('Test Child'))));

      // Loading indicator should not be visible
      expect(find.byType(CircularProgressIndicator), findsNothing);
      // Check for the specific ModalBarrier from LoadingOverlay (with Opacity parent)
      expect(find.ancestor(of: find.byType(ModalBarrier), matching: find.byType(Opacity)), findsNothing);
    });

    testWidgets('show() displays loading overlay', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      LoadingOverlay.of(context).show();
                    },
                    child: const Text('Show Loading'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially no loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap to show loading
      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('show() displays modal barrier', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      LoadingOverlay.of(context).show();
                    },
                    child: const Text('Show Loading'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Check for the modal barrier with opacity wrapper (from LoadingOverlay)
      expect(find.ancestor(of: find.byType(ModalBarrier), matching: find.byType(Opacity)), findsOneWidget);
    });

    testWidgets('hide() removes loading overlay', (WidgetTester tester) async {
      late LoadingOverlayState overlayState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  overlayState = LoadingOverlay.of(context);
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          overlayState.show();
                        },
                        child: const Text('Show Loading'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          overlayState.hide();
                        },
                        child: const Text('Hide Loading'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Show loading
      await tester.tap(find.text('Show Loading'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Hide loading using the state directly (since modal barrier blocks taps)
      overlayState.hide();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('blocks interaction when visible', (WidgetTester tester) async {
      int buttonTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          LoadingOverlay.of(context).show();
                        },
                        child: const Text('Show Loading'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          buttonTapCount++;
                        },
                        child: const Text('Action Button'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Button should work normally when loading is not shown
      await tester.tap(find.text('Action Button'));
      await tester.pump();
      expect(buttonTapCount, 1);

      // Show loading overlay
      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Try to tap the action button - should be blocked by modal barrier
      await tester.tap(find.text('Action Button'), warnIfMissed: false);
      await tester.pump();

      // Button tap count should not increase because modal barrier blocks it
      expect(buttonTapCount, 1);
    });

    testWidgets('modal barrier is dismissible false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      LoadingOverlay.of(context).show();
                    },
                    child: const Text('Show Loading'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Find the ModalBarrier that's wrapped in Opacity (from LoadingOverlay)
      final opacityFinder = find.byType(Opacity);
      final modalBarrierFinder = find.descendant(of: opacityFinder, matching: find.byType(ModalBarrier));

      expect(modalBarrierFinder, findsOneWidget);
      final modalBarrier = tester.widget<ModalBarrier>(modalBarrierFinder);
      expect(modalBarrier.dismissible, false);
    });

    testWidgets('modal barrier has black color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      LoadingOverlay.of(context).show();
                    },
                    child: const Text('Show Loading'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Find the ModalBarrier that's wrapped in Opacity (from LoadingOverlay)
      final opacityFinder = find.byType(Opacity);
      final modalBarrierFinder = find.descendant(of: opacityFinder, matching: find.byType(ModalBarrier));

      final modalBarrier = tester.widget<ModalBarrier>(modalBarrierFinder);
      expect(modalBarrier.color, Colors.black);
    });

    testWidgets('modal barrier has 0.8 opacity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      LoadingOverlay.of(context).show();
                    },
                    child: const Text('Show Loading'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Find the Opacity widget that wraps the ModalBarrier
      final opacities = tester.widgetList<Opacity>(find.byType(Opacity));
      final loadingOpacity = opacities.firstWhere((opacity) => opacity.opacity == 0.8, orElse: () => throw TestFailure('No Opacity with 0.8 found'));
      expect(loadingOpacity.opacity, 0.8);
    });

    testWidgets('of(context) returns correct state', (WidgetTester tester) async {
      LoadingOverlayState? capturedState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      capturedState = LoadingOverlay.of(context);
                    },
                    child: const Text('Get State'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Get State'));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState, isA<LoadingOverlayState>());
    });

    testWidgets('multiple show calls work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      LoadingOverlay.of(context).show();
                      LoadingOverlay.of(context).show();
                    },
                    child: const Text('Show Loading'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Should still show only one loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Check for the modal barrier with opacity wrapper
      expect(find.ancestor(of: find.byType(ModalBarrier), matching: find.byType(Opacity)), findsOneWidget);
    });

    testWidgets('multiple hide calls work correctly', (WidgetTester tester) async {
      late LoadingOverlayState overlayState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  overlayState = LoadingOverlay.of(context);
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          overlayState.show();
                        },
                        child: const Text('Show Loading'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          overlayState.hide();
                          overlayState.hide();
                        },
                        child: const Text('Hide Loading'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Call hide multiple times
      overlayState.hide();
      overlayState.hide();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('works with complex child widget tree', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Column(
                children: [
                  const Text('Header'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text('Item $index'));
                      },
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          LoadingOverlay.of(context).show();
                        },
                        child: const Text('Load'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);

      await tester.tap(find.text('Load'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('CircularProgressIndicator is centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      LoadingOverlay.of(context).show();
                    },
                    child: const Text('Show Loading'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      expect(find.ancestor(of: find.byType(CircularProgressIndicator), matching: find.byType(Center)), findsOneWidget);
    });

    testWidgets('child remains visible when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      const Text('Visible Content'),
                      ElevatedButton(
                        onPressed: () {
                          LoadingOverlay.of(context).show();
                        },
                        child: const Text('Show Loading'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loading'));
      await tester.pump();

      // Child should still be visible (though blocked by barrier)
      expect(find.text('Visible Content'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
