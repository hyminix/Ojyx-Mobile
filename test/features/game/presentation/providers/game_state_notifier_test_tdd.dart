import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';
import 'package:ojyx/features/game/domain/repositories/game_repository.dart';
import 'package:ojyx/features/game/domain/use_cases/draw_card.dart';
import 'package:ojyx/features/game/domain/use_cases/reveal_card.dart';
import 'package:ojyx/features/game/domain/use_cases/end_turn.dart';
import 'package:ojyx/core/errors/failures.dart';
import '../../../../../helpers/test_data_builders.dart';
import '../../../../../helpers/widget_test_helpers.dart';

// Mock classes
class MockGameRepository extends Mock implements GameRepository {}
class MockDrawCardUseCase extends Mock implements DrawCard {}
class MockRevealCardUseCase extends Mock implements RevealCard {}
class MockEndTurnUseCase extends Mock implements EndTurn {}

// Fake classes for registerFallbackValue
class FakeGameState extends Fake implements GameState {}
class FakeCardPosition extends Fake implements CardPosition {}

void main() {
  group('GameStateNotifier', () {
    late ProviderContainer container;
    late MockGameRepository mockRepository;
    late MockDrawCardUseCase mockDrawCard;
    late MockRevealCardUseCase mockRevealCard;
    late MockEndTurnUseCase mockEndTurn;
    
    // Test constants
    const TEST_GAME_ID = 'game-123';
    const TEST_ROOM_ID = 'room-456';
    const TEST_PLAYER_ID = 'player-789';
    const TEST_CARD_POSITION = CardPosition(row: 0, col: 1);
    
    setUpAll(() {
      registerFallbackValue(FakeGameState());
      registerFallbackValue(FakeCardPosition());
    });
    
    setUp(() {
      mockRepository = MockGameRepository();
      mockDrawCard = MockDrawCardUseCase();
      mockRevealCard = MockRevealCardUseCase();
      mockEndTurn = MockEndTurnUseCase();
      
      container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(mockRepository),
          drawCardUseCaseProvider.overrideWithValue(mockDrawCard),
          revealCardUseCaseProvider.overrideWithValue(mockRevealCard),
          endTurnUseCaseProvider.overrideWithValue(mockEndTurn),
        ],
      );
    });
    
    tearDown(() {
      container.dispose();
    });
    
    GameState createTestGameState({
      String? currentPlayerId,
      bool isLastRound = false,
    }) {
      return GameStateBuilder()
        .withId(TEST_GAME_ID)
        .withRoomId(TEST_ROOM_ID)
        .withCurrentPlayerId(currentPlayerId ?? TEST_PLAYER_ID)
        .withPlayers([
          GamePlayerBuilder()
            .withId(TEST_PLAYER_ID)
            .withName('Test Player')
            .build(),
          GamePlayerBuilder()
            .withId('opponent-1')
            .withName('Opponent')
            .build(),
        ])
        .withLastRound(isLastRound)
        .build();
    }
    
    group('Initial state', () {
      test('should_start_with_loading_state', () {
        // Act
        final state = container.read(gameStateNotifierProvider);
        
        // Assert
        expect(
          state,
          isA<AsyncLoading>(),
          reason: 'Notifier should start in loading state before initialization',
        );
      });
    });
    
    group('loadGame', () {
      test('should_emit_data_state_when_game_loads_successfully', () async {
        // Arrange
        final testGameState = createTestGameState();
        final states = <AsyncValue<GameState>>[];
        
        when(() => mockRepository.getGameState(TEST_GAME_ID))
          .thenAnswer((_) async => Right(testGameState));
        
        container.listen(
          gameStateNotifierProvider,
          (previous, next) => states.add(next),
        );
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .loadGame(TEST_GAME_ID);
        
        // Assert
        expect(
          states.length,
          greaterThanOrEqualTo(2),
          reason: 'Should emit loading then data states',
        );
        expect(
          states.first,
          isA<AsyncLoading>(),
          reason: 'First emission should be loading state',
        );
        expect(
          states.last,
          isA<AsyncData>(),
          reason: 'Final emission should be data state',
        );
        expect(
          states.last.valueOrNull?.id,
          equals(TEST_GAME_ID),
          reason: 'Loaded game should have correct ID',
        );
        
        verify(() => mockRepository.getGameState(TEST_GAME_ID)).called(1);
      });
      
      test('should_emit_error_state_when_loading_fails', () async {
        // Arrange
        final states = <AsyncValue<GameState>>[];
        
        when(() => mockRepository.getGameState(TEST_GAME_ID))
          .thenAnswer((_) async => Left(ServerFailure('Network error')));
        
        container.listen(
          gameStateNotifierProvider,
          (previous, next) => states.add(next),
        );
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .loadGame(TEST_GAME_ID);
        
        // Assert
        expect(
          states.last,
          isA<AsyncError>(),
          reason: 'Should emit error state when repository fails',
        );
        expect(
          states.last.error,
          isA<GameStateException>(),
          reason: 'Error should be wrapped in GameStateException',
        );
        expect(
          states.last.error.toString(),
          contains('Network error'),
          reason: 'Error message should be preserved',
        );
      });
    });
    
    group('drawCard', () {
      test('should_update_state_when_draw_card_succeeds', () async {
        // Arrange
        final initialState = createTestGameState();
        final drawnCard = CardBuilder().withValue(7).build();
        final updatedState = createTestGameState();
        
        container.read(gameStateNotifierProvider.notifier).state = 
          AsyncData(initialState);
        
        when(() => mockDrawCard(DrawCardParams(
          gameState: any(named: 'gameState'),
          playerId: TEST_PLAYER_ID,
        ))).thenAnswer((_) async => Right(updatedState));
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .drawCard(TEST_PLAYER_ID);
        
        // Assert
        final state = container.read(gameStateNotifierProvider);
        expect(
          state,
          isA<AsyncData>(),
          reason: 'State should remain in data after successful draw',
        );
        
        verify(() => mockDrawCard(any())).called(1);
      });
      
      test('should_emit_error_when_draw_card_fails', () async {
        // Arrange
        final initialState = createTestGameState();
        container.read(gameStateNotifierProvider.notifier).state = 
          AsyncData(initialState);
        
        when(() => mockDrawCard(any()))
          .thenAnswer((_) async => Left(GameFailure('Deck is empty')));
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .drawCard(TEST_PLAYER_ID);
        
        // Assert
        final state = container.read(gameStateNotifierProvider);
        expect(
          state,
          isA<AsyncError>(),
          reason: 'Should emit error when draw fails',
        );
        expect(
          state.error.toString(),
          contains('Deck is empty'),
          reason: 'Error should contain failure message',
        );
      });
      
      test('should_not_allow_draw_when_not_players_turn', () async {
        // Arrange
        final gameState = createTestGameState(currentPlayerId: 'opponent-1');
        container.read(gameStateNotifierProvider.notifier).state = 
          AsyncData(gameState);
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .drawCard(TEST_PLAYER_ID);
        
        // Assert
        final state = container.read(gameStateNotifierProvider);
        expect(
          state,
          isA<AsyncError>(),
          reason: 'Should emit error when drawing out of turn',
        );
        
        verifyNever(() => mockDrawCard(any()));
      });
    });
    
    group('revealCard', () {
      test('should_update_local_state_immediately_when_revealing_card', () async {
        // Arrange
        final initialState = createTestGameState();
        container.read(gameStateNotifierProvider.notifier).state = 
          AsyncData(initialState);
        
        when(() => mockRevealCard(RevealCardParams(
          gameState: any(named: 'gameState'),
          playerId: TEST_PLAYER_ID,
          position: TEST_CARD_POSITION,
        ))).thenAnswer((_) async => Right(unit));
        
        when(() => mockRepository.updateGameState(any(), any()))
          .thenAnswer((_) async => Right(initialState));
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .revealCard(TEST_PLAYER_ID, TEST_CARD_POSITION);
        
        // Assert
        verify(() => mockRevealCard(any())).called(1);
        verify(() => mockRepository.updateGameState(any(), any())).called(1);
      });
      
      test('should_handle_reveal_card_validation_error', () async {
        // Arrange
        final gameState = createTestGameState();
        container.read(gameStateNotifierProvider.notifier).state = 
          AsyncData(gameState);
        
        when(() => mockRevealCard(any()))
          .thenAnswer((_) async => Left(GameFailure('Card already revealed')));
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .revealCard(TEST_PLAYER_ID, TEST_CARD_POSITION);
        
        // Assert
        final state = container.read(gameStateNotifierProvider);
        expect(
          state,
          isA<AsyncError>(),
          reason: 'Should emit error for validation failures',
        );
        expect(
          state.error.toString(),
          contains('Card already revealed'),
          reason: 'Error should contain validation message',
        );
      });
    });
    
    group('endTurn', () {
      test('should_progress_to_next_player_when_ending_turn', () async {
        // Arrange
        final currentState = createTestGameState();
        final nextState = createTestGameState(currentPlayerId: 'opponent-1');
        
        container.read(gameStateNotifierProvider.notifier).state = 
          AsyncData(currentState);
        
        when(() => mockEndTurn(EndTurnParams(gameState: any(named: 'gameState'))))
          .thenAnswer((_) async => Right(nextState));
        
        when(() => mockRepository.updateGameState(any(), any()))
          .thenAnswer((_) async => Right(nextState));
        
        // Act
        await container.read(gameStateNotifierProvider.notifier).endTurn();
        
        // Assert
        final state = container.read(gameStateNotifierProvider);
        expect(
          state.valueOrNull?.currentPlayerId,
          equals('opponent-1'),
          reason: 'Current player should change after ending turn',
        );
        
        verify(() => mockEndTurn(any())).called(1);
      });
      
      test('should_handle_last_round_when_ending_turn', () async {
        // Arrange
        final currentState = createTestGameState(isLastRound: true);
        container.read(gameStateNotifierProvider.notifier).state = 
          AsyncData(currentState);
        
        when(() => mockEndTurn(any()))
          .thenAnswer((_) async => Right(currentState));
        
        when(() => mockRepository.updateGameState(any(), any()))
          .thenAnswer((_) async => Right(currentState));
        
        // Act
        await container.read(gameStateNotifierProvider.notifier).endTurn();
        
        // Assert
        verify(() => mockEndTurn(any())).called(1);
        // Additional last round specific assertions
      });
    });
    
    group('Real-time updates', () {
      test('should_subscribe_to_game_updates_after_loading', () async {
        // Arrange
        final testGameState = createTestGameState();
        final updateStream = Stream<GameState>.fromIterable([
          testGameState,
          createTestGameState(currentPlayerId: 'opponent-1'),
        ]);
        
        when(() => mockRepository.getGameState(TEST_GAME_ID))
          .thenAnswer((_) async => Right(testGameState));
        
        when(() => mockRepository.watchGameState(TEST_GAME_ID))
          .thenAnswer((_) => updateStream.map((state) => Right(state)));
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .loadGame(TEST_GAME_ID);
        
        await Future.delayed(Duration(milliseconds: 100));
        
        // Assert
        verify(() => mockRepository.watchGameState(TEST_GAME_ID)).called(1);
      });
      
      test('should_emit_updates_from_realtime_subscription', () async {
        // Arrange
        final states = <AsyncValue<GameState>>[];
        final streamController = StreamController<Either<Failure, GameState>>();
        
        final initialState = createTestGameState();
        when(() => mockRepository.getGameState(TEST_GAME_ID))
          .thenAnswer((_) async => Right(initialState));
        
        when(() => mockRepository.watchGameState(TEST_GAME_ID))
          .thenAnswer((_) => streamController.stream);
        
        container.listen(
          gameStateNotifierProvider,
          (previous, next) => states.add(next),
        );
        
        // Act
        await container.read(gameStateNotifierProvider.notifier)
          .loadGame(TEST_GAME_ID);
        
        // Emit updates
        streamController.add(Right(createTestGameState(currentPlayerId: 'opponent-1')));
        await Future.delayed(Duration(milliseconds: 50));
        
        // Assert
        expect(
          states.where((s) => s is AsyncData).length,
          greaterThanOrEqualTo(2),
          reason: 'Should emit initial load and stream update',
        );
        
        // Cleanup
        await streamController.close();
      });
    });
  });
}