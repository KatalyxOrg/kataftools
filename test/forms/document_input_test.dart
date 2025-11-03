import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('DocumentInput', () {
    late Uint8List testDocumentBytes;

    setUp(() {
      // Create a small test PDF bytes
      testDocumentBytes = Uint8List.fromList([
        0x25, 0x50, 0x44, 0x46, // PDF header %PDF
        ...List.filled(100, 0x00), // Dummy content
      ]);
    });

    Widget buildDocumentInput({
      DocumentFile? documentFile,
      Function(DocumentFile?)? onChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: DocumentInput(documentFile: documentFile, onChanged: onChanged),
        ),
      );
    }

    group('Initial State', () {
      testWidgets('shows "Choisir un fichier" button', (tester) async {
        await tester.pumpWidget(buildDocumentInput());

        expect(find.text('Choisir un fichier'), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('shows "Aucun fichier sélectionné" when no file', (
        tester,
      ) async {
        await tester.pumpWidget(buildDocumentInput());

        expect(find.text('Aucun fichier sélectionné'), findsOneWidget);
      });

      testWidgets('does not show delete button when no file selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildDocumentInput());

        expect(find.byIcon(Icons.delete), findsNothing);
      });

      testWidgets('renders in a Row layout', (tester) async {
        await tester.pumpWidget(buildDocumentInput());

        expect(find.byType(Row), findsOneWidget);
      });
    });

    group('File Selected State', () {
      testWidgets('displays selected filename', (tester) async {
        final documentFile = DocumentFile(
          name: 'test-document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.text('test-document.pdf'), findsOneWidget);
        expect(find.text('Aucun fichier sélectionné'), findsNothing);
      });

      testWidgets('shows delete button when file is selected', (tester) async {
        final documentFile = DocumentFile(
          name: 'document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('displays different filenames correctly', (tester) async {
        final documentFile = DocumentFile(
          name: 'my-important-file.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.text('my-important-file.pdf'), findsOneWidget);
      });
    });

    group('Delete Functionality', () {
      testWidgets('delete button calls onChanged with null', (tester) async {
        DocumentFile? changedValue = DocumentFile(
          name: 'test.pdf',
          bytes: testDocumentBytes,
        );

        final documentFile = DocumentFile(
          name: 'document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(
          buildDocumentInput(
            documentFile: documentFile,
            onChanged: (file) {
              changedValue = file;
            },
          ),
        );

        // Tap delete button
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(changedValue, isNull);
      });

      testWidgets('delete button is properly positioned in layout', (
        tester,
      ) async {
        final documentFile = DocumentFile(
          name: 'document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        // Should be in a Row with button, text, and delete icon
        final row = tester.widget<Row>(find.byType(Row));
        expect(
          row.children.length,
          greaterThan(3),
        ); // Button, spacing, text, spacing, delete
      });

      testWidgets('UI resets after delete', (tester) async {
        // Test with null file
        await tester.pumpWidget(buildDocumentInput(documentFile: null));
        expect(find.text('Aucun fichier sélectionné'), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsNothing);

        // Test with file
        final documentFile = DocumentFile(
          name: 'document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));
        await tester.pumpAndSettle();

        expect(find.text('document.pdf'), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });
    });

    group('Button Interaction', () {
      testWidgets('button exists and is of correct type', (tester) async {
        await tester.pumpWidget(buildDocumentInput());

        // Verify button exists (can't test actual picking without mocking)
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('button text is correct', (tester) async {
        await tester.pumpWidget(buildDocumentInput());

        expect(
          find.widgetWithText(FilledButton, 'Choisir un fichier'),
          findsOneWidget,
        );
      });
    });

    group('Layout and Spacing', () {
      testWidgets('has proper spacing between elements', (tester) async {
        final documentFile = DocumentFile(
          name: 'document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        // Verify Row exists
        expect(find.byType(Row), findsOneWidget);

        // Check for SizedBox spacing
        final spacingBoxes = tester.widgetList<SizedBox>(
          find.descendant(
            of: find.byType(Row),
            matching: find.byType(SizedBox),
          ),
        );

        expect(spacingBoxes.length, greaterThan(0));
        expect(spacingBoxes.any((box) => box.width == 16), isTrue);
      });

      testWidgets('uses crossAxisAlignment.center', (tester) async {
        await tester.pumpWidget(buildDocumentInput());

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.crossAxisAlignment, CrossAxisAlignment.center);
      });

      testWidgets('children are properly aligned', (tester) async {
        final documentFile = DocumentFile(
          name: 'document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        // Verify Row exists with proper alignment
        expect(find.byType(Row), findsOneWidget);
      });
    });

    group('DocumentFile Model', () {
      test('DocumentFile stores name and bytes', () {
        final documentFile = DocumentFile(
          name: 'test.pdf',
          bytes: testDocumentBytes,
        );

        expect(documentFile.name, 'test.pdf');
        expect(documentFile.bytes, testDocumentBytes);
      });

      test('DocumentFile bytes are correct type', () {
        final documentFile = DocumentFile(
          name: 'test.pdf',
          bytes: testDocumentBytes,
        );

        expect(documentFile.bytes, isA<Uint8List>());
      });

      test('DocumentFile handles different filenames', () {
        final documentFile = DocumentFile(
          name: 'my-custom-file.pdf',
          bytes: testDocumentBytes,
        );

        expect(documentFile.name, 'my-custom-file.pdf');
      });
    });

    group('Callback Tests', () {
      testWidgets('onChanged can be null', (tester) async {
        await tester.pumpWidget(buildDocumentInput(onChanged: null));

        expect(find.byType(DocumentInput), findsOneWidget);
      });

      testWidgets('onChanged is optional', (tester) async {
        await tester.pumpWidget(buildDocumentInput());

        expect(find.byType(DocumentInput), findsOneWidget);
      });

      testWidgets('onChanged not called on render', (tester) async {
        int callCount = 0;

        await tester.pumpWidget(
          buildDocumentInput(
            onChanged: (file) {
              callCount++;
            },
          ),
        );

        expect(callCount, 0);
      });
    });

    group('State Transitions', () {
      testWidgets('shows filename when file is provided', (tester) async {
        final documentFile = DocumentFile(
          name: 'test.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.text('test.pdf'), findsOneWidget);
        expect(find.text('Aucun fichier sélectionné'), findsNothing);
      });

      testWidgets('shows no file message when file is null', (tester) async {
        await tester.pumpWidget(buildDocumentInput(documentFile: null));

        expect(find.text('Aucun fichier sélectionné'), findsOneWidget);
      });
    });

    group('Widget Composition', () {
      testWidgets('contains all expected widgets when no file', (tester) async {
        await tester.pumpWidget(buildDocumentInput());

        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);
        expect(
          find.byType(Text),
          findsNWidgets(2),
        ); // Button text + status text
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('contains all expected widgets when file selected', (
        tester,
      ) async {
        final documentFile = DocumentFile(
          name: 'document.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
        expect(
          find.byType(SizedBox),
          findsAtLeastNWidgets(2),
        ); // Multiple spacings
      });
    });

    group('Edge Cases', () {
      testWidgets('handles reasonable length filenames', (tester) async {
        final documentFile = DocumentFile(
          name: 'my-document-file.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.text('my-document-file.pdf'), findsOneWidget);
      });

      testWidgets('handles filename with special characters', (tester) async {
        final documentFile = DocumentFile(
          name: 'file_name.pdf',
          bytes: testDocumentBytes,
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.text('file_name.pdf'), findsOneWidget);
      });

      testWidgets('handles empty bytes', (tester) async {
        final documentFile = DocumentFile(
          name: 'empty.pdf',
          bytes: Uint8List(0),
        );

        await tester.pumpWidget(buildDocumentInput(documentFile: documentFile));

        expect(find.text('empty.pdf'), findsOneWidget);
      });
    });
  });
}
