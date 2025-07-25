import '../../domain/entities/action_card.dart';
import '../../domain/repositories/action_card_repository.dart';
import '../datasources/action_card_local_datasource.dart';

class ActionCardRepositoryImpl implements ActionCardRepository {
  final ActionCardLocalDataSource _localDataSource;

  ActionCardRepositoryImpl(this._localDataSource);

  @override
  Future<List<ActionCard>> getAvailableActionCards() {
    return _localDataSource.getAvailableActionCards();
  }

  @override
  Future<List<ActionCard>> getPlayerActionCards(String playerId) {
    return _localDataSource.getPlayerActionCards(playerId);
  }

  @override
  Future<void> addActionCardToPlayer(String playerId, ActionCard card) {
    return _localDataSource.addActionCardToPlayer(playerId, card);
  }

  @override
  Future<void> removeActionCardFromPlayer(String playerId, ActionCard card) {
    return _localDataSource.removeActionCardFromPlayer(playerId, card);
  }

  @override
  Future<ActionCard?> drawActionCard() {
    return _localDataSource.drawActionCard();
  }

  @override
  Future<void> discardActionCard(ActionCard card) {
    return _localDataSource.discardActionCard(card);
  }

  @override
  Future<void> shuffleActionCards() {
    return _localDataSource.shuffleActionCards();
  }
}
