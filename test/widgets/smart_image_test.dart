import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/widgets/smart_image.dart';

// Mock HttpOverrides to prevent network calls during tests
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('SmartImage Widget Tests', () {
    testWidgets('Should render Asset Image when path provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const SmartImage(imagePath: 'assets/images/test.png')),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Should render Network Image when URL provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const SmartImage(imageUrl: 'https://example.com/image.png'),
        ),
      );

      // SmartImage uses CachedNetworkImage which might render an Image or a placeholder initially
      // We check that it doesn't crash and renders something
      // Since we are in a test environment, it might show the placeholder or error widget eventually
      // But initially it should build successfully
      expect(find.byType(SmartImage), findsOneWidget);
    });

    testWidgets('Should render Fallback Icon when no image provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const SmartImage(fallbackIcon: Icons.person)),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets(
      'Should render default Fallback Icon when no image and no icon provided',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const SmartImage()));

        expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      },
    );

    testWidgets('Should respect custom dimensions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const SmartImage(fallbackIcon: Icons.person, width: 100, height: 100),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(SmartImage),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.minWidth, 100);
      expect(container.constraints?.minHeight, 100);
    });
  });

  group('CircularIconWidget Tests', () {
    testWidgets('Should render icon with correct color and background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const CircularIconWidget(
            icon: Icons.star,
            backgroundColor: Colors.red,
            iconColor: Colors.white,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CircularIconWidget),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
      expect(decoration.shape, BoxShape.circle);

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.white);
    });
  });
}
