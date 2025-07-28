import 'dart:math';

/// Génère une grille initiale de 12 cartes pour un joueur d'Ojyx
class GridGenerator {
  static const int gridSize = 12;
  static const int columns = 4;
  static const int rows = 3;

  /// Distribution des cartes selon les règles d'Ojyx
  static const Map<int, int> cardDistribution = {
    -2: 5,  // 5 cartes de valeur -2
    -1: 10, // 10 cartes de valeur -1
    0: 15,  // 15 cartes de valeur 0
    1: 10,  // 10 cartes de valeur 1
    2: 10,  // 10 cartes de valeur 2
    3: 10,  // 10 cartes de valeur 3
    4: 10,  // 10 cartes de valeur 4
    5: 10,  // 10 cartes de valeur 5
    6: 10,  // 10 cartes de valeur 6
    7: 10,  // 10 cartes de valeur 7
    8: 10,  // 10 cartes de valeur 8
    9: 10,  // 10 cartes de valeur 9
    10: 10, // 10 cartes de valeur 10
    11: 10, // 10 cartes de valeur 11
    12: 10, // 10 cartes de valeur 12
  };

  /// Génère une grille initiale avec 12 cartes face cachée
  /// Retourne une structure JSON compatible avec la colonne grid_cards de player_grids
  static List<Map<String, dynamic>> generateInitialGrid({int? seed}) {
    final random = seed != null ? Random(seed) : Random();
    
    // Créer le deck complet
    final List<int> deck = [];
    cardDistribution.forEach((value, count) {
      for (int i = 0; i < count; i++) {
        deck.add(value);
      }
    });
    
    // Mélanger le deck
    deck.shuffle(random);
    
    // Prendre les 12 premières cartes
    final List<Map<String, dynamic>> grid = [];
    
    for (int position = 0; position < gridSize; position++) {
      final cardValue = deck[position];
      
      grid.add({
        'position': position,
        'value': cardValue,
        'isRevealed': false,
        'isDiscarded': false,
        'row': position ~/ columns,
        'column': position % columns,
      });
    }
    
    return grid;
  }

  /// Vérifie si une colonne contient 3 cartes identiques révélées
  static bool isColumnValid(List<Map<String, dynamic>> grid, int column) {
    final columnCards = grid
        .where((card) => 
            card['column'] == column && 
            card['isRevealed'] == true && 
            card['isDiscarded'] == false)
        .toList();
    
    if (columnCards.length != 3) return false;
    
    final firstValue = columnCards[0]['value'];
    return columnCards.every((card) => card['value'] == firstValue);
  }

  /// Marque une colonne comme défaussée
  static List<Map<String, dynamic>> discardColumn(
      List<Map<String, dynamic>> grid, int column) {
    return grid.map((card) {
      if (card['column'] == column && card['isRevealed'] == true) {
        return {...card, 'isDiscarded': true};
      }
      return card;
    }).toList();
  }

  /// Compte le nombre de cartes révélées dans la grille
  static int countRevealedCards(List<Map<String, dynamic>> grid) {
    return grid.where((card) => card['isRevealed'] == true).length;
  }

  /// Vérifie si toutes les cartes sont révélées
  static bool areAllCardsRevealed(List<Map<String, dynamic>> grid) {
    return countRevealedCards(grid) == gridSize;
  }

  /// Calcule le score total de la grille
  static int calculateScore(List<Map<String, dynamic>> grid) {
    return grid
        .where((card) => card['isDiscarded'] == false)
        .fold(0, (sum, card) => sum + (card['value'] as int));
  }
}
