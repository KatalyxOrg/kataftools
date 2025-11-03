import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('PageInfo', () {
    group('Construction', () {
      test('creates with required fields', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'cursor123');

        expect(pageInfo.hasNextPage, true);
        expect(pageInfo.endCursor, 'cursor123');
      });

      test('creates with hasNextPage false', () {
        const pageInfo = PageInfo(hasNextPage: false, endCursor: 'lastCursor');

        expect(pageInfo.hasNextPage, false);
        expect(pageInfo.endCursor, 'lastCursor');
      });

      test('creates with empty cursor', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: '');

        expect(pageInfo.endCursor, '');
      });
    });

    group('Freezed Immutability', () {
      test('is immutable', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'cursor1');

        // Attempting to modify should not be possible
        // This test verifies the type is const-capable
        expect(pageInfo.hasNextPage, true);
        expect(pageInfo.endCursor, 'cursor1');
      });

      test('copyWith creates new instance with changes', () {
        const original = PageInfo(hasNextPage: true, endCursor: 'cursor1');

        final modified = original.copyWith(hasNextPage: false);

        expect(original.hasNextPage, true);
        expect(modified.hasNextPage, false);
        expect(modified.endCursor, 'cursor1'); // Unchanged field remains
      });

      test('copyWith creates new instance with cursor change', () {
        const original = PageInfo(hasNextPage: true, endCursor: 'cursor1');

        final modified = original.copyWith(endCursor: 'cursor2');

        expect(original.endCursor, 'cursor1');
        expect(modified.endCursor, 'cursor2');
        expect(modified.hasNextPage, true); // Unchanged field remains
      });

      test('copyWith can change both fields', () {
        const original = PageInfo(hasNextPage: true, endCursor: 'cursor1');

        final modified = original.copyWith(hasNextPage: false, endCursor: 'cursor2');

        expect(modified.hasNextPage, false);
        expect(modified.endCursor, 'cursor2');
      });

      test('copyWith with no arguments creates identical copy', () {
        const original = PageInfo(hasNextPage: true, endCursor: 'cursor1');

        final copy = original.copyWith();

        expect(copy.hasNextPage, original.hasNextPage);
        expect(copy.endCursor, original.endCursor);
      });
    });

    group('JSON Serialization', () {
      test('fromJson deserializes correctly', () {
        final json = {'hasNextPage': true, 'endCursor': 'cursor123'};

        final pageInfo = PageInfo.fromJson(json);

        expect(pageInfo.hasNextPage, true);
        expect(pageInfo.endCursor, 'cursor123');
      });

      test('fromJson deserializes with false hasNextPage', () {
        final json = {'hasNextPage': false, 'endCursor': 'lastCursor'};

        final pageInfo = PageInfo.fromJson(json);

        expect(pageInfo.hasNextPage, false);
        expect(pageInfo.endCursor, 'lastCursor');
      });

      test('toJson serializes correctly', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'cursor123');

        final json = pageInfo.toJson();

        expect(json['hasNextPage'], true);
        expect(json['endCursor'], 'cursor123');
      });

      test('toJson serializes with false hasNextPage', () {
        const pageInfo = PageInfo(hasNextPage: false, endCursor: 'lastCursor');

        final json = pageInfo.toJson();

        expect(json['hasNextPage'], false);
        expect(json['endCursor'], 'lastCursor');
      });

      test('round-trip toJson → fromJson maintains data integrity', () {
        const original = PageInfo(hasNextPage: true, endCursor: 'cursor123');

        final json = original.toJson();
        final restored = PageInfo.fromJson(json);

        expect(restored.hasNextPage, original.hasNextPage);
        expect(restored.endCursor, original.endCursor);
      });

      test('round-trip with false hasNextPage', () {
        const original = PageInfo(hasNextPage: false, endCursor: 'endOfResults');

        final json = original.toJson();
        final restored = PageInfo.fromJson(json);

        expect(restored.hasNextPage, original.hasNextPage);
        expect(restored.endCursor, original.endCursor);
      });

      test('handles empty cursor in serialization', () {
        const original = PageInfo(hasNextPage: true, endCursor: '');

        final json = original.toJson();
        final restored = PageInfo.fromJson(json);

        expect(restored.endCursor, '');
      });
    });

    group('Equality', () {
      test('identical instances are equal', () {
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'cursor1');
        const pageInfo2 = PageInfo(hasNextPage: true, endCursor: 'cursor1');

        expect(pageInfo1, equals(pageInfo2));
      });

      test('different hasNextPage values are not equal', () {
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'cursor1');
        const pageInfo2 = PageInfo(hasNextPage: false, endCursor: 'cursor1');

        expect(pageInfo1, isNot(equals(pageInfo2)));
      });

      test('different endCursor values are not equal', () {
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'cursor1');
        const pageInfo2 = PageInfo(hasNextPage: true, endCursor: 'cursor2');

        expect(pageInfo1, isNot(equals(pageInfo2)));
      });

      test('completely different values are not equal', () {
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'cursor1');
        const pageInfo2 = PageInfo(hasNextPage: false, endCursor: 'cursor2');

        expect(pageInfo1, isNot(equals(pageInfo2)));
      });
    });

    group('HashCode', () {
      test('equal instances have same hashCode', () {
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'cursor1');
        const pageInfo2 = PageInfo(hasNextPage: true, endCursor: 'cursor1');

        expect(pageInfo1.hashCode, equals(pageInfo2.hashCode));
      });

      test('different instances likely have different hashCodes', () {
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'cursor1');
        const pageInfo2 = PageInfo(hasNextPage: false, endCursor: 'cursor2');

        // Note: Hash collisions are possible but unlikely for different values
        expect(pageInfo1.hashCode, isNot(equals(pageInfo2.hashCode)));
      });
    });

    group('toString', () {
      test('provides readable string representation', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'cursor123');

        final str = pageInfo.toString();

        expect(str, contains('PageInfo'));
        expect(str, contains('hasNextPage'));
        expect(str, contains('true'));
        expect(str, contains('endCursor'));
        expect(str, contains('cursor123'));
      });
    });

    group('Edge Cases', () {
      test('handles very long cursor strings', () {
        final longCursor = 'a' * 1000;
        final pageInfo = PageInfo(hasNextPage: true, endCursor: longCursor);

        expect(pageInfo.endCursor, longCursor);
        expect(pageInfo.endCursor.length, 1000);
      });

      test('handles special characters in cursor', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'cursor-with-special-chars-!@#\$%^&*()');

        expect(pageInfo.endCursor, 'cursor-with-special-chars-!@#\$%^&*()');
      });

      test('handles unicode in cursor', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'cursor-with-émojis-🚀🎉');

        expect(pageInfo.endCursor, 'cursor-with-émojis-🚀🎉');
      });

      test('serializes and deserializes special characters', () {
        const original = PageInfo(hasNextPage: false, endCursor: 'special-chars-🎯');

        final json = original.toJson();
        final restored = PageInfo.fromJson(json);

        expect(restored.endCursor, 'special-chars-🎯');
      });
    });

    group('Use Cases', () {
      test('represents last page correctly', () {
        const lastPage = PageInfo(hasNextPage: false, endCursor: 'finalCursor');

        expect(lastPage.hasNextPage, false);
        // Can use this to determine if pagination should continue
      });

      test('represents page with more results', () {
        const hasMorePages = PageInfo(hasNextPage: true, endCursor: 'nextPageCursor');

        expect(hasMorePages.hasNextPage, true);
        expect(hasMorePages.endCursor.isNotEmpty, true);
      });
    });
  });
}
