import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/widgets/error_handler_widget.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('ErrorHandlerWidget Tests', () {
    testWidgets('Should render nothing when errorMessage is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const ErrorHandlerWidget(errorMessage: null)),
      );

      expect(find.byType(Container), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('Should render nothing when errorMessage is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const ErrorHandlerWidget(errorMessage: '')),
      );

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('Should render error message correctly', (
      WidgetTester tester,
    ) async {
      const message = 'Something went wrong';
      await tester.pumpWidget(
        createTestWidget(const ErrorHandlerWidget(errorMessage: message)),
      );

      expect(find.text(message), findsOneWidget);
      expect(find.text('حدث خطأ'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Should show retry button and trigger callback', (
      WidgetTester tester,
    ) async {
      bool retried = false;
      await tester.pumpWidget(
        createTestWidget(
          ErrorHandlerWidget(
            errorMessage: 'Error',
            onRetry: () => retried = true,
          ),
        ),
      );

      final retryButton = find.byIcon(Icons.refresh);
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      expect(retried, true);
    });

    testWidgets('Should show dismiss button and trigger callback', (
      WidgetTester tester,
    ) async {
      bool dismissed = false;
      await tester.pumpWidget(
        createTestWidget(
          ErrorHandlerWidget(
            errorMessage: 'Error',
            onDismiss: () => dismissed = true,
          ),
        ),
      );

      final dismissButton = find.byIcon(Icons.close);
      expect(dismissButton, findsOneWidget);

      await tester.tap(dismissButton);
      expect(dismissed, true);
    });
  });

  group('BufferingIndicator Tests', () {
    testWidgets('Should render nothing when isBuffering is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const BufferingIndicator(isBuffering: false)),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Should render indicator when isBuffering is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const BufferingIndicator(isBuffering: true)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should render message when provided', (
      WidgetTester tester,
    ) async {
      const message = 'Loading...';
      await tester.pumpWidget(
        createTestWidget(
          const BufferingIndicator(isBuffering: true, message: message),
        ),
      );

      expect(find.text(message), findsOneWidget);
    });
  });

  group('ErrorHandlerWidget Static Methods Tests', () {
    testWidgets('showErrorSnackBar should show SnackBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      ErrorHandlerWidget.showErrorSnackBar(
                        context,
                        'SnackBar Error',
                      );
                    },
                    child: const Text('Show SnackBar'),
                  ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show SnackBar'));
      await tester.pump(); // Start animation
      await tester.pump(
        const Duration(milliseconds: 750),
      ); // Wait for animation

      expect(find.text('SnackBar Error'), findsOneWidget);
    });

    testWidgets('showErrorDialog should show Dialog', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      ErrorHandlerWidget.showErrorDialog(
                        context,
                        'Dialog Error',
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Dialog Error'), findsOneWidget);
      expect(find.text('خطأ'), findsOneWidget);
    });
  });
}
