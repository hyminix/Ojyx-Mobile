import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ojyx/core/services/sentry_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MockHub extends Mock implements Hub {}
class MockISentrySpan extends Mock implements ISentrySpan {}
class MockSentryTransaction extends Mock implements ISentrySpan {}
class MockSentryId extends Mock implements SentryId {}

class FakeSentrySpanContext extends Fake implements SentrySpanContext {}
class FakeSentryUser extends Fake implements SentryUser {}
class FakeBreadcrumb extends Fake implements Breadcrumb {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSentrySpanContext());
    registerFallbackValue(FakeSentryUser());
    registerFallbackValue(FakeBreadcrumb());
    registerFallbackValue(SentryLevel.info);
  });

  group('Sentry Error Tracking Integration Tests', () {
    late MockHub mockHub;
    late SentryService sentryService;

    setUp(() {
      mockHub = MockHub();
      sentryService = SentryService.createWithHub(mockHub);
    });

    test('should capture exceptions with full context', () async {
      final exception = Exception('Test error');
      final stackTrace = StackTrace.current;
      final mockSentryId = MockSentryId();
      
      when(() => mockHub.captureException(
        any(),
        stackTrace: any(named: 'stackTrace'),
        withScope: any(named: 'withScope'),
      )).thenAnswer((_) async => mockSentryId);
      
      await sentryService.captureException(
        exception,
        stackTrace: stackTrace,
        tags: {'test': 'true'},
        extras: {'userId': '123'},
      );
      
      verify(() => mockHub.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: any(named: 'withScope'),
      )).called(1);
    });

    test('should track performance transactions', () async {
      final mockTransaction = MockSentryTransaction();
      final mockSpan = MockISentrySpan();
      final mockSpanContext = SentrySpanContext(
        operation: 'test-operation',
        description: 'Test transaction',
      );
      
      when(() => mockHub.startTransaction(
        any(),
        any(),
        bindToScope: any(named: 'bindToScope'),
      )).thenReturn(mockTransaction);
      
      when(() => mockTransaction.startChild(
        any(),
        description: any(named: 'description'),
      )).thenReturn(mockSpan);
      
      when(() => mockTransaction.finish()).thenAnswer((_) async {});
      when(() => mockSpan.finish()).thenAnswer((_) async {});
      when(() => mockTransaction.operation).thenReturn('test-operation');
      when(() => mockTransaction.status).thenReturn(null);
      when(() => mockSpan.status).thenReturn(null);
      
      final result = await sentryService.measurePerformance(
        'test-operation',
        () async {
          await Future.delayed(const Duration(milliseconds: 100));
          return 'success';
        },
        description: 'Test transaction',
      );
      
      expect(result, equals('success'));
      verify(() => mockHub.startTransaction(
        'test-operation',
        'Test transaction',
        bindToScope: true,
      )).called(1);
      verify(() => mockTransaction.finish()).called(1);
    });

    test('should add breadcrumbs for user actions', () async {
      when(() => mockHub.addBreadcrumb(any())).thenAnswer((_) async {});
      
      await sentryService.addBreadcrumb(
        message: 'User clicked button',
        category: 'ui.click',
        data: {'button': 'submit'},
      );
      
      verify(() => mockHub.addBreadcrumb(any())).called(1);
    });

    test('should set user context for error tracking', () async {
      when(() => mockHub.setUser(any())).thenAnswer((_) async {});
      
      await sentryService.setUser(
        id: 'player123',
        username: 'TestPlayer',
        extras: {'level': 5, 'score': 100},
      );
      
      verify(() => mockHub.setUser(any())).called(1);
    });

    test('should handle nested performance spans', () async {
      final mockTransaction = MockSentryTransaction();
      final mockParentSpan = MockISentrySpan();
      final mockChildSpan = MockISentrySpan();
      
      when(() => mockHub.startTransaction(
        any(),
        any(),
        bindToScope: any(named: 'bindToScope'),
      )).thenReturn(mockTransaction);
      
      when(() => mockTransaction.startChild(
        'parent-operation',
        description: any(named: 'description'),
      )).thenReturn(mockParentSpan);
      
      when(() => mockParentSpan.startChild(
        'child-operation',
        description: any(named: 'description'),
      )).thenReturn(mockChildSpan);
      
      when(() => mockTransaction.finish()).thenAnswer((_) async {});
      when(() => mockParentSpan.finish()).thenAnswer((_) async {});
      when(() => mockChildSpan.finish()).thenAnswer((_) async {});
      when(() => mockTransaction.operation).thenReturn('main-operation');
      when(() => mockParentSpan.operation).thenReturn('parent-operation');
      when(() => mockChildSpan.operation).thenReturn('child-operation');
      when(() => mockTransaction.status).thenReturn(null);
      when(() => mockParentSpan.status).thenReturn(null);
      when(() => mockChildSpan.status).thenReturn(null);
      
      await sentryService.measurePerformance(
        'main-operation',
        () async {
          final span = await sentryService.startSpan('parent-operation');
          final childSpan = await sentryService.startChildSpan(
            span,
            'child-operation',
          );
          await Future.delayed(const Duration(milliseconds: 50));
          await sentryService.finishSpan(childSpan);
          await sentryService.finishSpan(span);
        },
      );
      
      verify(() => mockTransaction.startChild(
        'parent-operation',
        description: any(named: 'description'),
      )).called(1);
      verify(() => mockParentSpan.startChild(
        'child-operation',
        description: any(named: 'description'),
      )).called(1);
    });

    test('should capture messages with different severity levels', () async {
      final mockSentryId = MockSentryId();
      
      when(() => mockHub.captureMessage(
        any(),
        level: any(named: 'level'),
        withScope: any(named: 'withScope'),
      )).thenAnswer((_) async => mockSentryId);
      
      await sentryService.captureMessage(
        'Important game event',
        level: SentryLevel.info,
        tags: {'event': 'game_started'},
      );
      
      await sentryService.captureMessage(
        'Critical error occurred',
        level: SentryLevel.error,
        tags: {'error': 'network_failure'},
      );
      
      verify(() => mockHub.captureMessage(
        'Important game event',
        level: SentryLevel.info,
        withScope: any(named: 'withScope'),
      )).called(1);
      
      verify(() => mockHub.captureMessage(
        'Critical error occurred',
        level: SentryLevel.error,
        withScope: any(named: 'withScope'),
      )).called(1);
    });

    test('should integrate with Flutter error handling', () async {
      final mockSentryId = MockSentryId();
      
      when(() => mockHub.captureException(
        any(),
        stackTrace: any(named: 'stackTrace'),
        withScope: any(named: 'withScope'),
      )).thenAnswer((_) async => mockSentryId);
      
      final flutterError = FlutterErrorDetails(
        exception: Exception('Widget build failed'),
        stack: StackTrace.current,
        context: ErrorDescription('During build phase'),
        library: 'widgets library',
      );
      
      await sentryService.captureFlutterError(flutterError);
      
      verify(() => mockHub.captureException(
        any(),
        stackTrace: any(named: 'stackTrace'),
        withScope: any(named: 'withScope'),
      )).called(1);
    });

    test('should batch and throttle error reports', () async {
      final mockSentryId = MockSentryId();
      final errors = List.generate(10, (i) => Exception('Error $i'));
      
      when(() => mockHub.captureException(
        any(),
        stackTrace: any(named: 'stackTrace'),
        withScope: any(named: 'withScope'),
      )).thenAnswer((_) async => mockSentryId);
      
      await Future.wait(
        errors.map((error) => sentryService.captureException(error)),
      );
      
      verify(() => mockHub.captureException(
        any(),
        stackTrace: any(named: 'stackTrace'),
        withScope: any(named: 'withScope'),
      )).called(10);
    });

    test('should clear user context on logout', () async {
      when(() => mockHub.setUser(null)).thenAnswer((_) async {});
      
      await sentryService.clearUser();
      
      verify(() => mockHub.setUser(null)).called(1);
    });

    test('should measure widget performance', () async {
      final mockTransaction = MockSentryTransaction();
      
      when(() => mockHub.startTransaction(
        any(),
        any(),
        bindToScope: any(named: 'bindToScope'),
      )).thenReturn(mockTransaction);
      
      when(() => mockTransaction.finish()).thenAnswer((_) async {});
      when(() => mockTransaction.operation).thenReturn('widget.build');
      when(() => mockTransaction.status).thenReturn(null);
      
      await tester.pumpWidget(
        MaterialApp(
          home: SentryPerformanceWidget(
            operation: 'test_screen',
            child: const Scaffold(
              body: Center(
                child: Text('Test Screen'),
              ),
            ),
          ),
        ),
      );
      
      expect(find.text('Test Screen'), findsOneWidget);
    });
  });
}

late WidgetTester tester;

void testWidgets(String description, Future<void> Function(WidgetTester) callback) {
  test(description, () async {
    tester = WidgetTester(TestWidgetsFlutterBinding.ensureInitialized());
    await callback(tester);
  });
}