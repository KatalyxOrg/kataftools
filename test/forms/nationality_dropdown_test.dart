import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  group('NationalityDropdown', () {
    String fr(IsoCode c) => switch (c) {
          IsoCode.FR => 'France',
          IsoCode.US => 'United States',
          IsoCode.DE => 'Germany',
          _ => c.name,
        };

    Widget build({
      IsoCode? value,
      bool isRequired = false,
      bool isEnabled = true,
      bool shouldResetOnTap = true,
      ValueChanged<IsoCode?>? onSelected,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: NationalityDropdown(
            label: 'Nationalité',
            value: value,
            onSelected: onSelected,
            isRequired: isRequired,
            isEnabled: isEnabled,
            shouldResetOnTap: shouldResetOnTap,
            countries: const [IsoCode.FR, IsoCode.US, IsoCode.DE],
            resolveName: fr,
          ),
        ),
      );
    }

    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(build());
      expect(find.text('Nationalité...'), findsOneWidget);
    });

    testWidgets('opens and shows options with flag+name', (tester) async {
      await tester.pumpWidget(build());

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      expect(find.textContaining('🇫🇷 France'), findsOneWidget);
      expect(find.textContaining('🇺🇸 United States'), findsOneWidget);
      expect(find.textContaining('🇩🇪 Germany'), findsOneWidget);
    });

    testWidgets('filters by name', (tester) async {
      await tester.pumpWidget(build());

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'fran');
      await tester.pumpAndSettle();

      expect(find.textContaining('France'), findsOneWidget);
      expect(find.textContaining('United States'), findsNothing);
    });

    testWidgets('onSelected is called with the chosen country', (tester) async {
      IsoCode? selected;
      await tester.pumpWidget(build(onSelected: (v) => selected = v));

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Germany'));
      await tester.pumpAndSettle();

      expect(selected, IsoCode.DE);
    });

    testWidgets('required validation shows error when empty', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: NationalityDropdown(
                label: 'Nationalité',
                isRequired: true,
                countries: const [IsoCode.FR, IsoCode.US],
                resolveName: fr,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Ce champ est requis'), findsOneWidget);
    });

    testWidgets('respects isEnabled=false', (tester) async {
      await tester.pumpWidget(build(isEnabled: false));

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });
  });
}
