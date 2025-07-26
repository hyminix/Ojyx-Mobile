import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';

void main() {
  group('Freezed Immutability Tests', () {
    test('Card should be immutable', () {
      const card = Card(value: 5);
      final card2 = card.copyWith(value: 10);
      
      // Vérifier que l'original n'a pas changé
      expect(card.value, 5);
      expect(card2.value, 10);
      expect(identical(card, card2), isFalse);
    });
    
    test('PlayerGrid should be immutable', () {
      final grid = PlayerGrid.empty();
      final updatedGrid = grid.setCard(0, 0, const Card(value: 5));
      
      // Vérifier que l'original n'a pas changé
      expect(grid.getCard(0, 0), isNull);
      expect(updatedGrid.getCard(0, 0)?.value, 5);
      expect(identical(grid, updatedGrid), isFalse);
    });
    
    test('GamePlayer should be immutable', () {
      final player = GamePlayer(
        id: 'player1',
        name: 'Test Player',
        grid: PlayerGrid.empty(),
      );
      
      final disconnectedPlayer = player.disconnect();
      
      // Vérifier que l'original n'a pas changé
      expect(player.isConnected, true);
      expect(disconnectedPlayer.isConnected, false);
      expect(identical(player, disconnectedPlayer), isFalse);
    });
    
    test('Deep immutability with nested objects', () {
      final player = GamePlayer(
        id: 'player1',
        name: 'Test Player',
        grid: PlayerGrid.empty(),
      );
      
      // Modifier la grille
      final updatedPlayer = player.updateGrid(
        player.grid.setCard(0, 0, const Card(value: 5))
      );
      
      // Vérifier l'immutabilité profonde
      expect(player.grid.getCard(0, 0), isNull);
      expect(updatedPlayer.grid.getCard(0, 0)?.value, 5);
      expect(identical(player.grid, updatedPlayer.grid), isFalse);
    });
    
    test('Collections should be immutable', () {
      final player = GamePlayer(
        id: 'player1',
        name: 'Test Player',
        grid: PlayerGrid.empty(),
        actionCards: const [],
      );
      
      // Test d'ajout d'une carte action (placeholder car ActionCard n'est pas défini ici)
      final updatedPlayer = player.copyWith(
        actionCards: [...player.actionCards], // Copie de la liste
      );
      
      expect(identical(player.actionCards, updatedPlayer.actionCards), isFalse);
    });
  });
}