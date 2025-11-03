import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('DateSerializer', () {
    late DateSerializer serializer;

    setUp(() {
      serializer = const DateSerializer();
    });

    group('fromJson', () {
      test('converts valid ISO 8601 string to DateTime', () {
        const timestamp = '2025-11-03T10:30:00.000Z';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        expect(result, isA<DateTime>());
        expect(result!.year, 2025);
        expect(result.month, 11);
        expect(result.day, 3);
      });

      test('converts UTC timestamp to local time', () {
        const timestamp = '2025-11-03T12:00:00.000Z';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        expect(result!.isUtc, false);
      });

      test('returns null for null input', () {
        final result = serializer.fromJson(null);
        expect(result, isNull);
      });

      test('returns null for empty string', () {
        final result = serializer.fromJson('');
        expect(result, isNull);
      });

      test('returns null for invalid string', () {
        final result = serializer.fromJson('invalid-date');
        expect(result, isNull);
      });

      test('returns null for malformed ISO string', () {
        // Note: DateTime.tryParse is quite lenient and may parse some
        // seemingly invalid dates. Testing with a truly unparseable string.
        final result = serializer.fromJson('not-a-date-at-all');
        expect(result, isNull);
      });

      test('handles ISO 8601 with timezone offset', () {
        const timestamp = '2025-11-03T10:30:00+02:00';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        expect(result, isA<DateTime>());
      });

      test('handles ISO 8601 without milliseconds', () {
        const timestamp = '2025-11-03T10:30:00Z';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        expect(result!.year, 2025);
        expect(result.month, 11);
        expect(result.day, 3);
      });

      test('handles ISO 8601 date only format', () {
        const timestamp = '2025-11-03';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        expect(result!.year, 2025);
        expect(result.month, 11);
        expect(result.day, 3);
      });

      test('handles past dates', () {
        const timestamp = '1990-01-15T08:00:00.000Z';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        expect(result!.year, 1990);
        expect(result.month, 1);
        expect(result.day, 15);
      });

      test('handles future dates', () {
        const timestamp = '2100-12-31T23:59:59.999Z';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        // When converting from UTC to local, the date might shift due to timezone
        // Check the UTC values to avoid timezone-related issues
        final utcResult = result!.toUtc();
        expect(utcResult.year, 2100);
        expect(utcResult.month, 12);
        expect(utcResult.day, 31);
      });

      test('handles midnight time', () {
        const timestamp = '2025-11-03T00:00:00.000Z';
        final result = serializer.fromJson(timestamp);

        expect(result, isNotNull);
        expect(result!.year, 2025);
        expect(result.month, 11);
        expect(result.day, 3);
      });

      test('returns null for various invalid formats', () {
        expect(serializer.fromJson('invalide'), isNull);
        expect(serializer.fromJson('2025/11/03'), isNull);
        expect(serializer.fromJson('03-11-2025'), isNull);
        expect(serializer.fromJson('random text'), isNull);
      });
    });

    group('toJson', () {
      test('converts DateTime to ISO 8601 UTC string', () {
        final date = DateTime(2025, 11, 3, 10, 30, 0);
        final result = serializer.toJson(date);

        expect(result, isNotNull);
        expect(result, contains('2025-11-03'));
        expect(result, endsWith('Z'));
      });

      test('returns null for null DateTime', () {
        final result = serializer.toJson(null);
        expect(result, isNull);
      });

      test('converts local DateTime to UTC', () {
        final localDate = DateTime(2025, 11, 3, 15, 30, 0);
        final result = serializer.toJson(localDate);

        expect(result, isNotNull);
        expect(result, endsWith('Z'));
        // Result should be in UTC format
        final parsedBack = DateTime.parse(result!);
        expect(parsedBack.isUtc, true);
      });

      test('maintains UTC DateTime as UTC', () {
        final utcDate = DateTime.utc(2025, 11, 3, 12, 0, 0);
        final result = serializer.toJson(utcDate);

        expect(result, isNotNull);
        expect(result, contains('2025-11-03T12:00:00'));
        expect(result, endsWith('Z'));
      });

      test('handles midnight correctly', () {
        final date = DateTime.utc(2025, 11, 3, 0, 0, 0);
        final result = serializer.toJson(date);

        expect(result, isNotNull);
        expect(result, contains('2025-11-03'));
      });

      test('handles end of day correctly', () {
        final date = DateTime(2025, 11, 3, 23, 59, 59);
        final result = serializer.toJson(date);

        expect(result, isNotNull);
        expect(result, contains('2025-11-03'));
      });

      test('handles milliseconds', () {
        final date = DateTime(2025, 11, 3, 10, 30, 45, 123);
        final result = serializer.toJson(date);

        expect(result, isNotNull);
        expect(result, isA<String>());
        // ISO 8601 format should include milliseconds
        expect(result, contains('.'));
      });

      test('result can be parsed back', () {
        final originalDate = DateTime.utc(2025, 11, 3, 12, 30, 45);
        final jsonString = serializer.toJson(originalDate);
        final parsedDate = DateTime.parse(jsonString!);

        expect(parsedDate.year, originalDate.year);
        expect(parsedDate.month, originalDate.month);
        expect(parsedDate.day, originalDate.day);
        expect(parsedDate.hour, originalDate.hour);
        expect(parsedDate.minute, originalDate.minute);
      });
    });

    group('Round-trip Serialization', () {
      test('DateTime survives round-trip (toJson then fromJson)', () {
        final original = DateTime.utc(2025, 11, 3, 14, 25, 30);
        final json = serializer.toJson(original);
        final restored = serializer.fromJson(json);

        expect(restored, isNotNull);
        expect(restored!.toUtc().year, original.year);
        expect(restored.toUtc().month, original.month);
        expect(restored.toUtc().day, original.day);
        expect(restored.toUtc().hour, original.hour);
        expect(restored.toUtc().minute, original.minute);
      });

      test('null survives round-trip', () {
        final json = serializer.toJson(null);
        final restored = serializer.fromJson(json);

        expect(json, isNull);
        expect(restored, isNull);
      });

      test('local DateTime converts to UTC and back to local', () {
        final original = DateTime(2025, 11, 3, 14, 25, 30);
        final json = serializer.toJson(original);
        final restored = serializer.fromJson(json);

        expect(restored, isNotNull);
        expect(restored!.isUtc, false); // fromJson converts to local
        // Time components should match when both converted to UTC
        expect(restored.toUtc().hour, original.toUtc().hour);
      });
    });

    group('Edge Cases', () {
      test('handles leap year date', () {
        final leapDate = DateTime(2024, 2, 29, 12, 0, 0);
        final json = serializer.toJson(leapDate);
        final restored = serializer.fromJson(json);

        expect(restored, isNotNull);
        expect(restored!.year, 2024);
        expect(restored.month, 2);
        expect(restored.day, 29);
      });

      test('handles year boundaries', () {
        final newYear = DateTime(2025, 1, 1, 0, 0, 0);
        final json = serializer.toJson(newYear);
        final restored = serializer.fromJson(json);

        expect(restored, isNotNull);
        expect(restored!.year, 2025);
        expect(restored.month, 1);
        expect(restored.day, 1);
      });

      test('handles very old dates', () {
        final oldDate = DateTime(1900, 1, 1, 0, 0, 0);
        final json = serializer.toJson(oldDate);
        final restored = serializer.fromJson(json);

        expect(restored, isNotNull);
        expect(restored!.year, 1900);
      });
    });
  });
}
