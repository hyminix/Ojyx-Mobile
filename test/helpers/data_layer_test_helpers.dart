import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/errors/exceptions.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';

/// Mock classes for data layer testing
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder {}
class MockPostgrestResponse extends Mock implements PostgrestResponse {}
class MockRealtimeClient extends Mock implements RealtimeClient {}
class MockRealtimeChannel extends Mock implements RealtimeChannel {}
class MockSupabaseAuth extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockFunctions extends Mock implements FunctionsClient {}
class MockStorage extends Mock implements StorageClient {}

/// Test utilities for data layer testing
class DataLayerTestUtils {
  /// Create a mock Supabase client with common setup
  static MockSupabaseClient createMockSupabaseClient() {
    final client = MockSupabaseClient();
    final auth = MockSupabaseAuth();
    final functions = MockFunctions();
    final storage = MockStorage();
    final realtime = MockRealtimeClient();
    
    when(() => client.auth).thenReturn(auth);
    when(() => client.functions).thenReturn(functions);
    when(() => client.storage).thenReturn(storage);
    when(() => client.realtime).thenReturn(realtime);
    
    return client;
  }

  /// Create a provider container with mocked Supabase
  static ProviderContainer createTestContainer({
    MockSupabaseClient? supabaseClient,
    List<Override> overrides = const [],
  }) {
    final client = supabaseClient ?? createMockSupabaseClient();
    
    final container = ProviderContainer(
      overrides: [
        supabaseClientProvider.overrideWithValue(client),
        ...overrides,
      ],
    );
    
    addTearDown(container.dispose);
    return container;
  }

  /// Setup mock for successful database query
  static void setupSuccessfulQuery<T>({
    required MockSupabaseClient client,
    required String table,
    required T response,
    Map<String, dynamic>? filters,
  }) {
    final queryBuilder = MockSupabaseQueryBuilder();
    final filterBuilder = MockPostgrestFilterBuilder();
    final postgrestResponse = MockPostgrestResponse();
    
    when(() => client.from(table)).thenReturn(queryBuilder);
    
    if (filters != null) {
      when(() => queryBuilder.select(any())).thenReturn(filterBuilder);
      filters.forEach((key, value) {
        when(() => filterBuilder.eq(key, value)).thenReturn(filterBuilder);
      });
      when(() => filterBuilder.execute()).thenAnswer(
        (_) async => postgrestResponse,
      );
    } else {
      when(() => queryBuilder.select(any())).thenReturn(filterBuilder);
      when(() => filterBuilder.execute()).thenAnswer(
        (_) async => postgrestResponse,
      );
    }
    
    when(() => postgrestResponse.data).thenReturn(response);
    when(() => postgrestResponse.error).thenReturn(null);
  }

  /// Setup mock for failed database query
  static void setupFailedQuery({
    required MockSupabaseClient client,
    required String table,
    required String errorMessage,
    String? errorCode,
  }) {
    final queryBuilder = MockSupabaseQueryBuilder();
    final filterBuilder = MockPostgrestFilterBuilder();
    
    when(() => client.from(table)).thenReturn(queryBuilder);
    when(() => queryBuilder.select(any())).thenReturn(filterBuilder);
    when(() => filterBuilder.eq(any(), any())).thenReturn(filterBuilder);
    when(() => filterBuilder.execute()).thenThrow(
      PostgrestException(
        message: errorMessage,
        code: errorCode,
      ),
    );
  }

  /// Setup mock for realtime subscription
  static void setupRealtimeSubscription({
    required MockSupabaseClient client,
    required String channel,
    required Stream<Map<String, dynamic>> stream,
  }) {
    final realtimeChannel = MockRealtimeChannel();
    
    when(() => client.realtime.channel(channel)).thenReturn(realtimeChannel);
    when(() => realtimeChannel.onPostgresChanges(
      event: any(named: 'event'),
      schema: any(named: 'schema'),
      table: any(named: 'table'),
      filter: any(named: 'filter'),
      callback: any(named: 'callback'),
    )).thenReturn(realtimeChannel);
    
    when(() => realtimeChannel.subscribe()).thenAnswer((_) async {
      return realtimeChannel;
    });
  }

  /// Create test data response
  static Map<String, dynamic> createTestResponse({
    required String id,
    Map<String, dynamic>? additionalData,
  }) {
    return {
      'id': id,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      ...?additionalData,
    };
  }
}

/// Base class for data layer tests with common setup
abstract class DataLayerTest {
  late MockSupabaseClient mockSupabaseClient;
  late ProviderContainer container;

  void setupDataLayerTest() {
    mockSupabaseClient = DataLayerTestUtils.createMockSupabaseClient();
    container = DataLayerTestUtils.createTestContainer(
      supabaseClient: mockSupabaseClient,
    );
  }

  void tearDownDataLayerTest() {
    container.dispose();
  }
}

/// Custom matchers for data layer testing
Matcher throwsServerException({String? withMessage}) {
  return throwsA(
    allOf(
      isA<ServerException>(),
      if (withMessage != null)
        predicate<ServerException>(
          (e) => e.message.contains(withMessage),
          'message contains "$withMessage"',
        ),
    ),
  );
}

Matcher throwsCacheException({String? withMessage}) {
  return throwsA(
    allOf(
      isA<CacheException>(),
      if (withMessage != null)
        predicate<CacheException>(
          (e) => e.message.contains(withMessage),
          'message contains "$withMessage"',
        ),
    ),
  );
}

/// Extension for async testing with timeout
extension AsyncTestExtensions on Future<void> Function() {
  Future<void> withTimeout({Duration duration = const Duration(seconds: 5)}) {
    return timeout(duration);
  }
}