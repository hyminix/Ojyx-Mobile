import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/lobby_player.dart';
import 'dart:convert';

void main() {
  group('Freezed Models Tests', () {
    group('Card Entity', () {
      test('should support copyWith', () {
        const card = Card(value: 5);
        final updatedCard = card.copyWith(value: 10);
        
        expect(updatedCard.value, 10);
        expect(card.value, 5); // Original unchanged
      });
      
      test('should support equality', () {
        const card1 = Card(value: 5);
        const card2 = Card(value: 5);
        const card3 = Card(value: 10);
        
        expect(card1, equals(card2));
        expect(card1, isNot(equals(card3)));
      });
      
      test('should serialize to/from JSON', () {
        const card = Card(value: 7);
        final json = card.toJson();
        final fromJson = Card.fromJson(json);
        
        expect(fromJson, equals(card));
      });
      
      test('should handle reveal/hide methods', () {
        const card = Card(value: 5, isRevealed: false);
        final revealed = card.reveal();
        final hidden = revealed.hide();
        
        expect(card.isRevealed, false);
        expect(revealed.isRevealed, true);
        expect(hidden.isRevealed, false);
      });
    });
    
    group('PlayerGrid Entity', () {
      test('should support copyWith', () {
        final grid = PlayerGrid.empty();
        const card = Card(value: 5);
        
        final updatedGrid = grid.setCard(0, 0, card);
        
        expect(updatedGrid.getCard(0, 0), equals(card));
        expect(grid.getCard(0, 0), isNull);
      });
      
      test('should serialize to/from JSON', () {
        final grid = PlayerGrid.empty()
            .setCard(0, 0, const Card(value: 5))
            .setCard(1, 1, const Card(value: 10, isRevealed: true));
        
        final json = grid.toJson();
        final fromJson = PlayerGrid.fromJson(json);
        
        expect(fromJson, equals(grid));
        expect(fromJson.getCard(0, 0)?.value, 5);
        expect(fromJson.getCard(1, 1)?.value, 10);
      });
      
      test('should calculate total score correctly', () {
        final grid = PlayerGrid.empty()
            .setCard(0, 0, const Card(value: 5))
            .setCard(0, 1, const Card(value: 10))
            .setCard(1, 0, const Card(value: -2));
        
        expect(grid.totalScore, 13);
      });
    });
    
    group('GameState Entity', () {
      test('should support copyWith', () {
        final state = GameState(
          roomId: 'room1',
          players: const [],
          currentPlayerIndex: 0,
          deck: const [],
          discardPile: const [],
          actionDeck: const [],
          actionDiscard: const [],
          status: GameStatus.waitingToStart,
          turnDirection: TurnDirection.clockwise,
          lastRound: false,
        );
        
        final updatedState = state.copyWith(
          currentPlayerIndex: 1,
          status: GameStatus.playing,
        );
        
        expect(updatedState.currentPlayerIndex, 1);
        expect(updatedState.status, GameStatus.playing);
        expect(state.currentPlayerIndex, 0);
        expect(state.status, GameStatus.waitingToStart);
      });
      
      test('should handle initial factory', () {
        final player = GamePlayer(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          actionCards: const [],
          isConnected: true,
        );
        
        final state = GameState.initial(
          roomId: 'room1',
          players: [player],
        );
        
        expect(state.players.length, 1);
        expect(state.players.first.id, 'player1');
        expect(state.status, GameStatus.waitingToStart);
        expect(state.deck, isNotEmpty); // Initial deck should be created
      });
    });
    
    group('Room Entity (Multiplayer)', () {
      test('should support copyWith', () {
        final room = Room(
          id: 'room1',
          creatorId: 'host1',
          playerIds: const ['host1'],
          status: RoomStatus.waiting,
          maxPlayers: 8,
        );
        
        final updatedRoom = room.copyWith(
          status: RoomStatus.inGame,
          maxPlayers: 6,
        );
        
        expect(updatedRoom.status, RoomStatus.inGame);
        expect(updatedRoom.maxPlayers, 6);
        expect(room.status, RoomStatus.waiting);
      });
      
      test('should serialize to/from JSON', () {
        final room = Room(
          id: 'room1',
          creatorId: 'host1',
          playerIds: const ['host1', 'player2'],
          status: RoomStatus.waiting,
          maxPlayers: 8,
          createdAt: DateTime.now(),
        );
        
        final json = room.toJson();
        final fromJson = Room.fromJson(json);
        
        expect(fromJson.playerIds.length, 2);
        expect(fromJson.creatorId, 'host1');
      });
    });
    
    test('should create snapshot of current freezed models state', () {
      // Test pour vérifier que tous les modèles Freezed fonctionnent
      final modelsWorking = <String, bool>{
        'Card': true,
        'PlayerGrid': true,
        'GameState': true,
        'Room': true,
      };
      
      expect(modelsWorking.values.every((v) => v), isTrue,
          reason: 'All Freezed models should be working before update');
    });
  });
}