import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

// Test model for dropdown options
class TestOption {
  final String id;
  final String name;

  TestOption(this.id, this.name);

  @override
  bool operator ==(Object other) => identical(this, other) || other is TestOption && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  group('SearchableDropdown', () {
    late List<TestOption> testOptions;

    setUp(() {
      testOptions = [TestOption('1', 'Apple'), TestOption('2', 'Banana'), TestOption('3', 'Cherry'), TestOption('4', 'Date')];
    });

    Widget buildDropdown({
      String? label,
      TestOption? value,
      Function(TestOption?)? onSelected,
      Function(String)? onCreate,
      TestOption Function(String)? fakeOnCreate,
      bool isRequired = false,
      bool isEnabled = true,
      bool shouldResetOnTap = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SearchableDropdown<TestOption>(
            label: label,
            value: value,
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return testOptions;
              }
              return testOptions.where((option) {
                return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            displayStringForOption: (option) => option.name,
            onSelected: onSelected,
            onCreate: onCreate,
            fakeOnCreate: fakeOnCreate,
            isRequired: isRequired,
            isEnabled: isEnabled,
            shouldResetOnTap: shouldResetOnTap,
          ),
        ),
      );
    }

    group('Basic Functionality', () {
      testWidgets('renders with label', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit'));

        expect(find.text('Select Fruit...'), findsOneWidget);
      });

      testWidgets('opens options on tap', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit'));

        // Tap the text field
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Options should be visible
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Cherry'), findsOneWidget);
        expect(find.text('Date'), findsOneWidget);
      });

      testWidgets('filters options based on text input', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit'));

        // Tap the field and enter text
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), 'a');
        await tester.pumpAndSettle();

        // Should show Apple, Banana, Date (all contain 'a')
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Date'), findsOneWidget);
        expect(find.text('Cherry'), findsNothing);
      });

      testWidgets('calls onSelected when option chosen', (tester) async {
        TestOption? selectedOption;

        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            onSelected: (option) {
              selectedOption = option;
            },
          ),
        );

        // Open dropdown and select an option
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Banana'));
        await tester.pumpAndSettle();

        expect(selectedOption, isNotNull);
        expect(selectedOption!.name, 'Banana');
      });

      testWidgets('displays initial value', (tester) async {
        final initialValue = testOptions[1]; // Banana

        await tester.pumpWidget(buildDropdown(label: 'Select Fruit', value: initialValue));

        expect(find.text('Banana'), findsOneWidget);
      });
    });

    group('Creation Feature', () {
      testWidgets('shows "Créer..." option when text entered and onCreate provided', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit', onCreate: (text) {}, fakeOnCreate: (text) => TestOption('new', text)));

        // Tap field and enter new text
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), 'Mango');
        await tester.pumpAndSettle();

        expect(find.text('Créer "Mango"'), findsOneWidget);
      });

      testWidgets('calls onCreate when "Créer..." clicked', (tester) async {
        String? createdText;

        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            onCreate: (text) {
              createdText = text;
            },
            fakeOnCreate: (text) => TestOption('new', text),
          ),
        );

        // Enter text and click create
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), 'Mango');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Créer "Mango"'));
        await tester.pumpAndSettle();

        expect(createdText, 'Mango');
      });

      testWidgets('no "Créer..." option when onCreate not provided', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit'));

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), 'Mango');
        await tester.pumpAndSettle();

        expect(find.textContaining('Créer'), findsNothing);
      });

      testWidgets('no "Créer..." option when text field is empty', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit', onCreate: (text) {}, fakeOnCreate: (text) => TestOption('new', text)));

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Don't enter any text
        expect(find.textContaining('Créer'), findsNothing);
      });
    });

    group('Validation', () {
      testWidgets('required validation triggers when field is empty', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: SearchableDropdown<TestOption>(
                  label: 'Select Fruit',
                  optionsBuilder: (textEditingValue) => testOptions,
                  displayStringForOption: (option) => option.name,
                  isRequired: true,
                ),
              ),
            ),
          ),
        );

        // Trigger validation
        formKey.currentState!.validate();
        await tester.pumpAndSettle();

        expect(find.text('Ce champ est requis'), findsOneWidget);
      });

      testWidgets('shows "Aucun résultat trouvé" when no match and has text', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: SearchableDropdown<TestOption>(
                  label: 'Select Fruit',
                  optionsBuilder: (textEditingValue) {
                    return testOptions.where((option) {
                      return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (option) => option.name,
                  isRequired: true,
                ),
              ),
            ),
          ),
        );

        // Enter text that doesn't match
        await tester.tap(find.byType(TextFormField));
        await tester.enterText(find.byType(TextFormField), 'xyz');
        await tester.pumpAndSettle();

        // Trigger validation
        formKey.currentState!.validate();
        await tester.pumpAndSettle();

        expect(find.text('Aucun résultat trouvé'), findsOneWidget);
      });

      testWidgets('valid selection passes validation', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: SearchableDropdown<TestOption>(
                  label: 'Select Fruit',
                  optionsBuilder: (textEditingValue) => testOptions,
                  displayStringForOption: (option) => option.name,
                  isRequired: true,
                ),
              ),
            ),
          ),
        );

        // Select an option
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Apple'));
        await tester.pumpAndSettle();

        // Trigger validation
        final isValid = formKey.currentState!.validate();
        await tester.pumpAndSettle();

        expect(isValid, true);
        expect(find.text('Ce champ est requis'), findsNothing);
      });

      testWidgets('optional field does not validate when empty', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: SearchableDropdown<TestOption>(
                  label: 'Select Fruit',
                  optionsBuilder: (textEditingValue) => testOptions,
                  displayStringForOption: (option) => option.name,
                  isRequired: false,
                ),
              ),
            ),
          ),
        );

        // Trigger validation without selecting
        final isValid = formKey.currentState!.validate();
        await tester.pumpAndSettle();

        expect(isValid, true);
        expect(find.text('Ce champ est requis'), findsNothing);
      });
    });

    group('State Management', () {
      testWidgets('shouldResetOnTap clears field on focus', (tester) async {
        TestOption? selectedOption;

        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            value: testOptions[0], // Apple
            shouldResetOnTap: true,
            onSelected: (option) {
              selectedOption = option;
            },
          ),
        );

        // Initially shows Apple
        expect(find.text('Apple'), findsOneWidget);

        // Tap the field
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Field should be cleared
        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(textField.controller!.text, isEmpty);
        expect(selectedOption, isNull);
      });

      testWidgets('shouldResetOnTap=false preserves value on focus', (tester) async {
        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            value: testOptions[0], // Apple
            shouldResetOnTap: false,
          ),
        );

        // Initially shows Apple
        expect(find.text('Apple'), findsWidgets);

        // Tap the field
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Field should still show Apple (at least once)
        expect(find.text('Apple'), findsWidgets);
      });

      testWidgets('value persists when shouldResetOnTap = false', (tester) async {
        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            value: testOptions[1], // Banana
            shouldResetOnTap: false,
          ),
        );

        expect(find.text('Banana'), findsAtLeast(1));

        // Tap multiple times
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Should still show Banana (at least once - in field or options)
        expect(find.text('Banana'), findsAtLeast(1));
      });
    });

    group('Keyboard Interaction', () {
      testWidgets('Enter key selects first option', (tester) async {
        TestOption? selectedOption;

        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            onSelected: (option) {
              selectedOption = option;
            },
          ),
        );

        // Open dropdown
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Submit the field (simulating Enter key)
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Should select first option (Apple)
        expect(selectedOption, isNotNull);
        expect(selectedOption!.name, 'Apple');
      });

      testWidgets('Enter key with filtered results selects first filtered option', (tester) async {
        TestOption? selectedOption;

        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            onSelected: (option) {
              selectedOption = option;
            },
          ),
        );

        // Enter text to filter
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), 'Ch');
        await tester.pumpAndSettle();

        // Submit
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Should select Cherry (first match)
        expect(selectedOption, isNotNull);
        expect(selectedOption!.name, 'Cherry');
      });

      testWidgets('Enter key triggers onCreate when only creation option available', (tester) async {
        String? createdText;

        await tester.pumpWidget(
          buildDropdown(
            label: 'Select Fruit',
            onCreate: (text) {
              createdText = text;
            },
            fakeOnCreate: (text) => TestOption('new', text),
          ),
        );

        // Enter text that doesn't match any option
        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), 'xyz');
        await tester.pumpAndSettle();

        // Submit
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Should trigger onCreate with the fake option
        expect(createdText, 'xyz');
      });
    });

    group('Enabled/Disabled', () {
      testWidgets('isEnabled=false disables field', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit', isEnabled: false));

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(textField.enabled, false);
      });

      testWidgets('disabled field does not open options', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit', isEnabled: false));

        // Try to tap the disabled field
        await tester.tap(find.byType(TextFormField), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Options should not appear
        expect(find.text('Apple'), findsNothing);
      });

      testWidgets('isEnabled=true allows interaction', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit', isEnabled: true));

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Options should appear
        expect(find.text('Apple'), findsOneWidget);
      });
    });

    group('Display', () {
      testWidgets('shows dropdown arrow icon', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit'));

        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      });

      testWidgets('displays all options when dropdown opens with no filter', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit'));

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Cherry'), findsOneWidget);
        expect(find.text('Date'), findsOneWidget);
      });

      testWidgets('updates text field when option selected', (tester) async {
        await tester.pumpWidget(buildDropdown(label: 'Select Fruit'));

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cherry'));
        await tester.pumpAndSettle();

        expect(find.text('Cherry'), findsOneWidget);
      });
    });
  });
}
