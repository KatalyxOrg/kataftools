import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

// Helper test class for generic type testing
class TestNode {
  final int id;
  final String name;

  TestNode({required this.id, required this.name});

  Map<String, Object?> toJson() => {'id': id, 'name': name};

  factory TestNode.fromJson(Map<String, Object?> json) {
    return TestNode(id: json['id'] as int, name: json['name'] as String);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestNode && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'TestNode{id: $id, name: $name}';
}

void main() {
  group('PageCursor<T>', () {
    group('Construction', () {
      test('creates with simple type (String)', () {
        final cursor = PageCursor<String>(
          cursor: 'cursor123',
          node: 'nodeValue',
        );

        expect(cursor.cursor, 'cursor123');
        expect(cursor.node, 'nodeValue');
      });

      test('creates with simple type (int)', () {
        final cursor = PageCursor<int>(cursor: 'cursor456', node: 42);

        expect(cursor.cursor, 'cursor456');
        expect(cursor.node, 42);
      });

      test('creates with complex custom type', () {
        final testNode = TestNode(id: 1, name: 'Test');
        final cursor = PageCursor<TestNode>(
          cursor: 'cursor789',
          node: testNode,
        );

        expect(cursor.cursor, 'cursor789');
        expect(cursor.node, testNode);
        expect(cursor.node.id, 1);
        expect(cursor.node.name, 'Test');
      });

      test('creates with Map type', () {
        final nodeData = {'key': 'value', 'count': 10};
        final cursor = PageCursor<Map<String, dynamic>>(
          cursor: 'cursorMap',
          node: nodeData,
        );

        expect(cursor.cursor, 'cursorMap');
        expect(cursor.node, nodeData);
      });

      test('creates with List type', () {
        final nodeList = [1, 2, 3, 4, 5];
        final cursor = PageCursor<List<int>>(
          cursor: 'cursorList',
          node: nodeList,
        );

        expect(cursor.cursor, 'cursorList');
        expect(cursor.node, nodeList);
      });
    });

    group('Freezed Immutability', () {
      test('is immutable with String type', () {
        final cursor = PageCursor<String>(cursor: 'cursor1', node: 'value1');

        expect(cursor.cursor, 'cursor1');
        expect(cursor.node, 'value1');
      });

      test('copyWith creates new instance with cursor change', () {
        final original = PageCursor<String>(cursor: 'cursor1', node: 'value1');

        final modified = original.copyWith(cursor: 'cursor2');

        expect(original.cursor, 'cursor1');
        expect(modified.cursor, 'cursor2');
        expect(modified.node, 'value1'); // Unchanged
      });

      test('copyWith creates new instance with node change', () {
        final original = PageCursor<String>(cursor: 'cursor1', node: 'value1');

        final modified = original.copyWith(node: 'value2');

        expect(original.node, 'value1');
        expect(modified.node, 'value2');
        expect(modified.cursor, 'cursor1'); // Unchanged
      });

      test('copyWith can change both fields', () {
        final original = PageCursor<int>(cursor: 'cursor1', node: 10);

        final modified = original.copyWith(cursor: 'cursor2', node: 20);

        expect(modified.cursor, 'cursor2');
        expect(modified.node, 20);
      });

      test('copyWith with custom type', () {
        final node1 = TestNode(id: 1, name: 'Node1');
        final node2 = TestNode(id: 2, name: 'Node2');

        final original = PageCursor<TestNode>(cursor: 'cursor1', node: node1);

        final modified = original.copyWith(node: node2);

        expect(original.node, node1);
        expect(modified.node, node2);
      });
    });

    group('Generic Type Handling', () {
      test('maintains type safety with String', () {
        final cursor = PageCursor<String>(cursor: 'c1', node: 'stringNode');

        expect(cursor.node, isA<String>());
        expect(cursor.node.length, 10);
      });

      test('maintains type safety with int', () {
        final cursor = PageCursor<int>(cursor: 'c2', node: 42);

        expect(cursor.node, isA<int>());
        expect(cursor.node * 2, 84);
      });

      test('maintains type safety with custom class', () {
        final testNode = TestNode(id: 5, name: 'TypeTest');
        final cursor = PageCursor<TestNode>(cursor: 'c3', node: testNode);

        expect(cursor.node, isA<TestNode>());
        expect(cursor.node.id, 5);
        expect(cursor.node.name, 'TypeTest');
      });

      test('maintains type safety with Map', () {
        final cursor = PageCursor<Map<String, int>>(
          cursor: 'c4',
          node: {'a': 1, 'b': 2},
        );

        expect(cursor.node, isA<Map<String, int>>());
        expect(cursor.node['a'], 1);
      });
    });

    group('JSON Serialization', () {
      test('fromJson with String type and custom fromJsonT', () {
        final json = {'cursor': 'cursor123', 'node': 'stringValue'};

        final cursor = PageCursor<String>.fromJson(
          json,
          (obj) => obj as String,
        );

        expect(cursor.cursor, 'cursor123');
        expect(cursor.node, 'stringValue');
      });

      test('fromJson with int type and custom fromJsonT', () {
        final json = {'cursor': 'cursor456', 'node': 42};

        final cursor = PageCursor<int>.fromJson(json, (obj) => obj as int);

        expect(cursor.cursor, 'cursor456');
        expect(cursor.node, 42);
      });

      test('fromJson with custom type and conversion function', () {
        final json = {
          'cursor': 'cursor789',
          'node': {'id': 10, 'name': 'TestNode'},
        };

        final cursor = PageCursor<TestNode>.fromJson(
          json,
          (obj) => TestNode.fromJson(obj as Map<String, Object?>),
        );

        expect(cursor.cursor, 'cursor789');
        expect(cursor.node.id, 10);
        expect(cursor.node.name, 'TestNode');
      });

      test('toJson with String type', () {
        final cursor = PageCursor<String>(
          cursor: 'cursor123',
          node: 'stringValue',
        );

        final json = cursor.toJson((node) => node);

        expect(json['cursor'], 'cursor123');
        expect(json['node'], 'stringValue');
      });

      test('toJson with int type', () {
        final cursor = PageCursor<int>(cursor: 'cursor456', node: 42);

        final json = cursor.toJson((node) => node);

        expect(json['cursor'], 'cursor456');
        expect(json['node'], 42);
      });

      test('toJson with custom type and conversion function', () {
        final testNode = TestNode(id: 10, name: 'TestNode');
        final cursor = PageCursor<TestNode>(
          cursor: 'cursor789',
          node: testNode,
        );

        final json = cursor.toJson((node) => node.toJson());

        expect(json['cursor'], 'cursor789');
        expect(json['node'], isA<Map<String, Object?>>());
        expect((json['node'] as Map)['id'], 10);
        expect((json['node'] as Map)['name'], 'TestNode');
      });

      test('round-trip serialization with String', () {
        final original = PageCursor<String>(cursor: 'c1', node: 'value1');

        final json = original.toJson((node) => node);
        final restored = PageCursor<String>.fromJson(
          json,
          (obj) => obj as String,
        );

        expect(restored.cursor, original.cursor);
        expect(restored.node, original.node);
      });

      test('round-trip serialization with int', () {
        final original = PageCursor<int>(cursor: 'c2', node: 100);

        final json = original.toJson((node) => node);
        final restored = PageCursor<int>.fromJson(json, (obj) => obj as int);

        expect(restored.cursor, original.cursor);
        expect(restored.node, original.node);
      });

      test('round-trip serialization with custom type', () {
        final originalNode = TestNode(id: 7, name: 'RoundTrip');
        final original = PageCursor<TestNode>(cursor: 'c3', node: originalNode);

        final json = original.toJson((node) => node.toJson());
        final restored = PageCursor<TestNode>.fromJson(
          json,
          (obj) => TestNode.fromJson(obj as Map<String, Object?>),
        );

        expect(restored.cursor, original.cursor);
        expect(restored.node, original.node);
        expect(restored.node.id, originalNode.id);
        expect(restored.node.name, originalNode.name);
      });
    });

    group('Equality', () {
      test('identical String cursors are equal', () {
        final cursor1 = PageCursor<String>(cursor: 'c1', node: 'value');
        final cursor2 = PageCursor<String>(cursor: 'c1', node: 'value');

        expect(cursor1, equals(cursor2));
      });

      test('different cursor strings are not equal', () {
        final cursor1 = PageCursor<String>(cursor: 'c1', node: 'value');
        final cursor2 = PageCursor<String>(cursor: 'c2', node: 'value');

        expect(cursor1, isNot(equals(cursor2)));
      });

      test('different node values are not equal', () {
        final cursor1 = PageCursor<String>(cursor: 'c1', node: 'value1');
        final cursor2 = PageCursor<String>(cursor: 'c1', node: 'value2');

        expect(cursor1, isNot(equals(cursor2)));
      });

      test('equality works with int type', () {
        final cursor1 = PageCursor<int>(cursor: 'c1', node: 42);
        final cursor2 = PageCursor<int>(cursor: 'c1', node: 42);

        expect(cursor1, equals(cursor2));
      });

      test('equality works with custom type', () {
        final node = TestNode(id: 1, name: 'Test');
        final cursor1 = PageCursor<TestNode>(cursor: 'c1', node: node);
        final cursor2 = PageCursor<TestNode>(cursor: 'c1', node: node);

        expect(cursor1, equals(cursor2));
      });
    });

    group('HashCode', () {
      test('equal String cursors have same hashCode', () {
        final cursor1 = PageCursor<String>(cursor: 'c1', node: 'value');
        final cursor2 = PageCursor<String>(cursor: 'c1', node: 'value');

        expect(cursor1.hashCode, equals(cursor2.hashCode));
      });

      test('equal int cursors have same hashCode', () {
        final cursor1 = PageCursor<int>(cursor: 'c1', node: 42);
        final cursor2 = PageCursor<int>(cursor: 'c1', node: 42);

        expect(cursor1.hashCode, equals(cursor2.hashCode));
      });
    });

    group('toString', () {
      test('provides readable string representation with String', () {
        final cursor = PageCursor<String>(
          cursor: 'cursor123',
          node: 'nodeValue',
        );

        final str = cursor.toString();

        expect(str, contains('PageCursor'));
        expect(str, contains('String'));
        expect(str, contains('cursor123'));
        expect(str, contains('nodeValue'));
      });

      test('provides readable string representation with int', () {
        final cursor = PageCursor<int>(cursor: 'cursor456', node: 42);

        final str = cursor.toString();

        expect(str, contains('PageCursor'));
        expect(str, contains('int'));
        expect(str, contains('cursor456'));
        expect(str, contains('42'));
      });

      test('provides readable string representation with custom type', () {
        final testNode = TestNode(id: 1, name: 'Test');
        final cursor = PageCursor<TestNode>(
          cursor: 'cursor789',
          node: testNode,
        );

        final str = cursor.toString();

        expect(str, contains('PageCursor'));
        expect(str, contains('TestNode'));
        expect(str, contains('cursor789'));
      });
    });

    group('Edge Cases', () {
      test('handles empty cursor string', () {
        final cursor = PageCursor<String>(cursor: '', node: 'value');

        expect(cursor.cursor, '');
        expect(cursor.node, 'value');
      });

      test('handles null as node value (when type allows)', () {
        final cursor = PageCursor<String?>(cursor: 'c1', node: null);

        expect(cursor.cursor, 'c1');
        expect(cursor.node, isNull);
      });

      test('handles special characters in cursor', () {
        final cursor = PageCursor<String>(
          cursor: 'cursor-!@#\$%^&*()',
          node: 'value',
        );

        expect(cursor.cursor, 'cursor-!@#\$%^&*()');
      });

      test('handles unicode in cursor', () {
        final cursor = PageCursor<String>(cursor: 'cursor-🚀🎉', node: 'value');

        expect(cursor.cursor, 'cursor-🚀🎉');
      });

      test('handles complex nested objects', () {
        final complexNode = {
          'id': 1,
          'data': {
            'nested': ['array', 'of', 'strings'],
            'deep': {'level': 3},
          },
        };

        final cursor = PageCursor<Map<String, dynamic>>(
          cursor: 'complexCursor',
          node: complexNode,
        );

        expect(cursor.node['data']['nested'], isA<List<dynamic>>());
        expect(cursor.node['data']['deep']['level'], 3);
      });
    });

    group('Type Safety', () {
      test('PageCursor<String> and PageCursor<int> are different types', () {
        final stringCursor = PageCursor<String>(cursor: 'c1', node: 'text');
        final intCursor = PageCursor<int>(cursor: 'c1', node: 42);

        expect(stringCursor, isA<PageCursor<String>>());
        expect(intCursor, isA<PageCursor<int>>());
        expect(stringCursor.runtimeType, isNot(equals(intCursor.runtimeType)));
      });

      test('runtime types differ for different generic types', () {
        final stringCursor = PageCursor<String>(cursor: 'c1', node: 'text');
        final intCursor = PageCursor<int>(cursor: 'c1', node: 42);

        expect(stringCursor, isA<PageCursor<String>>());
        expect(intCursor, isA<PageCursor<int>>());
        expect(stringCursor.runtimeType, isNot(equals(intCursor.runtimeType)));
      });
    });
  });
}
