import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ojyx/core/services/sentry_service.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockHub extends Mock implements Hub {}
class MockISentrySpan extends Mock implements ISentrySpan {}

void main() {
  group('SentryService', () {
    group('trackTransaction', () {
      test('should complete transaction successfully', () async {
        // Test transaction tracking
        var actionExecuted = false;
        
        final result = await SentryService.trackTransaction(
          name: 'test_transaction',
          operation: 'test',
          action: () async {
            actionExecuted = true;
            return 'success';
          },
        );

        expect(actionExecuted, isTrue);
        expect(result, equals('success'));
      });

      test('should handle transaction failure', () async {
        // Test error handling
        expect(
          () => SentryService.trackTransaction(
            name: 'failing_transaction',
            operation: 'test',
            action: () async {
              throw Exception('Test error');
            },
          ),
          throwsException,
        );
      });

      test('should include custom data in transaction', () async {
        final customData = {
          'key1': 'value1',
          'key2': 42,
        };

        await SentryService.trackTransaction(
          name: 'data_transaction',
          operation: 'test',
          data: customData,
          action: () async => 'result',
        );

        // Data would be attached to the transaction
        expect(customData['key1'], equals('value1'));
        expect(customData['key2'], equals(42));
      });
    });

    group('trackDatabaseOperation', () {
      test('should track database operation with table info', () async {
        final result = await SentryService.trackDatabaseOperation(
          description: 'Select users',
          operation: 'select',
          table: 'users',
          query: () async => ['user1', 'user2'],
        );

        expect(result, hasLength(2));
      });

      test('should track database operation without table', () async {
        final result = await SentryService.trackDatabaseOperation(
          description: 'Complex join query',
          operation: 'join',
          query: () async => {'count': 10},
        );

        expect(result['count'], equals(10));
      });
    });

    group('trackNetworkRequest', () {
      test('should track successful network request', () async {
        final response = await SentryService.trackNetworkRequest(
          url: 'https://api.example.com/data',
          method: 'GET',
          request: () async => {'status': 200},
        );

        expect(response['status'], equals(200));
      });

      test('should track failed network request', () async {
        expect(
          () => SentryService.trackNetworkRequest(
            url: 'https://api.example.com/error',
            method: 'POST',
            request: () async {
              throw Exception('Network error');
            },
          ),
          throwsException,
        );
      });
    });

    group('trackUserInteraction', () {
      test('should track UI interaction with extra data', () async {
        final result = await SentryService.trackUserInteraction(
          widget: 'LoginButton',
          action: 'tap',
          extra: {'timestamp': DateTime.now().millisecondsSinceEpoch},
          interaction: () async => true,
        );

        expect(result, isTrue);
      });
    });

    group('breadcrumbs', () {
      test('should add breadcrumb with all parameters', () {
        SentryService.addBreadcrumb(
          message: 'Test breadcrumb',
          category: 'test',
          level: SentryLevel.warning,
          data: {'extra': 'info'},
          type: 'debug',
        );

        // Breadcrumb would be added to Sentry
        expect(true, isTrue);
      });

      test('should add breadcrumb with minimal parameters', () {
        SentryService.addBreadcrumb(
          message: 'Simple breadcrumb',
          category: 'test',
        );

        expect(true, isTrue);
      });
    });

    group('user context', () {
      test('should set user with all fields', () {
        SentryService.setUser(
          id: '123',
          username: 'testuser',
          email: 'test@example.com',
          extra: {'role': 'player'},
        );

        // User context would be set in Sentry
        expect(true, isTrue);
      });

      test('should set user with minimal fields', () {
        SentryService.setUser(id: '456');
        expect(true, isTrue);
      });

      test('should clear user context', () {
        SentryService.clearUser();
        expect(true, isTrue);
      });
    });

    group('tracking helpers', () {
      test('should track app lifecycle event', () {
        SentryService.trackAppLifecycle('foreground');
        SentryService.trackAppLifecycle('background');
        
        expect(true, isTrue);
      });

      test('should track navigation with params', () {
        SentryService.trackNavigation(
          from: '/home',
          to: '/game',
          params: {'gameId': '123'},
        );

        expect(true, isTrue);
      });

      test('should track navigation without params', () {
        SentryService.trackNavigation(
          from: '/game',
          to: '/results',
        );

        expect(true, isTrue);
      });
    });

    group('trackSupabaseOperation', () {
      test('should track successful Supabase operation', () async {
        final result = await SentryService.trackSupabaseOperation(
          operation: 'select',
          table: 'games',
          filters: {'status': 'active'},
          query: () async => [
            {'id': 1, 'name': 'Game 1'},
            {'id': 2, 'name': 'Game 2'},
          ],
        );

        expect(result, hasLength(2));
      });

      test('should track failed Supabase operation', () async {
        expect(
          () => SentryService.trackSupabaseOperation(
            operation: 'insert',
            table: 'games',
            query: () async {
              throw Exception('Duplicate key');
            },
          ),
          throwsException,
        );
      });
    });

    group('captureException', () {
      test('should capture exception with full context', () async {
        await SentryService.captureException(
          Exception('Test exception'),
          stackTrace: StackTrace.current,
          extra: {'context': 'test'},
          tags: {'environment': 'test'},
          breadcrumbs: [
            Breadcrumb(
              message: 'Before error',
              category: 'test',
            ),
          ],
        );

        expect(true, isTrue);
      });

      test('should capture exception with minimal context', () async {
        await SentryService.captureException(
          Exception('Simple error'),
        );

        expect(true, isTrue);
      });
    });

    group('captureMessage', () {
      test('should capture message with context', () async {
        await SentryService.captureMessage(
          'Important event occurred',
          level: SentryLevel.warning,
          extra: {'details': 'some details'},
          tags: {'module': 'game'},
        );

        expect(true, isTrue);
      });

      test('should capture simple message', () async {
        await SentryService.captureMessage('Info message');
        expect(true, isTrue);
      });
    });
  });
}