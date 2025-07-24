import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/end_game/presentation/providers/end_game_provider.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:mocktail/mocktail.dart';

class MockGameState extends Mock implements GameState {}

class MockRoom extends Mock implements Room {}

void main() {
  group('EndGameProvider', () {
    late ProviderContainer container;
    late GameState mockGameState;
    late Room mockRoom;
    late List<Player> testPlayers;

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
        Player(
          id: 'player1',
          name: 'Alice',
          grid: createGridWithScore(25),
          hasFinishedRound: true,
        ),
        Player(
          id: 'player2',
          name: 'Bob',
          grid: createGridWithScore(30),
          hasFinishedRound: true,
        ),
        Player(
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
            () => GameStateNotifier()..loadState(mockGameState),
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

      expect(endGameState, isA<AsyncData<EndGameState>>());
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
            () => GameStateNotifier()..loadState(mockGameState),
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
            () => GameStateNotifier()..loadState(mockGameState),
          ),
          currentRoomIdProvider.overrideWithValue(null),
        ],
      );

      final endGameState = container.read(endGameProvider);

      expect(endGameState, isA<AsyncData<EndGameState?>>());
      expect(endGameState.value, isNull);
    });

    test('voteToContineProvider should update player vote', () {
      // First read to initialize the state
      container.read(endGameProvider);

      // Call vote to continue
      container.read(voteToContineProvider('player1'));

      // Check the state was updated
      final updatedState = container.read(endGameProvider);
      expect(updatedState.value!.playersVotes['player1'], isTrue);
    });

    test('endGameActionProvider should navigate to home', () {
      bool navigatedToHome = false;

      container = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(
            () => GameStateNotifier()..loadState(mockGameState),
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
      final notifier = container.listen(endGameProvider, (previous, next) {});

      // Initial state
      expect(notifier.read().value, isNotNull);

      // Simulate game state change
      when(() => mockGameState.status).thenReturn(GameStatus.playing);
      container.refresh(gameStateNotifierProvider);

      // State should update
      expect(notifier.read().value, isNull);
    });
  });
}
