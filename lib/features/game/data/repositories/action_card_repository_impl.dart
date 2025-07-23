import '../../domain/entities/action_card.dart';
import '../../domain/repositories/action_card_repository.dart';
import '../datasources/action_card_local_datasource.dart';

class ActionCardRepositoryImpl implements ActionCardRepository {
  final ActionCardLocalDataSource _localDataSource;
  
  ActionCardRepositoryImpl(this._localDataSource);
  
  @override
  List<ActionCard> getAvailableActionCards() {
    return _localDataSource.getAvailableActionCards();
  }
  
  @override
  List<ActionCard> getPlayerActionCards(String playerId) {
    return _localDataSource.getPlayerActionCards(playerId);
  }
  
  @override
  void addActionCardToPlayer(String playerId, ActionCard card) {
    _localDataSource.addActionCardToPlayer(playerId, card);
  }
  
  @override
  void removeActionCardFromPlayer(String playerId, ActionCard card) {
    _localDataSource.removeActionCardFromPlayer(playerId, card);
  }
  
  @override
  ActionCard? drawActionCard() {
    return _localDataSource.drawActionCard();
  }
  
  @override
  void discardActionCard(ActionCard card) {
    _localDataSource.discardActionCard(card);
  }
  
  @override
  void shuffleActionCards() {
    _localDataSource.shuffleActionCards();
  }
}