import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/use_cases/game_initialization_use_case.dart';

part 'game_state_notifier.g.dart';

@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  GameState? build() {
    return null;
  }
  
  void loadState(GameState state) {
    this.state = state;
  }
  
  void updateState(GameState Function(GameState) update) {
    final currentState = state;
    if (currentState != null) {
      state = update(currentState);
    }
  }
  
  void drawFromDeck(String playerId) {
    // TODO: Implement draw from deck logic
  }
  
  void drawFromDiscard(String playerId) {
    // TODO: Implement draw from discard logic
  }
  
  void discardCard(String playerId, int cardIndex) {
    // TODO: Implement discard card logic
  }
  
  void revealCard(String playerId, int position) {
    // TODO: Implement reveal card logic
  }
  
  void endTurn() {
    // TODO: Implement end turn logic
  }
}

@riverpod
GameInitializationUseCase gameInitializationUseCase(GameInitializationUseCaseRef ref) {
  return GameInitializationUseCase();
}