import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('ImageInput', () {
    const testNetworkUrl = 'https://example.com/image.jpg';
    late Uint8List testImageBytes;

    setUp(() {
      // Create a small test image (1x1 pixel)
      testImageBytes = Uint8List.fromList([
        137, 80, 78, 71, 13, 10, 26, 10, // PNG signature
        0, 0, 0, 13, 73, 72, 68, 82, // IHDR chunk
        0, 0, 0, 1, 0, 0, 0, 1, // 1x1 dimensions
        8, 2, 0, 0, 0, 144, 119, 83, 222, // bit depth, color type, etc.
        0, 0, 0, 12, 73, 68, 65, 84, // IDAT chunk
        8, 153, 99, 0, 1, 0, 0, 5, 0, 1, 13, 10, 46, 180,
        0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130, // IEND chunk
      ]);
    });

    Widget buildImageInput({String networkImageUrl = testNetworkUrl, ImageFile? imageFile, Function(ImageFile?)? onChanged, double height = 217}) {
      return MaterialApp(
        home: Scaffold(
          body: ImageInput(networkImageUrl: networkImageUrl, imageFile: imageFile, onChanged: onChanged, height: height),
        ),
      );
    }

    group('Display States', () {
      testWidgets('shows button with correct text', (tester) async {
        await tester.pumpWidget(buildImageInput());

        expect(find.text('Sélectionner une image'), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('renders with specified height', (tester) async {
        const customHeight = 300.0;

        await tester.pumpWidget(buildImageInput(height: customHeight));

        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints!.maxHeight, customHeight);
      });

      testWidgets('shows local imageFile when provided', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInput(imageFile: imageFile));
        await tester.pumpAndSettle();

        // Should render Image.memory widget
        expect(find.byType(Image), findsOneWidget);
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<MemoryImage>());
      });

      testWidgets('shows container with proper decoration', (tester) async {
        await tester.pumpWidget(buildImageInput());

        final container = tester.widget<Container>(find.byType(Container).first);
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.border, isNotNull);
        expect(decoration.borderRadius, BorderRadius.circular(8));
      });

      testWidgets('shows upload icon on network image error', (tester) async {
        await tester.pumpWidget(buildImageInput(networkImageUrl: 'https://invalid-url.com/nonexistent.jpg'));

        // Wait for network error
        await tester.pumpAndSettle();

        // Should show upload icon
        expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
      });

      testWidgets('renders ClipRRect with correct border radius', (tester) async {
        await tester.pumpWidget(buildImageInput());

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect).first);
        expect(clipRRect.borderRadius, BorderRadius.circular(8));
      });
    });

    group('Image Display', () {
      testWidgets('displays local image when imageFile is set', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInput(imageFile: imageFile));
        await tester.pumpAndSettle();

        // Find Image.memory
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, BoxFit.cover);
        expect(image.image, isA<MemoryImage>());
      });

      testWidgets('image covers container with BoxFit.cover', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInput(imageFile: imageFile));
        await tester.pumpAndSettle();

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, BoxFit.cover);
      });

      testWidgets('prefers local image over network image', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInput(networkImageUrl: testNetworkUrl, imageFile: imageFile));
        await tester.pumpAndSettle();

        // Should use MemoryImage (local) not NetworkImage
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<MemoryImage>());
      });
    });

    group('Button Placement', () {
      testWidgets('button is positioned at bottom with correct padding', (tester) async {
        await tester.pumpWidget(buildImageInput());

        final positioned = tester.widget<Positioned>(find.ancestor(of: find.byType(FilledButton), matching: find.byType(Positioned)));

        expect(positioned.bottom, 20);
        expect(positioned.right, isNotNull);
        expect(positioned.left, isNotNull);
      });

      testWidgets('button text is correct', (tester) async {
        await tester.pumpWidget(buildImageInput());

        expect(find.widgetWithText(FilledButton, 'Sélectionner une image'), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('button exists and is tappable', (tester) async {
        await tester.pumpWidget(buildImageInput());

        // Button should exist
        expect(find.byType(FilledButton), findsOneWidget);

        // Note: We can't actually test FilePicker behavior without mocking
        // Just verify the button is present
      });
    });

    group('Callback Tests', () {
      testWidgets('onChanged can be null', (tester) async {
        await tester.pumpWidget(buildImageInput(onChanged: null));

        expect(find.byType(ImageInput), findsOneWidget);
      });

      testWidgets('onChanged callback is optional', (tester) async {
        // Should not throw when onChanged is not provided
        await tester.pumpWidget(buildImageInput());

        expect(find.byType(ImageInput), findsOneWidget);
      });
    });

    group('Custom Height', () {
      testWidgets('respects custom height parameter', (tester) async {
        const customHeight = 400.0;

        await tester.pumpWidget(buildImageInput(height: customHeight));

        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints!.maxHeight, customHeight);
      });

      testWidgets('uses default height when not specified', (tester) async {
        await tester.pumpWidget(buildImageInput());

        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints!.maxHeight, 217);
      });

      testWidgets('handles very small height', (tester) async {
        await tester.pumpWidget(buildImageInput(height: 100));

        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints!.maxHeight, 100);
      });

      testWidgets('handles very large height', (tester) async {
        await tester.pumpWidget(buildImageInput(height: 500));

        final container = tester.widget<Container>(find.byType(Container).first);
        expect(container.constraints!.maxHeight, 500);
      });
    });

    group('ImageFile Model', () {
      test('ImageFile stores name and bytes', () {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        expect(imageFile.name, 'test.png');
        expect(imageFile.bytes, testImageBytes);
      });

      test('ImageFile bytes are correct type', () {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        expect(imageFile.bytes, isA<Uint8List>());
      });
    });

    group('Stack Layout', () {
      testWidgets('uses Stack for layered layout', (tester) async {
        await tester.pumpWidget(buildImageInput());

        // Should have Stack widgets (multiple including Material internals)
        expect(find.byType(Stack), findsWidgets);
      });

      testWidgets('image fills entire container with Positioned.fill', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInput(imageFile: imageFile));
        await tester.pumpAndSettle();

        expect(find.byType(Positioned), findsNWidgets(2)); // One for image, one for button
      });
    });

    group('Theme Integration', () {
      testWidgets('uses theme colors for container', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
            home: Scaffold(
              body: ImageInput(networkImageUrl: testNetworkUrl, onChanged: (_) {}),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container).first);
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, isNotNull);
        expect(decoration.border, isNotNull);
      });
    });
  });
}
