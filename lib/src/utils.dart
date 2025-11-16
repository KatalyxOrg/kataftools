double weightToKg(double weight, String unit) {
  if (unit == 'g') {
    return weight / 1000;
  } else if (unit == 'mg') {
    return weight / 1000000;
  } else if (unit == 't') {
    return weight * 1000;
  } else {
    return weight;
  }
}

double? tryParseFrenchDouble(String? value) {
  if (value == null) {
    return null;
  }
  return double.tryParse(value.replaceAll(',', '.'));
}

double parseFrenchDouble(String value) {
  return double.parse(value.replaceAll(',', '.'));
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

/// Extension to convert a 2-letter ISO country code (e.g., "FR") to its flag emoji (🇫🇷).
/// If the string is not a valid 2-letter A–Z code, returns the original string.
extension CountryCodeFlagX on String {
  String toFlagEmoji() {
    if (length != 2) return this;
    final code = toUpperCase();
    const int base = 0x1F1E6; // Regional indicator symbol letter A
    const int aCode = 0x41; // 'A'
    final int first = code.codeUnitAt(0) - aCode;
    final int second = code.codeUnitAt(1) - aCode;
    if (first < 0 || first > 25 || second < 0 || second > 25) return this;
    return String.fromCharCodes([base + first, base + second]);
  }
}
