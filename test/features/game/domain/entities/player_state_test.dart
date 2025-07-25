import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/player_state.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerState Game Behavior', () {
    test('should track player progress and strategic state throughout gameplay', () {
      // Test behavior: comprehensive state tracking for competitive gameplay
      final gameStateScenarios = [
        // (cards, score, revealed, columns, finished, description)
        (
          List<game.Card?>.generate(12, (i) => i < 6 ? game.Card(value: i + 1, isRevealed: i < 3) : null),
          25,
          3,
          [0, 2],
          false,
          'active player with partial progress'
        ),
        (
          List<game.Card?>.filled(12, null),
          0,
          0,
          const <int>[],
          false,
          'new player starting game'
        ),
        (
          List<game.Card?>.filled(12, null),
          45,
          12,
          const <int>[],
          true,
          'player who finished round'
        ),
        (
          List<game.Card?>.filled(12, null),
          0,
          12,
          [0, 1, 3],
          false,
          'player with multiple column eliminations'
        ),
      ];

      for (final (cards, score, revealed, columns, finished, description) in gameStateScenarios) {
        final playerState = PlayerState(
          playerId: 'player-${gameStateScenarios.indexOf((cards, score, revealed, columns, finished, description))}',
          cards: cards,
          currentScore: score,
          revealedCount: revealed,
          identicalColumns: columns,
          hasFinished: finished,
        );

        // Verify state tracking behavior
        expect(playerState.currentScore, score, reason: 'Score should track competitive performance for $description');
        expect(playerState.revealedCount, revealed, reason: 'Revealed count should track game progress for $description');
        expect(playerState.identicalColumns, columns, reason: 'Column tracking should support rule enforcement for $description');
        expect(playerState.hasFinished, finished, reason: 'Finish status should control turn sequence for $description');
      }
    });

    test('should support immutable state transitions for reliable game updates', () {
      // Test behavior: state mutations preserve game integrity through immutability
      final originalState = PlayerState(
        playerId: 'transitioning-player',
        cards: List<game.Card?>.filled(12, null),
        currentScore: 30,
        revealedCount: 5,
        identicalColumns: [1],
        hasFinished: false,
      );

      final updatedState = originalState.copyWith(
        currentScore: 25,
        hasFinished: true,
      );

      // Verify immutable transition behavior
      expect(originalState.currentScore, 30, reason: 'Original state should remain unchanged');
      expect(originalState.hasFinished, false, reason: 'Original completion status preserved');
      
      expect(updatedState.playerId, originalState.playerId, reason: 'Player identity preserved across transitions');
      expect(updatedState.currentScore, 25, reason: 'Score updated for competitive ranking');
      expect(updatedState.hasFinished, true, reason: 'Game completion status updated correctly');
      expect(updatedState.revealedCount, originalState.revealedCount, reason: 'Unchanged properties preserved');
    });

    test('should maintain value equality for consistent game state comparison', () {
      // Test behavior: state comparison enables reliable game synchronization
      final gameCard = game.Card(value: 5, isRevealed: true);
      final cards = [gameCard, ...List.filled(11, null)];

      final state1 = PlayerState(
        playerId: 'comparison-player',
        cards: cards,
        currentScore: 5,
        revealedCount: 1,
        identicalColumns: [],
        hasFinished: false,
      );

      final state2 = PlayerState(
        playerId: 'comparison-player',
        cards: cards,
        currentScore: 5,
        revealedCount: 1,
        identicalColumns: [],
        hasFinished: false,
      );

      final differentState = state1.copyWith(currentScore: 20);

      // Verify equality behavior for game synchronization
      expect(state1, equals(state2), reason: 'Identical states should be equal for sync verification');
      expect(state1, isNot(equals(differentState)), reason: 'Different states should be detected for update propagation');
    });

    test('should serialize state for network synchronization in multiplayer games', () {
      // Test behavior: state persistence enables multiplayer game continuity
      final gameCard = game.Card(value: 7, isRevealed: true);
      final cards = [gameCard, ...List.filled(11, null)];

      final originalState = PlayerState(
        playerId: 'network-player',
        cards: cards,
        currentScore: 7,
        revealedCount: 1,
        identicalColumns: [2],
        hasFinished: false,
      );

      final json = originalState.toJson();
      final restoredState = PlayerState.fromJson(json);

      // Verify serialization preserves game state for network sync
      expect(restoredState.playerId, originalState.playerId, reason: 'Player identity preserved across network');
      expect(restoredState.currentScore, originalState.currentScore, reason: 'Competitive score preserved');
      expect(restoredState.revealedCount, originalState.revealedCount, reason: 'Game progress preserved');
      expect(restoredState.identicalColumns, originalState.identicalColumns, reason: 'Rule state preserved');
      expect(restoredState.hasFinished, originalState.hasFinished, reason: 'Completion status preserved');
      expect(restoredState.cards.length, originalState.cards.length, reason: 'Card data structure preserved');
    });
  });
}
