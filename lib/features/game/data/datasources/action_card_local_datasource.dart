import '../../domain/entities/action_card.dart';

abstract class ActionCardLocalDataSource {
  /// Get all available action cards in the draw pile
  List<ActionCard> getAvailableActionCards();

  /// Get action cards held by a specific player
  List<ActionCard> getPlayerActionCards(String playerId);

  /// Add an action card to a player's hand
  /// Throws exception if player already has 3 cards
  void addActionCardToPlayer(String playerId, ActionCard card);

  /// Remove an action card from a player's hand
  /// Throws exception if player doesn't have the card
  void removeActionCardFromPlayer(String playerId, ActionCard card);

  /// Draw an action card from the pile
  /// Returns null if pile is empty
  ActionCard? drawActionCard();

  /// Discard an action card back to the pile
  void discardActionCard(ActionCard card);

  /// Shuffle the action card pile
  void shuffleActionCards();
}
