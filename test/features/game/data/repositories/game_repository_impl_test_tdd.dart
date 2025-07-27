import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:ojyx/features/game/data/datasources/game_state_datasource.dart';
import 'package:ojyx/features/game/data/repositories/game_repository_impl.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/core/errors/exceptions.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/network/network_info.dart';
import '../../../../helpers/test_data_builders.dart';

// Mock classes
class MockGameStateDataSource extends Mock implements GameStateDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  group('GameRepositoryImpl', () {
    late MockGameStateDataSource mockDataSource;
    late MockNetworkInfo mockNetworkInfo;
    late GameRepositoryImpl repository;
    
    // Test constants
    const TEST_GAME_ID = 'game-123';
    const TEST_ROOM_ID = 'room-456';
    const TEST_PLAYER_ID = 'player-789';
    
    setUp(() {
      mockDataSource = MockGameStateDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = GameRepositoryImpl(
        dataSource: mockDataSource,
        networkInfo: mockNetworkInfo,
      );
    });
    
    // Helper method to create test GameStateModel
    GameStateModel createTestGameStateModel() {
      return GameStateModel(
        id: TEST_GAME_ID,
        roomId: TEST_ROOM_ID,
        players: [
          GamePlayerBuilder()
            .withId(TEST_PLAYER_ID)
            .withName('Test Player')
            .build(),
        ],
        playersState: {},
        currentPlayerId: TEST_PLAYER_ID,
        deck: DeckStateBuilder().build(),
        direction: PlayDirection.forward,
        currentRound: 1,
        maxRounds: 5,
        lastActionTime: DateTime.now(),
        isLastRound: false,
        lastRoundInitiator: null,
        isPaused: false,
      );
    }
    
    group('createGame', () {
      test('should_return_game_state_when_device_is_online_and_creation_succeeds', () async {
        // Arrange
        final gameStateModel = createTestGameStateModel();
        
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.createGameState(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        )).thenAnswer((_) async => gameStateModel);
        
        // Act
        final result = await repository.createGame(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        );
        
        // Assert
        expect(result.isRight(), isTrue,
          reason: 'Should return Right when creation succeeds');
        
        result.fold(
          (failure) => fail('Expected Right but got Left with $failure'),
          (gameState) {
            expect(gameState, isA<GameState>(),
              reason: 'Should return domain GameState entity');
            expect(gameState.id, equals(TEST_GAME_ID),
              reason: 'Game state should have correct ID');
            expect(gameState.roomId, equals(TEST_ROOM_ID),
              reason: 'Game state should be associated with correct room');
          },
        );
        
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockDataSource.createGameState(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        )).called(1);
      });
      
      test('should_return_network_failure_when_device_is_offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        
        // Act
        final result = await repository.createGame(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        );
        
        // Assert
        expect(result.isLeft(), isTrue,
          reason: 'Should return Left when device is offline');
        
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>(),
              reason: 'Should return NetworkFailure when offline');
            expect(failure.message, contains('No internet connection'),
              reason: 'Failure should have descriptive message');
          },
          (_) => fail('Expected Left but got Right'),
        );
        
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNever(() => mockDataSource.createGameState(any(), any()));
      });
      
      test('should_return_server_failure_when_datasource_throws_server_exception', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.createGameState(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        )).thenThrow(ServerException('Database error'));
        
        // Act
        final result = await repository.createGame(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        );
        
        // Assert
        expect(result.isLeft(), isTrue,
          reason: 'Should return Left when server exception occurs');
        
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>(),
              reason: 'Should convert ServerException to ServerFailure');
            expect(failure.message, contains('Database error'),
              reason: 'Failure should preserve error message');
          },
          (_) => fail('Expected Left but got Right'),
        );
      });
      
      test('should_return_unexpected_failure_when_unknown_exception_occurs', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.createGameState(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        )).thenThrow(Exception('Unexpected error'));
        
        // Act
        final result = await repository.createGame(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        );
        
        // Assert
        expect(result.isLeft(), isTrue,
          reason: 'Should return Left for unexpected exceptions');
        
        result.fold(
          (failure) {
            expect(failure, isA<UnexpectedFailure>(),
              reason: 'Should return UnexpectedFailure for unknown errors');
          },
          (_) => fail('Expected Left but got Right'),
        );
      });
    });
    
    group('getGameState', () {
      test('should_return_game_state_when_fetch_is_successful', () async {
        // Arrange
        final gameStateModel = createTestGameStateModel();
        
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.fetchGameState(TEST_GAME_ID))
          .thenAnswer((_) async => gameStateModel);
        
        // Act
        final result = await repository.getGameState(TEST_GAME_ID);
        
        // Assert
        expect(result.isRight(), isTrue,
          reason: 'Should return Right when fetch succeeds');
        
        result.fold(
          (failure) => fail('Expected Right but got Left with $failure'),
          (gameState) {
            expect(gameState.id, equals(TEST_GAME_ID),
              reason: 'Should return game state with correct ID');
          },
        );
      });
      
      test('should_return_not_found_failure_when_game_does_not_exist', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.fetchGameState(TEST_GAME_ID))
          .thenThrow(ServerException('Game state not found'));
        
        // Act
        final result = await repository.getGameState(TEST_GAME_ID);
        
        // Assert
        expect(result.isLeft(), isTrue,
          reason: 'Should return Left when game not found');
        
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>(),
              reason: 'Should return ServerFailure');
            expect(failure.message, contains('not found'),
              reason: 'Message should indicate not found error');
          },
          (_) => fail('Expected Left but got Right'),
        );
      });
    });
    
    group('updateGameState', () {
      test('should_return_updated_game_state_when_update_succeeds', () async {
        // Arrange
        final updates = {'current_player_id': 'player-2', 'turn_number': 2};
        final updatedModel = createTestGameStateModel();
        
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.updateGameState(TEST_GAME_ID, updates))
          .thenAnswer((_) async => updatedModel);
        
        // Act
        final result = await repository.updateGameState(TEST_GAME_ID, updates);
        
        // Assert
        expect(result.isRight(), isTrue,
          reason: 'Should return Right when update succeeds');
        
        verify(() => mockDataSource.updateGameState(TEST_GAME_ID, updates)).called(1);
      });
      
      test('should_return_failure_when_update_violates_constraints', () async {
        // Arrange
        final invalidUpdates = {'current_player_id': 'non-existent-player'};
        
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.updateGameState(TEST_GAME_ID, invalidUpdates))
          .thenThrow(ServerException('Foreign key constraint violation'));
        
        // Act
        final result = await repository.updateGameState(TEST_GAME_ID, invalidUpdates);
        
        // Assert
        expect(result.isLeft(), isTrue,
          reason: 'Should return Left when constraints violated');
        
        result.fold(
          (failure) {
            expect(failure.message, contains('constraint violation'),
              reason: 'Should preserve constraint error message');
          },
          (_) => fail('Expected Left but got Right'),
        );
      });
    });
    
    group('watchGameState', () {
      test('should_emit_game_states_when_subscription_is_active', () async {
        // Arrange
        final gameStateModel1 = createTestGameStateModel();
        final gameStateModel2 = createTestGameStateModel();
        
        final streamController = StreamController<GameStateModel>();
        
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.watchGameState(TEST_GAME_ID))
          .thenAnswer((_) => streamController.stream);
        
        // Act
        final stream = repository.watchGameState(TEST_GAME_ID);
        final emittedResults = <Either<Failure, GameState>>[];
        
        final subscription = stream.listen(emittedResults.add);
        
        // Emit test data
        streamController.add(gameStateModel1);
        streamController.add(gameStateModel2);
        
        await Future.delayed(Duration(milliseconds: 100));
        
        // Assert
        expect(emittedResults.length, equals(2),
          reason: 'Should emit all game state updates');
        
        for (final result in emittedResults) {
          expect(result.isRight(), isTrue,
            reason: 'All emissions should be successful');
        }
        
        // Cleanup
        await subscription.cancel();
        await streamController.close();
      });
      
      test('should_emit_failure_when_stream_errors_occur', () async {
        // Arrange
        final streamController = StreamController<GameStateModel>();
        
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.watchGameState(TEST_GAME_ID))
          .thenAnswer((_) => streamController.stream);
        
        // Act
        final stream = repository.watchGameState(TEST_GAME_ID);
        final emittedResults = <Either<Failure, GameState>>[];
        
        final subscription = stream.listen(emittedResults.add);
        
        // Emit error
        streamController.addError(ServerException('Connection lost'));
        
        await Future.delayed(Duration(milliseconds: 100));
        
        // Assert
        expect(emittedResults.length, equals(1),
          reason: 'Should emit failure when error occurs');
        expect(emittedResults.first.isLeft(), isTrue,
          reason: 'Error should be converted to Left');
        
        // Cleanup
        await subscription.cancel();
        await streamController.close();
      });
      
      test('should_not_emit_when_device_is_offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        
        // Act
        final stream = repository.watchGameState(TEST_GAME_ID);
        final emittedResults = <Either<Failure, GameState>>[];
        
        final subscription = stream.listen(emittedResults.add);
        
        await Future.delayed(Duration(milliseconds: 100));
        
        // Assert
        expect(emittedResults.length, equals(1),
          reason: 'Should emit one failure when offline');
        expect(emittedResults.first.isLeft(), isTrue,
          reason: 'Should emit NetworkFailure');
        
        emittedResults.first.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected NetworkFailure'),
        );
        
        // Cleanup
        await subscription.cancel();
      });
    });
  });
}