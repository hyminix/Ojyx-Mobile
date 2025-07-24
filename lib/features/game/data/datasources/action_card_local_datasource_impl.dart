import 'dart:math' as math;
import '../../../../core/utils/constants.dart';
import '../../domain/entities/action_card.dart';
import 'action_card_local_datasource.dart';

class ActionCardLocalDataSourceImpl implements ActionCardLocalDataSource {
  final List<ActionCard> _drawPile = [];
  final Map<String, List<ActionCard>> _playerCards = {};
  final _random = math.Random();

  ActionCardLocalDataSourceImpl() {
    initializeDeck();
  }

  @override
  void initializeDeck() {
    _drawPile.clear();

    // Create a balanced deck of action cards
    final actionCardTypes = [
      // Movement cards
      (
        ActionCardType.teleport,
        'Téléportation',
        'Échangez deux cartes de votre grille',
        ActionTiming.optional,
        ActionTarget.self,
        4,
      ),
      (
        ActionCardType.swap,
        'Échange',
        'Échangez une carte avec un adversaire',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        3,
      ),

      // Turn manipulation
      (
        ActionCardType.turnAround,
        'Demi-tour',
        'Inversez le sens du jeu',
        ActionTiming.immediate,
        ActionTarget.none,
        3,
      ),
      (
        ActionCardType.skip,
        'Saut',
        'Le prochain joueur passe son tour',
        ActionTiming.optional,
        ActionTarget.none,
        4,
      ),

      // Information cards
      (
        ActionCardType.peek,
        'Coup d\'œil',
        'Regardez une carte adverse',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        4,
      ),
      (
        ActionCardType.reveal,
        'Révélation',
        'Révélez une carte à tous',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        2,
      ),

      // Protection cards
      (
        ActionCardType.shield,
        'Bouclier',
        'Protégez-vous des attaques ce tour',
        ActionTiming.reactive,
        ActionTarget.self,
        3,
      ),

      // Attack cards
      (
        ActionCardType.steal,
        'Vol',
        'Volez une carte action à un adversaire',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        2,
      ),
      (
        ActionCardType.curse,
        'Malédiction',
        'Doublez le score d\'une colonne adverse',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        2,
      ),

      // Utility cards
      (
        ActionCardType.draw,
        'Pioche',
        'Piochez 2 cartes actions',
        ActionTiming.optional,
        ActionTarget.deck,
        3,
      ),
      (
        ActionCardType.shuffle,
        'Mélange',
        'Mélangez votre grille',
        ActionTiming.optional,
        ActionTarget.self,
        2,
      ),
      (
        ActionCardType.heal,
        'Soin',
        'Divisez par 2 le score d\'une colonne',
        ActionTiming.optional,
        ActionTarget.self,
        2,
      ),
    ];

    // Generate cards based on distribution
    var idCounter = 1;
    for (final (type, name, description, timing, target, count)
        in actionCardTypes) {
      for (int i = 0; i < count; i++) {
        _drawPile.add(
          ActionCard(
            id: 'action-${idCounter++}',
            type: type,
            name: name,
            description: description,
            timing: timing,
            target: target,
          ),
        );
      }
    }

    // Initial shuffle
    shuffleActionCards();
  }

  @override
  List<ActionCard> getAvailableActionCards() {
    return List.unmodifiable(_drawPile);
  }

  @override
  List<ActionCard> getPlayerActionCards(String playerId) {
    return List.unmodifiable(_playerCards[playerId] ?? []);
  }

  @override
  void addActionCardToPlayer(String playerId, ActionCard card) {
    _playerCards.putIfAbsent(playerId, () => []);
    final playerCards = _playerCards[playerId]!;

    if (playerCards.length >= kMaxActionCardsInHand) {
      throw Exception(
        'GamePlayer cannot have more than $kMaxActionCardsInHand action cards',
      );
    }

    playerCards.add(card);
  }

  @override
  void removeActionCardFromPlayer(String playerId, ActionCard card) {
    final playerCards = _playerCards[playerId];
    if (playerCards == null || !playerCards.contains(card)) {
      throw Exception('GamePlayer does not have this action card');
    }

    playerCards.remove(card);
  }

  @override
  ActionCard? drawActionCard() {
    if (_drawPile.isEmpty) {
      return null;
    }

    return _drawPile.removeAt(0);
  }

  @override
  void discardActionCard(ActionCard card) {
    // Add the card back to the bottom of the draw pile
    _drawPile.add(card);
  }

  @override
  void shuffleActionCards() {
    _drawPile.shuffle(_random);
  }
}
