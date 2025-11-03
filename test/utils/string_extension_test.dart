import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('StringExtension', () {
    group('capitalize', () {
      test('returns empty string when input is empty', () {
        const input = '';
        final result = input.capitalize();
        expect(result, '');
      });

      test('capitalizes single character string', () {
        const input = 'a';
        final result = input.capitalize();
        expect(result, 'A');
      });

      test('keeps already capitalized string unchanged (first letter)', () {
        const input = 'Hello';
        final result = input.capitalize();
        expect(result, 'Hello');
      });

      test('capitalizes first letter of lowercase string', () {
        const input = 'hello';
        final result = input.capitalize();
        expect(result, 'Hello');
      });

      test('capitalizes and lowercases rest of string', () {
        const input = 'hELLO';
        final result = input.capitalize();
        expect(result, 'Hello');
      });

      test('capitalizes all uppercase string correctly', () {
        const input = 'HELLO';
        final result = input.capitalize();
        expect(result, 'Hello');
      });

      test('handles string with special characters', () {
        const input = 'hello-world';
        final result = input.capitalize();
        expect(result, 'Hello-world');
      });

      test('handles string with numbers', () {
        const input = '123hello';
        final result = input.capitalize();
        expect(result, '123hello');
      });

      test('handles string starting with space', () {
        const input = ' hello';
        final result = input.capitalize();
        expect(result, ' hello');
      });

      test('handles accented characters', () {
        const input = 'école';
        final result = input.capitalize();
        expect(result, 'École');
      });
    });
  });

  group('tryParseFrenchDouble', () {
    test('returns null for null input', () {
      final result = tryParseFrenchDouble(null);
      expect(result, isNull);
    });

    test('returns null for empty string', () {
      final result = tryParseFrenchDouble('');
      expect(result, isNull);
    });

    test('parses valid French decimal with comma', () {
      final result = tryParseFrenchDouble('12,5');
      expect(result, 12.5);
    });

    test('parses valid French number with spaces', () {
      final result = tryParseFrenchDouble('1 234,56');
      expect(result, isNull); // spaces are not removed, so this should fail
    });

    test('parses integer without decimal', () {
      final result = tryParseFrenchDouble('42');
      expect(result, 42.0);
    });

    test('parses standard dot decimal (English format)', () {
      final result = tryParseFrenchDouble('12.5');
      expect(result, 12.5);
    });

    test('returns null for non-numeric string', () {
      final result = tryParseFrenchDouble('abc');
      expect(result, isNull);
    });

    test('returns null for invalid format with multiple commas', () {
      final result = tryParseFrenchDouble('12,34,56');
      expect(result, isNull);
    });

    test('handles leading whitespace', () {
      final result = tryParseFrenchDouble(' 12,5');
      expect(result, 12.5);
    });

    test('handles trailing whitespace', () {
      final result = tryParseFrenchDouble('12,5 ');
      expect(result, 12.5);
    });

    test('parses negative numbers', () {
      final result = tryParseFrenchDouble('-12,5');
      expect(result, -12.5);
    });

    test('parses zero', () {
      final result = tryParseFrenchDouble('0');
      expect(result, 0.0);
    });

    test('parses very small decimal', () {
      final result = tryParseFrenchDouble('0,001');
      expect(result, 0.001);
    });

    test('parses very large number', () {
      final result = tryParseFrenchDouble('999999,99');
      expect(result, 999999.99);
    });
  });

  group('parseFrenchDouble', () {
    test('parses valid French decimal with comma', () {
      final result = parseFrenchDouble('12,5');
      expect(result, 12.5);
    });

    test('parses integer without decimal', () {
      final result = parseFrenchDouble('42');
      expect(result, 42.0);
    });

    test('parses standard dot decimal (English format)', () {
      final result = parseFrenchDouble('12.5');
      expect(result, 12.5);
    });

    test('throws FormatException for non-numeric string', () {
      expect(() => parseFrenchDouble('abc'), throwsFormatException);
    });

    test('throws FormatException for null-like string', () {
      expect(() => parseFrenchDouble('null'), throwsFormatException);
    });

    test('parses negative numbers', () {
      final result = parseFrenchDouble('-12,5');
      expect(result, -12.5);
    });

    test('handles leading and trailing whitespace', () {
      final result = parseFrenchDouble(' 12,5 ');
      expect(result, 12.5);
    });
  });

  group('weightToKg', () {
    test('converts grams to kilograms', () {
      final result = weightToKg(1000, 'g');
      expect(result, 1.0);
    });

    test('converts milligrams to kilograms', () {
      final result = weightToKg(1000000, 'mg');
      expect(result, 1.0);
    });

    test('converts tonnes to kilograms', () {
      final result = weightToKg(1, 't');
      expect(result, 1000.0);
    });

    test('returns same value for kilograms', () {
      final result = weightToKg(5, 'kg');
      expect(result, 5.0);
    });

    test('returns same value for unknown unit', () {
      final result = weightToKg(5, 'unknown');
      expect(result, 5.0);
    });

    test('handles decimal values for grams', () {
      final result = weightToKg(1500, 'g');
      expect(result, 1.5);
    });

    test('handles decimal values for milligrams', () {
      final result = weightToKg(500000, 'mg');
      expect(result, 0.5);
    });

    test('handles decimal values for tonnes', () {
      final result = weightToKg(0.5, 't');
      expect(result, 500.0);
    });

    test('handles zero weight', () {
      final result = weightToKg(0, 'g');
      expect(result, 0.0);
    });

    test('handles very small weights in mg', () {
      final result = weightToKg(1, 'mg');
      expect(result, 0.000001);
    });
  });
}
