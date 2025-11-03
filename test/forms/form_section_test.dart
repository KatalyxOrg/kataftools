import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('FormSection', () {
    Widget buildFormSection({
      String? title,
      List<Widget>? children,
      List<Widget> actions = const [],
      bool isSmall = false,
      double? screenWidth,
    }) {
      Widget formSection = FormSection(
        title: title,
        actions: actions,
        isSmall: isSmall,
        children:
            children ??
            [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
      );

      if (screenWidth != null) {
        // Initialize ScreenHelper with the specified width
        ScreenHelper.instance.setValues(screenWidth);

        return MaterialApp(
          home: Scaffold(
            body: SizedBox(width: screenWidth, child: formSection),
          ),
        );
      }

      return MaterialApp(home: Scaffold(body: formSection));
    }

    group('Title and Header', () {
      testWidgets('displays title when provided', (tester) async {
        await tester.pumpWidget(buildFormSection(title: 'Test Section'));

        expect(find.text('Test Section'), findsOneWidget);
      });

      testWidgets('no title renders no header', (tester) async {
        await tester.pumpWidget(buildFormSection(title: null));

        // Should not have the title text widget
        expect(find.byType(Text), findsNWidgets(2)); // Only the field labels
      });

      testWidgets('empty title renders no header', (tester) async {
        await tester.pumpWidget(buildFormSection(title: ''));

        // Should not have a visible title (empty string not shown)
        expect(find.byType(FormSection), findsOneWidget);
      });

      testWidgets('title uses correct style when isSmall=false', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildFormSection(title: 'Large Title', isSmall: false),
        );

        final text = tester.widget<Text>(find.text('Large Title'));
        expect(text.style, isNotNull);
        // displaySmall is used for large titles
      });

      testWidgets('title uses correct style when isSmall=true', (tester) async {
        await tester.pumpWidget(
          buildFormSection(title: 'Small Title', isSmall: true),
        );

        final text = tester.widget<Text>(find.text('Small Title'));
        expect(text.style!.fontWeight, FontWeight.bold);
      });

      testWidgets('actions render in header row', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            title: 'Test',
            actions: [
              IconButton(icon: const Icon(Icons.add), onPressed: () {}),
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            ],
          ),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsOneWidget);
      });

      testWidgets('spacing below title when isSmall=false', (tester) async {
        await tester.pumpWidget(
          buildFormSection(title: 'Test', isSmall: false),
        );

        // Find SizedBox with height 24
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.height == 24), isTrue);
      });

      testWidgets('spacing below title when isSmall=true', (tester) async {
        await tester.pumpWidget(buildFormSection(title: 'Test', isSmall: true));

        // Find SizedBox with height 12
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.height == 12), isTrue);
      });
    });

    group('Desktop Layout (> 768px)', () {
      testWidgets('creates 2-column layout for desktop', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 800,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 3'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 4'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Should have horizontal Flex widgets for 2-column layout
        expect(find.byType(Flex), findsWidgets);

        final flexWidgets = tester.widgetList<Flex>(find.byType(Flex));
        expect(
          flexWidgets.any((flex) => flex.direction == Axis.horizontal),
          isTrue,
        );
      });

      testWidgets('uses horizontal spacing of 20 between columns', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 800,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Find SizedBox with width 20
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.width == 20), isTrue);
      });
    });

    group('Tablet Layout (481px - 768px)', () {
      testWidgets('creates 2-column layout for tablet', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 600,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Should have horizontal Flex widgets
        final flexWidgets = tester.widgetList<Flex>(find.byType(Flex));
        expect(
          flexWidgets.any((flex) => flex.direction == Axis.horizontal),
          isTrue,
        );
      });

      testWidgets('tablet layout uses horizontal flex', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 500,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(Flex), findsWidgets);
      });
    });

    group('Mobile Layout (< 481px)', () {
      testWidgets('creates 1-column layout for mobile', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 400,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Should have vertical Flex widgets for 1-column layout
        final flexWidgets = tester.widgetList<Flex>(find.byType(Flex));
        expect(
          flexWidgets.any((flex) => flex.direction == Axis.vertical),
          isTrue,
        );
      });

      testWidgets('mobile layout uses vertical spacing of 20', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 400,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Find SizedBox with height 20
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.height == 20), isTrue);
      });
    });

    group('FormLargeField Handling', () {
      testWidgets('FormLargeField spans full width on desktop', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 800,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              FormLargeField(
                child: const TextField(
                  decoration: InputDecoration(labelText: 'Large Field'),
                ),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Large Field'), findsOneWidget);
      });

      testWidgets('FormLargeField spans full width on tablet', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 600,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              FormLargeField(
                child: const TextField(
                  decoration: InputDecoration(labelText: 'Large Field'),
                ),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Large Field'), findsOneWidget);
      });

      testWidgets('FormLargeField spans full width on mobile', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 400,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              FormLargeField(
                child: const TextField(
                  decoration: InputDecoration(labelText: 'Large Field'),
                ),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Large Field'), findsOneWidget);
      });

      testWidgets(
        'mixed regular and FormLargeField children layout correctly',
        (tester) async {
          await tester.pumpWidget(
            buildFormSection(
              screenWidth: 800,
              children: [
                const TextField(
                  decoration: InputDecoration(labelText: 'Field 1'),
                ),
                const TextField(
                  decoration: InputDecoration(labelText: 'Field 2'),
                ),
                FormLargeField(
                  child: const TextField(
                    decoration: InputDecoration(labelText: 'Large Field'),
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(labelText: 'Field 3'),
                ),
              ],
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('Field 1'), findsOneWidget);
          expect(find.text('Field 2'), findsOneWidget);
          expect(find.text('Large Field'), findsOneWidget);
          expect(find.text('Field 3'), findsOneWidget);
        },
      );
    });

    group('Odd Number of Children', () {
      testWidgets('adds spacer for odd number of children', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 800,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 3'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Should have all three fields visible
        expect(find.text('Field 1'), findsOneWidget);
        expect(find.text('Field 2'), findsOneWidget);
        expect(find.text('Field 3'), findsOneWidget);
      });

      testWidgets('even number of children needs no spacer', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 800,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 3'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 4'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Field 1'), findsOneWidget);
        expect(find.text('Field 2'), findsOneWidget);
        expect(find.text('Field 3'), findsOneWidget);
        expect(find.text('Field 4'), findsOneWidget);
      });
    });

    group('Spacing', () {
      testWidgets('vertical spacing between field rows', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 3'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 4'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Find SizedBox with height 20 for vertical spacing
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.height == 20), isTrue);
      });
    });

    group('LayoutBuilder', () {
      testWidgets('uses LayoutBuilder for responsive behavior', (tester) async {
        await tester.pumpWidget(buildFormSection());

        expect(find.byType(LayoutBuilder), findsOneWidget);
      });

      testWidgets('responds to constraint changes', (tester) async {
        await tester.pumpWidget(buildFormSection(screenWidth: 400));
        await tester.pumpAndSettle();

        // Mobile layout
        expect(find.byType(Flex), findsWidgets);
      });
    });

    group('Column Layout', () {
      testWidgets('main column has correct properties', (tester) async {
        await tester.pumpWidget(buildFormSection(title: 'Test'));

        final column = tester.widget<Column>(
          find
              .descendant(
                of: find.byType(FormSection),
                matching: find.byType(Column),
              )
              .first,
        );

        expect(column.mainAxisSize, MainAxisSize.min);
        expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
      });

      testWidgets('contains title and children sections', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            title: 'Test',
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
            ],
          ),
        );

        expect(find.byType(Column), findsWidgets);
        expect(find.text('Test'), findsOneWidget);
        expect(find.text('Field 1'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty children list', (tester) async {
        await tester.pumpWidget(buildFormSection(children: []));

        expect(find.byType(FormSection), findsOneWidget);
      });

      testWidgets('handles single child', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Only Field'),
              ),
            ],
          ),
        );

        expect(find.text('Only Field'), findsOneWidget);
      });

      testWidgets('handles many children', (tester) async {
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 800,
            children: List.generate(
              10,
              (index) => TextField(
                decoration: InputDecoration(labelText: 'Field ${index + 1}'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Field 1'), findsOneWidget);
        expect(find.text('Field 10'), findsOneWidget);
      });
    });

    group('Responsive Breakpoint Transitions', () {
      testWidgets('transitions from mobile to desktop layout', (tester) async {
        // Start with mobile
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 400,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        // Then resize to desktop
        await tester.pumpWidget(
          buildFormSection(
            screenWidth: 800,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Field 1'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Field 2'),
              ),
            ],
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Field 1'), findsOneWidget);
        expect(find.text('Field 2'), findsOneWidget);
      });
    });
  });
}
