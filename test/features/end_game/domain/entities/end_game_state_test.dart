import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  group('EndGameState', () {
    late List<Player> testPlayers;

    PlayerGrid createGridWithScore(int totalScore) {
      // Create a grid with specific cards to achieve desired score
      // Distribute the score across multiple cards respecting min/max values
      final cards = <Card>[];
      var remainingScore = totalScore;

      for (int i = 0; i < 12; i++) {
        int cardValue;
        if (remainingScore > 12) {
          cardValue = 12; // Use max value
          remainingScore -= 12;
        } else if (remainingScore < -2) {
          cardValue = -2; // Use min value
          remainingScore -= -2;
        } else {
          cardValue = remainingScore;
          remainingScore = 0;
        }
        cards.add(Card(value: cardValue, isRevealed: true));
      }

      // Create grid with cards
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
    });

    test('should create EndGameState with correct properties', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      expect(endGameState.players, equals(testPlayers));
      expect(endGameState.roundInitiatorId, equals('player3'));
      expect(endGameState.roundNumber, equals(1));
    });

    test('should calculate ranked players correctly', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      final rankedPlayers = endGameState.rankedPlayers;

      expect(rankedPlayers.length, equals(3));
      expect(rankedPlayers[0].name, equals('Charlie')); // Score: 20
      expect(rankedPlayers[1].name, equals('Alice')); // Score: 25
      expect(rankedPlayers[2].name, equals('Bob')); // Score: 30
    });

    test('should identify winner correctly', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      expect(endGameState.winner.id, equals('player3'));
      expect(endGameState.winner.name, equals('Charlie'));
    });

    test(
      'should apply penalty to round initiator when not having lowest score',
      () {
        final endGameState = EndGameState(
          players: testPlayers,
          roundInitiatorId: 'player1', // Alice with score 25
          roundNumber: 1,
        );

        final rankedPlayers = endGameState.rankedPlayers;

        // Alice should have her score doubled (25 * 2 = 50)
        final alice = rankedPlayers.firstWhere((p) => p.id == 'player1');
        expect(alice.currentScore, equals(50));

        // Alice should now be last
        expect(rankedPlayers[2].id, equals('player1'));
      },
    );

    test('should not apply penalty when initiator has lowest score', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3', // Charlie with score 20 (lowest)
        roundNumber: 1,
      );

      final rankedPlayers = endGameState.rankedPlayers;

      // Charlie should keep original score
      final charlie = rankedPlayers.firstWhere((p) => p.id == 'player3');
      expect(charlie.currentScore, equals(20));
    });

    test('should not apply penalty when initiator ties for lowest score', () {
      final playersWithTie = [
        Player(
          id: 'player1',
          name: 'Alice',
          grid: createGridWithScore(20),
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

      final endGameState = EndGameState(
        players: playersWithTie,
        roundInitiatorId: 'player1', // Alice with score 20 (tied for lowest)
        roundNumber: 1,
      );

      final rankedPlayers = endGameState.rankedPlayers;

      // Alice should keep original score
      final alice = rankedPlayers.firstWhere((p) => p.id == 'player1');
      expect(alice.currentScore, equals(20));
    });

    test('should have hasVotedToContinue initially false for all players', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      for (final playerId in endGameState.playersVotes.keys) {
        expect(endGameState.playersVotes[playerId], isFalse);
      }
    });

    test('should update player vote correctly', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      final updatedState = endGameState.updatePlayerVote('player1', true);

      expect(updatedState.playersVotes['player1'], isTrue);
      expect(updatedState.playersVotes['player2'], isFalse);
      expect(updatedState.playersVotes['player3'], isFalse);
    });

    test('should determine if should continue based on votes', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      // Initially, no one voted to continue
      expect(endGameState.shouldContinue, isFalse);

      // One player votes to continue
      final state1 = endGameState.updatePlayerVote('player1', true);
      expect(state1.shouldContinue, isFalse);

      // Two players vote to continue (majority)
      final state2 = state1.updatePlayerVote('player2', true);
      expect(state2.shouldContinue, isTrue);
    });

    test('should be immutable with Freezed', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      // This should create a new instance
      final newState = endGameState.copyWith(roundNumber: 2);

      expect(endGameState.roundNumber, equals(1));
      expect(newState.roundNumber, equals(2));
      expect(identical(endGameState, newState), isFalse);
    });

    test('should support json serialization', () {
      final endGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );

      // Should have toJson method
      final json = endGameState.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['round_number'], equals(1));
      expect(json['round_initiator_id'], equals('player3'));

      // Should have fromJson factory
      final fromJson = EndGameState.fromJson(json);
      expect(fromJson.roundNumber, equals(endGameState.roundNumber));
      expect(fromJson.roundInitiatorId, equals(endGameState.roundInitiatorId));
    });
  });
}
