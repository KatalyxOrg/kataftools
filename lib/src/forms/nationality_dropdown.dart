import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:kataftools/src/utils.dart';
import 'searchable_dropdown.dart';

typedef CountryNameResolver = String Function(IsoCode code);

class NationalityDropdown extends StatelessWidget {
  const NationalityDropdown({
    super.key,
    this.label = 'Nationalité',
    this.value,
    this.onSelected,
    this.isRequired = false,
    this.isEnabled = true,
    this.shouldResetOnTap = true,
    this.countries,
    this.resolveName,
    this.showFlag = true,
  });

  final String? label;
  final IsoCode? value;
  final ValueChanged<IsoCode?>? onSelected;
  final bool isRequired;
  final bool isEnabled;
  final bool shouldResetOnTap;

  /// Defaults to all ISO codes if not provided.
  final List<IsoCode>? countries;

  /// Provide localized names. Fallback is the ISO code string.
  final CountryNameResolver? resolveName;

  /// Whether to prefix options with the emoji flag.
  final bool showFlag;

  String _displayText(IsoCode code) {
    final name = resolveName?.call(code) ?? code.name;
    if (!showFlag) return name;
    final flag = code.name.toFlagEmoji();
    return '$flag $name';
  }

  @override
  Widget build(BuildContext context) {
    final list = (countries ?? IsoCode.values).toList();

    return SearchableDropdown<IsoCode>(
      label: label,
      value: value,
      isRequired: isRequired,
      isEnabled: isEnabled,
      shouldResetOnTap: shouldResetOnTap,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.toLowerCase();
        return list.where((c) {
          final name = (resolveName?.call(c) ?? c.name).toLowerCase();
          final code = c.name.toLowerCase();
          return name.contains(query) || code.contains(query);
        });
      },
      displayStringForOption: _displayText,
      onSelected: onSelected,
    );
  }
}
