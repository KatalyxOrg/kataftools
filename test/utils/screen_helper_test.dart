import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('ScreenHelper', () {
    late ScreenHelper screenHelper;

    setUp(() {
      screenHelper = ScreenHelper.instance;
      // Reset to default values before each test
      screenHelper.horizontalPadding = 16;
      screenHelper.isMobile = true;
    });

    group('Singleton Pattern', () {
      test('instance returns same object across calls', () {
        final instance1 = ScreenHelper.instance;
        final instance2 = ScreenHelper.instance;
        expect(identical(instance1, instance2), isTrue);
      });

      test('values persist between instance calls', () {
        final instance1 = ScreenHelper.instance;
        instance1.setValues(800);

        final instance2 = ScreenHelper.instance;
        expect(instance2.horizontalPadding, 32);
        expect(instance2.isMobile, false);
      });
    });

    group('Breakpoint Detection - Mobile (< 481px)', () {
      test('sets correct padding for mobile width (480px)', () {
        screenHelper.setValues(480);
        expect(screenHelper.horizontalPadding, 16);
      });

      test('sets isMobile to true for mobile width (480px)', () {
        screenHelper.setValues(480);
        expect(screenHelper.isMobile, true);
      });

      test('sets correct values for very small mobile width (320px)', () {
        screenHelper.setValues(320);
        expect(screenHelper.horizontalPadding, 16);
        expect(screenHelper.isMobile, true);
      });

      test('sets correct values at mobile upper edge (481px)', () {
        screenHelper.setValues(481);
        expect(screenHelper.horizontalPadding, 16);
        expect(screenHelper.isMobile, true);
      });
    });

    group('Breakpoint Detection - Tablet (481px - 768px)', () {
      test('sets correct padding for tablet width (482px)', () {
        screenHelper.setValues(482);
        expect(screenHelper.horizontalPadding, 24);
      });

      test('sets isMobile to false for tablet width (482px)', () {
        screenHelper.setValues(482);
        expect(screenHelper.isMobile, false);
      });

      test('sets correct values for mid-range tablet (600px)', () {
        screenHelper.setValues(600);
        expect(screenHelper.horizontalPadding, 24);
        expect(screenHelper.isMobile, false);
      });

      test('sets correct values at tablet upper edge (768px)', () {
        screenHelper.setValues(768);
        expect(screenHelper.horizontalPadding, 24);
        expect(screenHelper.isMobile, false);
      });
    });

    group('Breakpoint Detection - Desktop (> 768px)', () {
      test('sets correct padding for desktop width (769px)', () {
        screenHelper.setValues(769);
        expect(screenHelper.horizontalPadding, 32);
      });

      test('sets isMobile to false for desktop width (769px)', () {
        screenHelper.setValues(769);
        expect(screenHelper.isMobile, false);
      });

      test('sets correct values for large desktop (1920px)', () {
        screenHelper.setValues(1920);
        expect(screenHelper.horizontalPadding, 32);
        expect(screenHelper.isMobile, false);
      });

      test('sets correct values for ultra-wide (2560px)', () {
        screenHelper.setValues(2560);
        expect(screenHelper.horizontalPadding, 32);
        expect(screenHelper.isMobile, false);
      });
    });

    group('Edge Cases', () {
      test('handles exact breakpoint at 481px (should be mobile)', () {
        screenHelper.setValues(481);
        expect(screenHelper.isMobile, true);
        expect(screenHelper.horizontalPadding, 16);
      });

      test('handles exact breakpoint at 768px (should be tablet)', () {
        screenHelper.setValues(768);
        expect(screenHelper.isMobile, false);
        expect(screenHelper.horizontalPadding, 24);
      });

      test('handles width just above tablet breakpoint (481.1px)', () {
        screenHelper.setValues(481.1);
        expect(screenHelper.isMobile, false);
        expect(screenHelper.horizontalPadding, 24);
      });

      test('handles width just above desktop breakpoint (768.1px)', () {
        screenHelper.setValues(768.1);
        expect(screenHelper.isMobile, false);
        expect(screenHelper.horizontalPadding, 32);
      });

      test('handles zero width (edge case)', () {
        screenHelper.setValues(0);
        expect(screenHelper.isMobile, true);
        expect(screenHelper.horizontalPadding, 16);
      });

      test('handles negative width (invalid but defensive)', () {
        screenHelper.setValues(-100);
        expect(screenHelper.isMobile, true);
        expect(screenHelper.horizontalPadding, 16);
      });
    });

    group('Constants', () {
      test('breakpointPC is 768', () {
        expect(ScreenHelper.breakpointPC, 768);
      });

      test('breakpointTablet is 481', () {
        expect(ScreenHelper.breakpointTablet, 481);
      });

      test('maxContainerWidth is 984', () {
        expect(ScreenHelper.maxContainerWidth, 984);
      });
    });

    group('State Transitions', () {
      test('transitions from mobile to tablet correctly', () {
        screenHelper.setValues(400); // Mobile
        expect(screenHelper.isMobile, true);
        expect(screenHelper.horizontalPadding, 16);

        screenHelper.setValues(500); // Tablet
        expect(screenHelper.isMobile, false);
        expect(screenHelper.horizontalPadding, 24);
      });

      test('transitions from tablet to desktop correctly', () {
        screenHelper.setValues(600); // Tablet
        expect(screenHelper.isMobile, false);
        expect(screenHelper.horizontalPadding, 24);

        screenHelper.setValues(800); // Desktop
        expect(screenHelper.isMobile, false);
        expect(screenHelper.horizontalPadding, 32);
      });

      test('transitions from desktop to mobile correctly', () {
        screenHelper.setValues(1000); // Desktop
        expect(screenHelper.isMobile, false);
        expect(screenHelper.horizontalPadding, 32);

        screenHelper.setValues(400); // Mobile
        expect(screenHelper.isMobile, true);
        expect(screenHelper.horizontalPadding, 16);
      });
    });
  });
}
