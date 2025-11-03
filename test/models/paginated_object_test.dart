import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

// Reuse the TestNode class from page_cursor_test.dart
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
  group('PaginatedObject<T>', () {
    group('Construction', () {
      test('creates with edges and pageInfo', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1'), const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c2');

        final paginated = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        expect(paginated.edges.length, 2);
        expect(paginated.pageInfo, pageInfo);
      });

      test('creates with empty edges list', () {
        const pageInfo = PageInfo(hasNextPage: false, endCursor: '');

        final paginated = PaginatedObject<String>(edges: [], pageInfo: pageInfo);

        expect(paginated.edges, isEmpty);
        expect(paginated.pageInfo, pageInfo);
      });

      test('creates with null pageInfo', () {
        final edges = [const PageCursor<int>(cursor: 'c1', node: 1)];

        final paginated = PaginatedObject<int>(edges: edges, pageInfo: null);

        expect(paginated.edges.length, 1);
        expect(paginated.pageInfo, isNull);
      });

      test('creates with edges only (pageInfo defaults to null)', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value')];

        final paginated = PaginatedObject<String>(edges: edges);

        expect(paginated.edges.length, 1);
        expect(paginated.pageInfo, isNull);
      });

      test('creates with custom type', () {
        final node1 = TestNode(id: 1, name: 'Node1');
        final node2 = TestNode(id: 2, name: 'Node2');
        final edges = [PageCursor<TestNode>(cursor: 'c1', node: node1), PageCursor<TestNode>(cursor: 'c2', node: node2)];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c2');

        final paginated = PaginatedObject<TestNode>(edges: edges, pageInfo: pageInfo);

        expect(paginated.edges.length, 2);
        expect(paginated.edges[0].node, node1);
        expect(paginated.edges[1].node, node2);
      });
    });

    group('JSON Serialization', () {
      test('fromJson with String type', () {
        final json = {
          'edges': [
            {'cursor': 'c1', 'node': 'value1'},
            {'cursor': 'c2', 'node': 'value2'},
          ],
          'pageInfo': {'hasNextPage': true, 'endCursor': 'c2'},
        };

        final paginated = PaginatedObject<String>.fromJson(json, (obj) => obj as String);

        expect(paginated.edges.length, 2);
        expect(paginated.edges[0].cursor, 'c1');
        expect(paginated.edges[0].node, 'value1');
        expect(paginated.edges[1].cursor, 'c2');
        expect(paginated.edges[1].node, 'value2');
        expect(paginated.pageInfo?.hasNextPage, true);
        expect(paginated.pageInfo?.endCursor, 'c2');
      });

      test('fromJson with int type', () {
        final json = {
          'edges': [
            {'cursor': 'c1', 'node': 10},
            {'cursor': 'c2', 'node': 20},
          ],
          'pageInfo': {'hasNextPage': false, 'endCursor': 'c2'},
        };

        final paginated = PaginatedObject<int>.fromJson(json, (obj) => obj as int);

        expect(paginated.edges.length, 2);
        expect(paginated.edges[0].node, 10);
        expect(paginated.edges[1].node, 20);
        expect(paginated.pageInfo?.hasNextPage, false);
      });

      test('fromJson with custom type', () {
        final json = {
          'edges': [
            {
              'cursor': 'c1',
              'node': {'id': 1, 'name': 'Node1'},
            },
            {
              'cursor': 'c2',
              'node': {'id': 2, 'name': 'Node2'},
            },
          ],
          'pageInfo': {'hasNextPage': true, 'endCursor': 'c2'},
        };

        final paginated = PaginatedObject<TestNode>.fromJson(json, (obj) => TestNode.fromJson(obj as Map<String, Object?>));

        expect(paginated.edges.length, 2);
        expect(paginated.edges[0].node.id, 1);
        expect(paginated.edges[0].node.name, 'Node1');
        expect(paginated.edges[1].node.id, 2);
        expect(paginated.edges[1].node.name, 'Node2');
      });

      test('fromJson with null pageInfo', () {
        final json = {
          'edges': [
            {'cursor': 'c1', 'node': 'value1'},
          ],
          'pageInfo': null,
        };

        final paginated = PaginatedObject<String>.fromJson(json, (obj) => obj as String);

        expect(paginated.edges.length, 1);
        expect(paginated.pageInfo, isNull);
      });

      test('fromJson with missing pageInfo field', () {
        final json = {
          'edges': [
            {'cursor': 'c1', 'node': 'value1'},
          ],
        };

        final paginated = PaginatedObject<String>.fromJson(json, (obj) => obj as String);

        expect(paginated.edges.length, 1);
        expect(paginated.pageInfo, isNull);
      });

      test('fromJson with empty edges', () {
        final json = {
          'edges': <Map<String, Object?>>[],
          'pageInfo': {'hasNextPage': false, 'endCursor': ''},
        };

        final paginated = PaginatedObject<String>.fromJson(json, (obj) => obj as String);

        expect(paginated.edges, isEmpty);
        expect(paginated.pageInfo?.hasNextPage, false);
      });

      test('toJson with String type', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1'), const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c2');

        final paginated = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        final json = paginated.toJson((node) => node);

        expect(json['edges'], isA<List<dynamic>>());
        expect((json['edges'] as List).length, 2);
        expect((json['edges'] as List)[0]['cursor'], 'c1');
        expect((json['edges'] as List)[0]['node'], 'value1');
        expect((json['edges'] as List)[1]['cursor'], 'c2');
        expect((json['edges'] as List)[1]['node'], 'value2');
        expect(json['pageInfo'], isA<Map<dynamic, dynamic>>());
        expect((json['pageInfo'] as Map)['hasNextPage'], true);
        expect((json['pageInfo'] as Map)['endCursor'], 'c2');
      });

      test('toJson with int type', () {
        final edges = [const PageCursor<int>(cursor: 'c1', node: 10), const PageCursor<int>(cursor: 'c2', node: 20)];
        const pageInfo = PageInfo(hasNextPage: false, endCursor: 'c2');

        final paginated = PaginatedObject<int>(edges: edges, pageInfo: pageInfo);

        final json = paginated.toJson((node) => node);

        expect((json['edges'] as List)[0]['node'], 10);
        expect((json['edges'] as List)[1]['node'], 20);
      });

      test('toJson with custom type', () {
        final node1 = TestNode(id: 1, name: 'Node1');
        final node2 = TestNode(id: 2, name: 'Node2');
        final edges = [PageCursor<TestNode>(cursor: 'c1', node: node1), PageCursor<TestNode>(cursor: 'c2', node: node2)];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c2');

        final paginated = PaginatedObject<TestNode>(edges: edges, pageInfo: pageInfo);

        final json = paginated.toJson((node) => node.toJson());

        expect((json['edges'] as List)[0]['node'], isA<Map<dynamic, dynamic>>());
        expect(((json['edges'] as List)[0]['node'] as Map)['id'], 1);
        expect(((json['edges'] as List)[0]['node'] as Map)['name'], 'Node1');
      });

      test('toJson with null pageInfo', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];

        final paginated = PaginatedObject<String>(edges: edges, pageInfo: null);

        final json = paginated.toJson((node) => node);

        expect(json['pageInfo'], isNull);
      });

      test('round-trip serialization with String', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1'), const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c2');

        final original = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        final json = original.toJson((node) => node);
        final restored = PaginatedObject<String>.fromJson(json, (obj) => obj as String);

        expect(restored.edges.length, original.edges.length);
        expect(restored.edges[0].cursor, original.edges[0].cursor);
        expect(restored.edges[0].node, original.edges[0].node);
        expect(restored.pageInfo?.hasNextPage, original.pageInfo?.hasNextPage);
        expect(restored.pageInfo?.endCursor, original.pageInfo?.endCursor);
      });

      test('round-trip serialization with custom type', () {
        final node1 = TestNode(id: 1, name: 'Node1');
        final edges = [PageCursor<TestNode>(cursor: 'c1', node: node1)];
        const pageInfo = PageInfo(hasNextPage: false, endCursor: 'c1');

        final original = PaginatedObject<TestNode>(edges: edges, pageInfo: pageInfo);

        final json = original.toJson((node) => node.toJson());
        final restored = PaginatedObject<TestNode>.fromJson(json, (obj) => TestNode.fromJson(obj as Map<String, Object?>));

        expect(restored.edges.length, original.edges.length);
        expect(restored.edges[0].node, original.edges[0].node);
        expect(restored.edges[0].node.id, node1.id);
        expect(restored.edges[0].node.name, node1.name);
      });
    });

    group('Equality', () {
      test('identical instances are equal', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final paginated1 = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);
        final paginated2 = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        expect(paginated1, equals(paginated2));
      });

      test('different edges are not equal', () {
        final edges1 = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        final edges2 = [const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final paginated1 = PaginatedObject<String>(edges: edges1, pageInfo: pageInfo);
        final paginated2 = PaginatedObject<String>(edges: edges2, pageInfo: pageInfo);

        expect(paginated1, isNot(equals(paginated2)));
      });

      test('different pageInfo are not equal', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'c1');
        const pageInfo2 = PageInfo(hasNextPage: false, endCursor: 'c1');

        final paginated1 = PaginatedObject<String>(edges: edges, pageInfo: pageInfo1);
        final paginated2 = PaginatedObject<String>(edges: edges, pageInfo: pageInfo2);

        expect(paginated1, isNot(equals(paginated2)));
      });

      test('null and non-null pageInfo are not equal', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final paginated1 = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);
        final paginated2 = PaginatedObject<String>(edges: edges, pageInfo: null);

        expect(paginated1, isNot(equals(paginated2)));
      });
    });

    group('HashCode', () {
      test('equal instances have same hashCode', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final paginated1 = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);
        final paginated2 = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        expect(paginated1.hashCode, equals(paginated2.hashCode));
      });

      test('different instances likely have different hashCodes', () {
        final edges1 = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        final edges2 = [const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final paginated1 = PaginatedObject<String>(edges: edges1, pageInfo: pageInfo);
        final paginated2 = PaginatedObject<String>(edges: edges2, pageInfo: pageInfo);

        expect(paginated1.hashCode, isNot(equals(paginated2.hashCode)));
      });
    });

    group('copyWith', () {
      test('copyWith creates new instance with edges change', () {
        final edges1 = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        final edges2 = [const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final original = PaginatedObject<String>(edges: edges1, pageInfo: pageInfo);

        final modified = original.copyWith(edges: edges2);

        expect(original.edges, edges1);
        expect(modified.edges, edges2);
        expect(modified.pageInfo, pageInfo);
      });

      test('copyWith creates new instance with pageInfo change', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'c1');
        const pageInfo2 = PageInfo(hasNextPage: false, endCursor: 'c1');

        final original = PaginatedObject<String>(edges: edges, pageInfo: pageInfo1);

        final modified = original.copyWith(pageInfo: pageInfo2);

        expect(original.pageInfo, pageInfo1);
        expect(modified.pageInfo, pageInfo2);
        expect(modified.edges, edges);
      });

      test('copyWith can change both fields', () {
        final edges1 = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        final edges2 = [const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo1 = PageInfo(hasNextPage: true, endCursor: 'c1');
        const pageInfo2 = PageInfo(hasNextPage: false, endCursor: 'c2');

        final original = PaginatedObject<String>(edges: edges1, pageInfo: pageInfo1);

        final modified = original.copyWith(edges: edges2, pageInfo: pageInfo2);

        expect(modified.edges, edges2);
        expect(modified.pageInfo, pageInfo2);
      });

      test('copyWith with no arguments returns identical values', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final original = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        final copy = original.copyWith();

        expect(copy.edges, original.edges);
        expect(copy.pageInfo, original.pageInfo);
      });
    });

    group('toString', () {
      test('provides readable string representation', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final paginated = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        final str = paginated.toString();

        expect(str, contains('PaginatedObject'));
        expect(str, contains('edges'));
        expect(str, contains('pageInfo'));
      });

      test('toString handles null pageInfo', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];

        final paginated = PaginatedObject<String>(edges: edges);

        final str = paginated.toString();

        expect(str, contains('PaginatedObject'));
        expect(str, contains('null'));
      });
    });

    group('Edge Cases', () {
      test('handles large number of edges', () {
        final edges = List.generate(1000, (i) => PageCursor<int>(cursor: 'c$i', node: i));
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c999');

        final paginated = PaginatedObject<int>(edges: edges, pageInfo: pageInfo);

        expect(paginated.edges.length, 1000);
        expect(paginated.edges[500].node, 500);
      });

      test('handles empty edges with hasNextPage true (edge case)', () {
        const pageInfo = PageInfo(hasNextPage: true, endCursor: '');

        final paginated = PaginatedObject<String>(edges: [], pageInfo: pageInfo);

        expect(paginated.edges, isEmpty);
        expect(paginated.pageInfo?.hasNextPage, true);
      });

      test('serializes and deserializes empty edges', () {
        const pageInfo = PageInfo(hasNextPage: false, endCursor: '');

        final original = PaginatedObject<String>(edges: [], pageInfo: pageInfo);

        final json = original.toJson((node) => node);
        final restored = PaginatedObject<String>.fromJson(json, (obj) => obj as String);

        expect(restored.edges, isEmpty);
        expect(restored.pageInfo?.hasNextPage, false);
      });
    });

    group('Type Safety', () {
      test('maintains type safety with String', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'text')];

        final paginated = PaginatedObject<String>(edges: edges);

        expect(paginated.edges[0].node, isA<String>());
        expect(paginated.edges[0].node.length, 4);
      });

      test('maintains type safety with int', () {
        final edges = [const PageCursor<int>(cursor: 'c1', node: 42)];

        final paginated = PaginatedObject<int>(edges: edges);

        expect(paginated.edges[0].node, isA<int>());
        expect(paginated.edges[0].node * 2, 84);
      });

      test('maintains type safety with custom type', () {
        final node = TestNode(id: 1, name: 'Test');
        final edges = [PageCursor<TestNode>(cursor: 'c1', node: node)];

        final paginated = PaginatedObject<TestNode>(edges: edges);

        expect(paginated.edges[0].node, isA<TestNode>());
        expect(paginated.edges[0].node.id, 1);
      });
    });

    group('Integration with PageInfo', () {
      test('pageInfo integration indicates more pages', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c1');

        final paginated = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        expect(paginated.pageInfo?.hasNextPage, true);
        expect(paginated.pageInfo?.endCursor, 'c1');
      });

      test('pageInfo integration indicates last page', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1')];
        const pageInfo = PageInfo(hasNextPage: false, endCursor: 'c1');

        final paginated = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        expect(paginated.pageInfo?.hasNextPage, false);
      });

      test('can use endCursor from pageInfo for next page request', () {
        final edges = [const PageCursor<String>(cursor: 'c1', node: 'value1'), const PageCursor<String>(cursor: 'c2', node: 'value2')];
        const pageInfo = PageInfo(hasNextPage: true, endCursor: 'c2');

        final paginated = PaginatedObject<String>(edges: edges, pageInfo: pageInfo);

        // Simulate using endCursor for next request
        final nextCursor = paginated.pageInfo?.endCursor;
        expect(nextCursor, 'c2');
        expect(nextCursor, edges.last.cursor);
      });
    });
  });
}
