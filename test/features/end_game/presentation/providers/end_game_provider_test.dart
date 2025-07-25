import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/end_game/presentation/providers/end_game_provider.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:mocktail/mocktail.dart';

class MockGameState extends Mock implements GameState {}

class MockRoom extends Mock implements Room {}

class StubGameStateNotifier extends GameStateNotifier {
  final GameState? stubState;

  StubGameStateNotifier(this.stubState);

  @override
  GameState? build() => stubState;
}

void main() {
  group('EndGameProvider', () {
    late ProviderContainer container;
    late GameState mockGameState;
    late Room mockRoom;
    late List<GamePlayer> testPlayers;

    PlayerGrid createGridWithScore(int totalScore) {
      final cards = <Card>[];
      var remainingScore = totalScore;

      for (int i = 0; i < 12; i++) {
        int cardValue;
        if (remainingScore > 12) {
          cardValue = 12;
          remainingScore -= 12;
        } else if (remainingScore < -2) {
          cardValue = -2;
          remainingScore -= -2;
        } else {
          cardValue = remainingScore;
          remainingScore = 0;
        }
        cards.add(Card(value: cardValue, isRevealed: true));
      }

      var grid = PlayerGrid.empty();
      for (int i = 0; i < cards.length; i++) {
        final row = i ~/ 4;
        final col = i % 4;
        grid = grid.setCard(row, col, cards[i]);
      }
      return grid;
    }

    setUp(() {
      testPlayers = [
        GamePlayer(
          id: 'player1',
          name: 'Alice',
          grid: createGridWithScore(25),
          hasFinishedRound: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'Bob',
          grid: createGridWithScore(30),
          hasFinishedRound: true,
        ),
        GamePlayer(
          id: 'player3',
          name: 'Charlie',
          grid: createGridWithScore(20),
          hasFinishedRound: true,
        ),
      ];

      mockGameState = MockGameState();
      mockRoom = MockRoom();

      when(() => mockGameState.players).thenReturn(testPlayers);
      when(() => mockGameState.endRoundInitiator).thenReturn('player3');
      when(() => mockGameState.initiatorPlayerId).thenReturn(null);
      when(() => mockGameState.status).thenReturn(GameStatus.finished);
      when(() => mockGameState.roomId).thenReturn('test-room');

      container = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(
            () => StubGameStateNotifier(mockGameState),
          ),
          currentRoomIdProvider.overrideWithValue('test-room'),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide EndGameState when round is ended', () {
      final endGameState = container.read(endGameProvider);

      expect(endGameState, isA<AsyncData<EndGameState?>>());
      expect(endGameState.value, isNotNull);
      expect(endGameState.value!.players.length, equals(3));
      expect(endGameState.value!.roundInitiatorId, equals('player3'));
      expect(endGameState.value!.roundNumber, equals(1));
    });

    test('should return null when round is not ended', () {
      when(() => mockGameState.status).thenReturn(GameStatus.playing);

      container = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(
            () => StubGameStateNotifier(mockGameState),
          ),
          currentRoomIdProvider.overrideWithValue('test-room'),
        ],
      );

      final endGameState = container.read(endGameProvider);

      expect(endGameState, isA<AsyncData<EndGameState?>>());
      expect(endGameState.value, isNull);
    });

    test('should return null when room is not available', () {
      container = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(
            () => StubGameStateNotifier(mockGameState),
          ),
          currentRoomIdProvider.overrideWithValue(null),
        ],
      );

      final endGameState = container.read(endGameProvider);

      expect(endGameState, isA<AsyncData<EndGameState?>>());
      expect(endGameState.value, isNull);
    });

    test('voteToContineProvider should execute without error', () {
      // First read to initialize the state
      final initialState = container.read(endGameProvider);
      expect(initialState.hasValue, isTrue);
      expect(initialState.value, isNotNull);

      // Call vote to continue - this should not throw
      expect(
        () => container.read(voteToContineProvider('player1')),
        returnsNormally,
      );

      // Note: The actual vote update would be handled by the multiplayer system
      // This test just verifies the provider can be called without errors
    });

    test('endGameActionProvider should navigate to home', () {
      bool navigatedToHome = false;

      container = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(
            () => StubGameStateNotifier(mockGameState),
          ),
          currentRoomIdProvider.overrideWithValue('test-room'),
          navigateToHomeProvider.overrideWith((ref) {
            navigatedToHome = true;
          }),
        ],
      );

      container.read(endGameActionProvider);

      expect(navigatedToHome, isTrue);
    });

    test('should watch game state changes', () async {
      // Initial state with finished status
      final listener = container.listen(endGameProvider, (previous, next) {});
      expect(listener.read().value, isNotNull);

      // Create a new container with playing status
      final mockGameStatePlaying = MockGameState();
      when(() => mockGameStatePlaying.players).thenReturn(testPlayers);
      when(() => mockGameStatePlaying.endRoundInitiator).thenReturn('player3');
      when(() => mockGameStatePlaying.initiatorPlayerId).thenReturn(null);
      when(() => mockGameStatePlaying.status).thenReturn(GameStatus.playing);
      when(() => mockGameStatePlaying.roomId).thenReturn('test-room');

      final newContainer = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(
            () => StubGameStateNotifier(mockGameStatePlaying),
          ),
          currentRoomIdProvider.overrideWithValue('test-room'),
        ],
      );

      // State should be null when game is playing
      final playingState = newContainer.read(endGameProvider);
      expect(playingState.value, isNull);

      newContainer.dispose();
    });
  });
}
