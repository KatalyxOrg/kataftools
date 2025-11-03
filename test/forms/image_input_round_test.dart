import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('ImageInputRound', () {
    const testNetworkUrl = 'https://example.com/image.jpg';
    late Uint8List testImageBytes;

    setUp(() {
      // Create a small test image (1x1 pixel PNG)
      testImageBytes = Uint8List.fromList([
        137, 80, 78, 71, 13, 10, 26, 10, // PNG signature
        0, 0, 0, 13, 73, 72, 68, 82, // IHDR chunk
        0, 0, 0, 1, 0, 0, 0, 1, // 1x1 dimensions
        8, 2, 0, 0, 0, 144, 119, 83, 222,
        0, 0, 0, 12, 73, 68, 65, 84, // IDAT chunk
        8, 153, 99, 0, 1, 0, 0, 5, 0, 1, 13, 10, 46, 180,
        0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130, // IEND chunk
      ]);
    });

    Widget buildImageInputRound({String networkImageUrl = testNetworkUrl, ImageFile? imageFile, Function(ImageFile?)? onChanged, double size = 92}) {
      return MaterialApp(
        home: Scaffold(
          body: ImageInputRound(networkImageUrl: networkImageUrl, imageFile: imageFile, onChanged: onChanged, size: size),
        ),
      );
    }

    group('Circular Shape', () {
      testWidgets('renders circular container with correct border radius', (tester) async {
        const testSize = 92.0;

        await tester.pumpWidget(buildImageInputRound(size: testSize));

        final container = tester.widget<Container>(find.descendant(of: find.byType(ImageInputRound), matching: find.byType(Container)).first);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(testSize / 2));
      });

      testWidgets('ClipRRect has circular border radius', (tester) async {
        const testSize = 100.0;

        await tester.pumpWidget(buildImageInputRound(size: testSize));

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, BorderRadius.circular(testSize / 2));
      });

      testWidgets('respects custom size for circular shape', (tester) async {
        const customSize = 120.0;

        await tester.pumpWidget(buildImageInputRound(size: customSize));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.height, customSize);
        expect(sizedBox.width, customSize);
      });
    });

    group('Size Parameter', () {
      testWidgets('uses default size when not specified', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.height, 92);
        expect(sizedBox.width, 92);
      });

      testWidgets('respects custom size parameter', (tester) async {
        const customSize = 150.0;

        await tester.pumpWidget(buildImageInputRound(size: customSize));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.height, customSize);
        expect(sizedBox.width, customSize);
      });

      testWidgets('handles small size', (tester) async {
        await tester.pumpWidget(buildImageInputRound(size: 50));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.height, 50);
        expect(sizedBox.width, 50);
      });

      testWidgets('handles large size', (tester) async {
        await tester.pumpWidget(buildImageInputRound(size: 200));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.height, 200);
        expect(sizedBox.width, 200);
      });

      testWidgets('container dimensions match size parameter', (tester) async {
        const testSize = 100.0;

        await tester.pumpWidget(buildImageInputRound(size: testSize));

        final container = tester.widget<Container>(find.descendant(of: find.byType(ImageInputRound), matching: find.byType(Container)).first);

        expect(container.constraints!.maxHeight, testSize);
        expect(container.constraints!.maxWidth, testSize);
      });
    });

    group('Edit Button', () {
      testWidgets('shows edit button with correct icon', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsOneWidget);
      });

      testWidgets('edit button is positioned at top right', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        final positioned = tester.widget<Positioned>(find.ancestor(of: find.byType(IconButton), matching: find.byType(Positioned)));

        expect(positioned.top, 0);
        expect(positioned.right, 0);
      });
    });

    group('Image Display', () {
      testWidgets('displays local image when imageFile is provided', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInputRound(imageFile: imageFile));
        await tester.pumpAndSettle();

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<MemoryImage>());
        expect(image.fit, BoxFit.cover);
      });

      testWidgets('shows upload icon on network image error', (tester) async {
        await tester.pumpWidget(buildImageInputRound(networkImageUrl: 'https://invalid-url.com/nonexistent.jpg'));

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
      });

      testWidgets('upload icon size is proportional to widget size', (tester) async {
        const testSize = 100.0;

        await tester.pumpWidget(buildImageInputRound(size: testSize, networkImageUrl: 'invalid-url'));

        await tester.pumpAndSettle();

        final icon = tester.widget<Icon>(find.byIcon(Icons.cloud_upload_outlined));
        expect(icon.size, testSize * 0.7);
      });

      testWidgets('prefers local image over network image', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInputRound(networkImageUrl: testNetworkUrl, imageFile: imageFile));
        await tester.pumpAndSettle();

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<MemoryImage>());
      });

      testWidgets('image covers container with BoxFit.cover', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInputRound(imageFile: imageFile));
        await tester.pumpAndSettle();

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, BoxFit.cover);
      });
    });

    group('Interaction', () {
      testWidgets('has GestureDetector for interaction', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        // Note: We can't actually test FilePicker behavior without mocking
        // Just verify GestureDetector is present
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('has GestureDetector for tap handling', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        expect(find.byType(GestureDetector), findsWidgets);
      });
    });

    group('Stack Layout', () {
      testWidgets('uses Stack for layered layout', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        // Should have Stack widgets (multiple including Material internals)
        expect(find.byType(Stack), findsWidgets);
      });

      testWidgets('image fills container with Positioned.fill', (tester) async {
        final imageFile = ImageFile(name: 'test.png', bytes: testImageBytes);

        await tester.pumpWidget(buildImageInputRound(imageFile: imageFile));
        await tester.pumpAndSettle();

        expect(find.byType(Positioned), findsNWidgets(2)); // One for image container, one for button
      });
    });

    group('Theme Integration', () {
      testWidgets('uses theme colors for container decoration', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
            home: Scaffold(
              body: ImageInputRound(networkImageUrl: testNetworkUrl, onChanged: (_) {}),
            ),
          ),
        );

        final container = tester.widget<Container>(find.descendant(of: find.byType(ImageInputRound), matching: find.byType(Container)).first);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isNotNull);
        expect(decoration.border, isNotNull);
      });
    });

    group('Callback Tests', () {
      testWidgets('onChanged can be null', (tester) async {
        await tester.pumpWidget(buildImageInputRound(onChanged: null));

        expect(find.byType(ImageInputRound), findsOneWidget);
      });

      testWidgets('onChanged callback is optional', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        expect(find.byType(ImageInputRound), findsOneWidget);
      });
    });

    group('Comparison with ImageInput', () {
      testWidgets('has circular shape unlike rectangular ImageInput', (tester) async {
        const size = 100.0;

        await tester.pumpWidget(buildImageInputRound(size: size));

        final container = tester.widget<Container>(find.descendant(of: find.byType(ImageInputRound), matching: find.byType(Container)).first);

        final decoration = container.decoration as BoxDecoration;
        // Circular: radius is half the size
        expect(decoration.borderRadius, BorderRadius.circular(size / 2));
      });

      testWidgets('uses IconButton instead of FilledButton', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byType(FilledButton), findsNothing);
      });

      testWidgets('button positioned at top-right instead of bottom', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        final positioned = tester.widget<Positioned>(find.ancestor(of: find.byType(IconButton), matching: find.byType(Positioned)));

        expect(positioned.top, 0);
        expect(positioned.right, 0);
        // Not positioned at bottom
        expect(positioned.bottom, isNull);
      });
    });

    group('Container Decoration', () {
      testWidgets('has border with theme color', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        final container = tester.widget<Container>(find.descendant(of: find.byType(ImageInputRound), matching: find.byType(Container)).first);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
      });

      testWidgets('has surface background color from theme', (tester) async {
        await tester.pumpWidget(buildImageInputRound());

        final container = tester.widget<Container>(find.descendant(of: find.byType(ImageInputRound), matching: find.byType(Container)).first);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isNotNull);
      });
    });
  });
}
