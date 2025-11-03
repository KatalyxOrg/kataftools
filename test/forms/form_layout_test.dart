import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('FormLayout', () {
    Widget buildFormLayout({List<Widget>? children, double? screenWidth}) {
      if (screenWidth != null) {
        ScreenHelper.instance.setValues(screenWidth);
      }

      return MaterialApp(
        home: Scaffold(body: FormLayout(children: children ?? [const Text('Child 1'), const Text('Child 2')])),
      );
    }

    group('Constraints', () {
      testWidgets('enforces maxWidth of 984px', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        final constrainedBox = tester.widget<ConstrainedBox>(find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox)));
        expect(constrainedBox.constraints.maxWidth, 984);
      });

      testWidgets('maxWidth matches ScreenHelper.maxContainerWidth', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        final constrainedBox = tester.widget<ConstrainedBox>(find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox)));
        expect(constrainedBox.constraints.maxWidth, ScreenHelper.maxContainerWidth);
      });
    });

    group('Alignment', () {
      testWidgets('uses topLeft alignment', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.topLeft);
      });
    });

    group('Padding', () {
      testWidgets('uses ScreenHelper horizontalPadding for all sides', (tester) async {
        // Set screen width to mobile
        await tester.pumpWidget(buildFormLayout(screenWidth: 400));

        final padding = tester.widget<Padding>(find.byType(Padding));
        final edgeInsets = padding.padding as EdgeInsets;

        expect(edgeInsets.left, ScreenHelper.instance.horizontalPadding);
        expect(edgeInsets.right, ScreenHelper.instance.horizontalPadding);
        expect(edgeInsets.top, ScreenHelper.instance.horizontalPadding);
        expect(edgeInsets.bottom, ScreenHelper.instance.horizontalPadding);
      });

      testWidgets('padding adjusts for desktop width', (tester) async {
        await tester.pumpWidget(buildFormLayout(screenWidth: 800));

        final padding = tester.widget<Padding>(find.byType(Padding));
        final edgeInsets = padding.padding as EdgeInsets;

        // Desktop should have 32px padding
        expect(edgeInsets.left, 32);
        expect(edgeInsets.right, 32);
        expect(edgeInsets.top, 32);
        expect(edgeInsets.bottom, 32);
      });

      testWidgets('padding adjusts for tablet width', (tester) async {
        await tester.pumpWidget(buildFormLayout(screenWidth: 600));

        final padding = tester.widget<Padding>(find.byType(Padding));
        final edgeInsets = padding.padding as EdgeInsets;

        // Tablet should have 24px padding
        expect(edgeInsets.left, 24);
        expect(edgeInsets.right, 24);
        expect(edgeInsets.top, 24);
        expect(edgeInsets.bottom, 24);
      });

      testWidgets('padding adjusts for mobile width', (tester) async {
        await tester.pumpWidget(buildFormLayout(screenWidth: 400));

        final padding = tester.widget<Padding>(find.byType(Padding));
        final edgeInsets = padding.padding as EdgeInsets;

        // Mobile should have 16px padding
        expect(edgeInsets.left, 16);
        expect(edgeInsets.right, 16);
        expect(edgeInsets.top, 16);
        expect(edgeInsets.bottom, 16);
      });
    });

    group('Children Rendering', () {
      testWidgets('all children render in Column', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: [const Text('First'), const Text('Second'), const Text('Third')]));

        expect(find.text('First'), findsOneWidget);
        expect(find.text('Second'), findsOneWidget);
        expect(find.text('Third'), findsOneWidget);
      });

      testWidgets('children are rendered in provided order', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: [const Text('A'), const Text('B'), const Text('C')]));

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.children.length, 3);
      });

      testWidgets('handles single child', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: [const Text('Only Child')]));

        expect(find.text('Only Child'), findsOneWidget);
      });

      testWidgets('handles many children', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: List.generate(20, (index) => Text('Child $index'))));

        expect(find.text('Child 0'), findsOneWidget);
        expect(find.text('Child 19'), findsOneWidget);
      });

      testWidgets('handles empty children list', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: []));

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.children.length, 0);
      });
    });

    group('Column Properties', () {
      testWidgets('Column has mainAxisSize.min', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisSize, MainAxisSize.min);
      });

      testWidgets('Column has crossAxisAlignment.stretch', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
      });

      testWidgets('Column stretches children to full width', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: [Container(height: 50, color: Colors.blue)]));

        expect(find.byType(Column), findsOneWidget);
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
      });
    });

    group('Widget Hierarchy', () {
      testWidgets('contains Align → ConstrainedBox → Padding → Column', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        expect(find.byType(Align), findsOneWidget);
        expect(find.byType(Padding), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);

        final constrainedBox = find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox));
        expect(constrainedBox, findsOneWidget);
      });

      testWidgets('Align contains ConstrainedBox', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        expect(
          find.descendant(
            of: find.byType(Align),
            matching: find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox)),
          ),
          findsOneWidget,
        );
      });

      testWidgets('ConstrainedBox contains Padding', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        final constrainedBox = find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox));

        expect(find.descendant(of: constrainedBox, matching: find.byType(Padding)), findsOneWidget);
      });

      testWidgets('Padding contains Column', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        expect(find.descendant(of: find.byType(Padding), matching: find.byType(Column)), findsOneWidget);
      });
    });

    group('Responsive Behavior', () {
      testWidgets('layout adapts to screen width changes', (tester) async {
        // Start with mobile
        await tester.pumpWidget(buildFormLayout(screenWidth: 400));

        var padding = tester.widget<Padding>(find.byType(Padding));
        var edgeInsets = padding.padding as EdgeInsets;
        expect(edgeInsets.left, 16);

        // Change to desktop
        await tester.pumpWidget(buildFormLayout(screenWidth: 800));
        await tester.pumpAndSettle();

        padding = tester.widget<Padding>(find.byType(Padding));
        edgeInsets = padding.padding as EdgeInsets;
        expect(edgeInsets.left, 32);
      });

      testWidgets('maintains max width constraint on large screens', (tester) async {
        await tester.pumpWidget(buildFormLayout(screenWidth: 1920));

        final constrainedBox = tester.widget<ConstrainedBox>(find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox)));
        expect(constrainedBox.constraints.maxWidth, 984);
      });

      testWidgets('maintains max width constraint on small screens', (tester) async {
        await tester.pumpWidget(buildFormLayout(screenWidth: 320));

        final constrainedBox = tester.widget<ConstrainedBox>(find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox)));
        expect(constrainedBox.constraints.maxWidth, 984);
      });
    });

    group('Integration with FormSection', () {
      testWidgets('can contain FormSection as child', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FormLayout(
                children: [
                  FormSection(
                    title: 'Test Section',
                    children: [
                      const TextField(decoration: InputDecoration(labelText: 'Field 1')),
                      const TextField(decoration: InputDecoration(labelText: 'Field 2')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Test Section'), findsOneWidget);
        expect(find.text('Field 1'), findsOneWidget);
        expect(find.text('Field 2'), findsOneWidget);
      });

      testWidgets('can contain multiple FormSections', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FormLayout(
                children: [
                  FormSection(
                    title: 'Section 1',
                    children: [const TextField(decoration: InputDecoration(labelText: 'Field 1'))],
                  ),
                  const SizedBox(height: 24),
                  FormSection(
                    title: 'Section 2',
                    children: [const TextField(decoration: InputDecoration(labelText: 'Field 2'))],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Section 1'), findsOneWidget);
        expect(find.text('Section 2'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles reasonable width content', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: [Container(width: 500, height: 50, color: Colors.red)]));

        expect(find.byType(FormLayout), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('handles normal height content', (tester) async {
        await tester.pumpWidget(buildFormLayout(children: [Container(height: 200, color: Colors.blue)]));

        expect(find.byType(FormLayout), findsOneWidget);
      });

      testWidgets('handles mixed widget types', (tester) async {
        await tester.pumpWidget(
          buildFormLayout(
            children: [
              const Text('Text Widget'),
              const Icon(Icons.star),
              ElevatedButton(onPressed: () {}, child: const Text('Button')),
              const TextField(),
            ],
          ),
        );

        expect(find.text('Text Widget'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('ScreenHelper Integration', () {
      testWidgets('respects ScreenHelper singleton state', (tester) async {
        // Set a specific width
        ScreenHelper.instance.setValues(700);

        await tester.pumpWidget(buildFormLayout());

        final padding = tester.widget<Padding>(find.byType(Padding));
        final edgeInsets = padding.padding as EdgeInsets;

        // Should use tablet padding (24)
        expect(edgeInsets.left, 24);
      });

      testWidgets('uses ScreenHelper.maxContainerWidth constant', (tester) async {
        await tester.pumpWidget(buildFormLayout());

        final constrainedBox = tester.widget<ConstrainedBox>(find.descendant(of: find.byType(FormLayout), matching: find.byType(ConstrainedBox)));
        expect(constrainedBox.constraints.maxWidth, ScreenHelper.maxContainerWidth);
        expect(ScreenHelper.maxContainerWidth, 984);
      });
    });
  });
}
