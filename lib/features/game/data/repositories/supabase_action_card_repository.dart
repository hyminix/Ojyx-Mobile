import '../../domain/entities/action_card.dart';
import '../../domain/repositories/action_card_repository.dart';
import '../datasources/supabase_action_card_datasource.dart';

class SupabaseActionCardRepository implements ActionCardRepository {
  final SupabaseActionCardDataSource _dataSource;

  SupabaseActionCardRepository(this._dataSource);

  @override
  Future<List<ActionCard>> getAvailableActionCards() {
    return _dataSource.getAvailableActionCards();
  }

  @override
  Future<List<ActionCard>> getPlayerActionCards(String playerId) {
    return _dataSource.getPlayerActionCards(playerId);
  }

  @override
  Future<void> addActionCardToPlayer(String playerId, ActionCard card) {
    return _dataSource.addActionCardToPlayer(playerId, card);
  }

  @override
  Future<void> removeActionCardFromPlayer(String playerId, ActionCard card) {
    return _dataSource.removeActionCardFromPlayer(playerId, card);
  }

  @override
  Future<ActionCard?> drawActionCard() {
    return _dataSource.drawActionCard();
  }

  @override
  Future<void> discardActionCard(ActionCard card) {
    return _dataSource.discardActionCard(card);
  }

  @override
  Future<void> shuffleActionCards() {
    return _dataSource.shuffleActionCards();
  }

  /// Initialize or reset the deck
  Future<void> initializeDeck() {
    return _dataSource.initializeDeck();
  }
}