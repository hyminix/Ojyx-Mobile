# Data Layer TDD Testing Guide

## Overview

This guide provides patterns and conventions for testing the data layer following TDD principles in the Ojyx project.

## Test Structure

### 1. Naming Convention

```dart
// Use should_when pattern
test('should_return_game_state_when_fetch_is_successful', () async {
  // test implementation
});

test('should_throw_server_exception_when_api_returns_error', () async {
  // test implementation
});
```

### 2. Test Organization

```dart
void main() {
  group('GameStateDataSource', () {
    late MockSupabaseClient mockClient;
    late GameStateDataSourceImpl dataSource;
    
    setUp(() {
      mockClient = DataLayerTestUtils.createMockSupabaseClient();
      dataSource = GameStateDataSourceImpl(client: mockClient);
    });
    
    tearDown(() {
      // Clean up if needed
    });
    
    group('fetchGameState', () {
      test('should_return_game_state_when_fetch_is_successful', () async {
        // Arrange
        const gameId = 'test-game-id';
        final responseData = _createValidGameStateResponse();
        
        DataLayerTestUtils.setupSuccessfulQuery(
          client: mockClient,
          table: 'game_states',
          response: responseData,
          filters: {'id': gameId},
        );
        
        // Act
        final result = await dataSource.fetchGameState(gameId);
        
        // Assert
        expect(result, isA<GameStateModel>());
        expect(result.id, equals(gameId));
        verify(() => mockClient.from('game_states')).called(1);
      });
      
      test('should_throw_server_exception_when_api_returns_error', () async {
        // Arrange
        const gameId = 'test-game-id';
        
        DataLayerTestUtils.setupFailedQuery(
          client: mockClient,
          table: 'game_states',
          errorMessage: 'Network error',
          errorCode: 'NETWORK_ERROR',
        );
        
        // Act & Assert
        await expectLater(
          () => dataSource.fetchGameState(gameId),
          throwsServerException(withMessage: 'Network error'),
        );
      });
    });
  });
}
```

## Key Patterns

### 1. DataSource Testing

```dart
group('DataSource Tests', () {
  // Always test happy path
  test('should_successfully_fetch_data_when_api_call_succeeds', () async {
    // Arrange: Setup mock responses
    // Act: Call the datasource method
    // Assert: Verify correct data returned and API called
  });
  
  // Always test error cases
  test('should_throw_server_exception_when_api_fails', () async {
    // Arrange: Setup error response
    // Act & Assert: Verify exception thrown
  });
  
  // Test data transformation
  test('should_correctly_transform_response_to_model', () async {
    // Arrange: Complex response data
    // Act: Call method
    // Assert: Verify all fields mapped correctly
  });
});
```

### 2. Repository Testing

```dart
group('Repository Tests', () {
  late MockDataSource mockDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late RepositoryImpl repository;
  
  setUp(() {
    mockDataSource = MockDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RepositoryImpl(
      dataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  
  test('should_return_data_when_datasource_call_succeeds', () async {
    // Arrange
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockDataSource.fetchData()).thenAnswer((_) async => testData);
    
    // Act
    final result = await repository.getData();
    
    // Assert
    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail('Should return Right'),
      (data) => expect(data, equals(expectedEntity)),
    );
  });
  
  test('should_return_failure_when_device_is_offline', () async {
    // Arrange
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    
    // Act
    final result = await repository.getData();
    
    // Assert
    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Should return Left'),
    );
  });
});
```

### 3. Model Testing

```dart
group('Model Tests', () {
  test('should_create_model_from_json_when_data_is_valid', () {
    // Arrange
    final json = {
      'id': 'test-id',
      'name': 'Test Name',
      'created_at': '2024-01-01T00:00:00Z',
    };
    
    // Act
    final model = TestModel.fromJson(json);
    
    // Assert
    expect(model.id, equals('test-id'));
    expect(model.name, equals('Test Name'));
    expect(model.createdAt, isA<DateTime>());
  });
  
  test('should_convert_model_to_json_when_serializing', () {
    // Arrange
    final model = TestModel(
      id: 'test-id',
      name: 'Test Name',
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );
    
    // Act
    final json = model.toJson();
    
    // Assert
    expect(json['id'], equals('test-id'));
    expect(json['name'], equals('Test Name'));
    expect(json['created_at'], equals('2024-01-01T00:00:00.000Z'));
  });
  
  test('should_handle_null_values_when_json_has_optional_fields', () {
    // Arrange
    final json = {
      'id': 'test-id',
      'name': null,
    };
    
    // Act
    final model = TestModel.fromJson(json);
    
    // Assert
    expect(model.id, equals('test-id'));
    expect(model.name, isNull);
  });
});
```

## Test Helpers Usage

### 1. Mock Setup

```dart
// Use provided helpers for consistent mock setup
final mockClient = DataLayerTestUtils.createMockSupabaseClient();

// Setup successful query
DataLayerTestUtils.setupSuccessfulQuery(
  client: mockClient,
  table: 'users',
  response: [{'id': '1', 'name': 'John'}],
  filters: {'active': true},
);

// Setup failed query
DataLayerTestUtils.setupFailedQuery(
  client: mockClient,
  table: 'users',
  errorMessage: 'Permission denied',
  errorCode: 'PGRST301',
);
```

### 2. Custom Matchers

```dart
// Use custom matchers for exceptions
expect(
  () => dataSource.fetchData(),
  throwsServerException(withMessage: 'Network error'),
);

expect(
  () => localDataSource.getCache(),
  throwsCacheException(withMessage: 'No data found'),
);
```

## Best Practices

1. **Always use Arrange-Act-Assert pattern**
   - Clearly separate setup, execution, and verification

2. **Test edge cases**
   - Empty lists
   - Null values
   - Invalid data formats
   - Network failures

3. **Mock at the right level**
   - DataSource tests: Mock external dependencies (Supabase, HTTP)
   - Repository tests: Mock DataSources
   - Model tests: No mocks needed

4. **Use meaningful test data**
   - Create realistic test data
   - Use builders for complex objects
   - Extract common test data to constants

5. **Verify interactions**
   - Use `verify` to ensure methods called correctly
   - Check call counts when important

## Example: Complete DataSource Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../helpers/data_layer_test_helpers.dart';

void main() {
  group('GameStateDataSourceImpl', () {
    late MockSupabaseClient mockClient;
    late GameStateDataSourceImpl dataSource;
    
    setUp(() {
      mockClient = DataLayerTestUtils.createMockSupabaseClient();
      dataSource = GameStateDataSourceImpl(supabaseClient: mockClient);
    });
    
    group('createGameState', () {
      const testRoomId = 'room-123';
      const testPlayerId = 'player-123';
      
      test('should_create_game_state_when_request_is_valid', () async {
        // Arrange
        final expectedResponse = {
          'id': 'game-123',
          'room_id': testRoomId,
          'current_player_id': testPlayerId,
          'created_at': DateTime.now().toIso8601String(),
        };
        
        DataLayerTestUtils.setupSuccessfulQuery(
          client: mockClient,
          table: 'game_states',
          response: expectedResponse,
        );
        
        // Act
        final result = await dataSource.createGameState(
          roomId: testRoomId,
          currentPlayerId: testPlayerId,
        );
        
        // Assert
        expect(result, isA<GameStateModel>());
        expect(result.roomId, equals(testRoomId));
        expect(result.currentPlayerId, equals(testPlayerId));
        
        verify(() => mockClient.from('game_states')).called(1);
      });
      
      test('should_throw_server_exception_when_creation_fails', () async {
        // Arrange
        DataLayerTestUtils.setupFailedQuery(
          client: mockClient,
          table: 'game_states',
          errorMessage: 'Duplicate room_id',
          errorCode: 'P0001',
        );
        
        // Act & Assert
        await expectLater(
          () => dataSource.createGameState(
            roomId: testRoomId,
            currentPlayerId: testPlayerId,
          ),
          throwsServerException(withMessage: 'Duplicate room_id'),
        );
      });
    });
    
    group('watchGameState', () {
      test('should_emit_game_state_updates_when_subscribed', () async {
        // Arrange
        const gameId = 'game-123';
        final updates = [
          {'id': gameId, 'current_player_id': 'player-1'},
          {'id': gameId, 'current_player_id': 'player-2'},
        ];
        
        final streamController = StreamController<Map<String, dynamic>>();
        DataLayerTestUtils.setupRealtimeSubscription(
          client: mockClient,
          channel: 'game_states:$gameId',
          stream: streamController.stream,
        );
        
        // Act
        final stream = dataSource.watchGameState(gameId);
        final emittedStates = <GameStateModel>[];
        
        final subscription = stream.listen(emittedStates.add);
        
        // Emit updates
        for (final update in updates) {
          streamController.add(update);
        }
        await Future.delayed(Duration(milliseconds: 100));
        
        // Assert
        expect(emittedStates.length, equals(2));
        expect(emittedStates[0].currentPlayerId, equals('player-1'));
        expect(emittedStates[1].currentPlayerId, equals('player-2'));
        
        // Cleanup
        await subscription.cancel();
        await streamController.close();
      });
    });
  });
}