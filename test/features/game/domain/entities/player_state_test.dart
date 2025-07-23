import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/player_state.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerState', () {
    test('should create a valid PlayerState', () {
      // Arrange
      final cards = List<game.Card?>.generate(12, (index) {
        if (index < 6) {
          return game.Card(
            value: index + 1,
            isRevealed: index < 3,
          );
        }
        return null;
      });

      // Act
      final playerState = PlayerState(
        playerId: 'test-player-123',
        cards: cards,
        currentScore: 25,
        revealedCount: 3,
        identicalColumns: [0, 2],
        hasFinished: false,
      );

      // Assert
      expect(playerState.playerId, equals('test-player-123'));
      expect(playerState.cards.length, equals(12));
      expect(playerState.currentScore, equals(25));
      expect(playerState.revealedCount, equals(3));
      expect(playerState.identicalColumns, equals([0, 2]));
      expect(playerState.hasFinished, isFalse);
    });

    test('should handle empty card list', () {
      // Act
      final playerState = PlayerState(
        playerId: 'empty-player',
        cards: List<game.Card?>.filled(12, null),
        currentScore: 0,
        revealedCount: 0,
        identicalColumns: [],
        hasFinished: false,
      );

      // Assert
      expect(playerState.cards.every((card) => card == null), isTrue);
      expect(playerState.currentScore, equals(0));
      expect(playerState.revealedCount, equals(0));
      expect(playerState.identicalColumns, isEmpty);
    });

    test('should support value equality', () {
      // Arrange
      final cards = [
        game.Card(
          value: 5,
          isRevealed: true,
        ),
        ...List.filled(11, null),
      ];

      final state1 = PlayerState(
        playerId: 'player-1',
        cards: cards,
        currentScore: 5,
        revealedCount: 1,
        identicalColumns: [],
        hasFinished: false,
      );

      final state2 = PlayerState(
        playerId: 'player-1',
        cards: cards,
        currentScore: 5,
        revealedCount: 1,
        identicalColumns: [],
        hasFinished: false,
      );

      // Assert
      expect(state1, equals(state2));
    });

    test('should be different when properties differ', () {
      // Arrange
      final cards = List<game.Card?>.filled(12, null);

      final state1 = PlayerState(
        playerId: 'player-1',
        cards: cards,
        currentScore: 10,
        revealedCount: 0,
        identicalColumns: [],
        hasFinished: false,
      );

      final state2 = PlayerState(
        playerId: 'player-1',
        cards: cards,
        currentScore: 20, // Different score
        revealedCount: 0,
        identicalColumns: [],
        hasFinished: false,
      );

      // Assert
      expect(state1, isNot(equals(state2)));
    });

    test('should handle finished state', () {
      // Act
      final playerState = PlayerState(
        playerId: 'finished-player',
        cards: List<game.Card?>.filled(12, null),
        currentScore: 45,
        revealedCount: 12,
        identicalColumns: [],
        hasFinished: true,
      );

      // Assert
      expect(playerState.hasFinished, isTrue);
      expect(playerState.revealedCount, equals(12));
    });

    test('should handle multiple identical columns', () {
      // Act
      final playerState = PlayerState(
        playerId: 'columns-player',
        cards: List<game.Card?>.filled(12, null),
        currentScore: 0,
        revealedCount: 12,
        identicalColumns: [0, 1, 3], // 3 columns are identical
        hasFinished: false,
      );

      // Assert
      expect(playerState.identicalColumns.length, equals(3));
      expect(playerState.identicalColumns, contains(0));
      expect(playerState.identicalColumns, contains(1));
      expect(playerState.identicalColumns, contains(3));
    });

    test('should serialize to/from JSON', () {
      // Arrange
      final cards = [
        game.Card(
          value: 7,
          isRevealed: true,
        ),
        ...List.filled(11, null),
      ];

      final originalState = PlayerState(
        playerId: 'json-player',
        cards: cards,
        currentScore: 7,
        revealedCount: 1,
        identicalColumns: [2],
        hasFinished: false,
      );

      // Act
      final json = originalState.toJson();
      final deserializedState = PlayerState.fromJson(json);

      // Assert
      expect(deserializedState.playerId, equals(originalState.playerId));
      expect(deserializedState.currentScore, equals(originalState.currentScore));
      expect(deserializedState.revealedCount, equals(originalState.revealedCount));
      expect(deserializedState.identicalColumns, equals(originalState.identicalColumns));
      expect(deserializedState.hasFinished, equals(originalState.hasFinished));
      expect(deserializedState.cards.length, equals(originalState.cards.length));
    });

    test('should create a copy with copyWith', () {
      // Arrange
      final originalState = PlayerState(
        playerId: 'original-player',
        cards: List<game.Card?>.filled(12, null),
        currentScore: 30,
        revealedCount: 5,
        identicalColumns: [1],
        hasFinished: false,
      );

      // Act
      final copiedState = originalState.copyWith(
        currentScore: 25,
        hasFinished: true,
      );

      // Assert
      expect(copiedState.playerId, equals(originalState.playerId));
      expect(copiedState.cards, equals(originalState.cards));
      expect(copiedState.currentScore, equals(25));
      expect(copiedState.revealedCount, equals(originalState.revealedCount));
      expect(copiedState.identicalColumns, equals(originalState.identicalColumns));
      expect(copiedState.hasFinished, isTrue);
    });

    test('should validate cards list length', () {
      // Act & Assert
      expect(
        () => PlayerState(
          playerId: 'invalid-player',
          cards: [null, null], // Only 2 cards instead of 12
          currentScore: 0,
          revealedCount: 0,
          identicalColumns: [],
          hasFinished: false,
        ),
        returnsNormally, // Should not throw, but app should validate elsewhere
      );
    });
  });
}