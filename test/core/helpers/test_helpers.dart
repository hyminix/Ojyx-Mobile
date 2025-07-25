/// Legacy test helpers - consider migrating to the new helpers in /test/helpers/
/// 
/// For new tests, prefer using:
/// - /test/helpers/test_builders.dart for entity creation
/// - /test/helpers/test_matchers.dart for assertions
/// - /test/helpers/test_scenarios.dart for common scenarios
/// - /test/helpers/index.dart for convenient single import

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';
import 'package:ojyx/features/game/data/repositories/supabase_game_state_repository.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/game/presentation/providers/repository_providers.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as domain;
import 'package:ojyx/features/game/domain/entities/action_card.dart';

// Mock classes
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGameStateRepository extends Mock implements GameStateRepository {}

class MockFunctionResponse extends Mock implements FunctionResponse {}

// Test overrides
List<Override> getTestOverrides({
  SupabaseClient? supabaseClient,
  GameStateRepository? gameStateRepository,
}) {
  final mockSupabase = supabaseClient ?? MockSupabaseClient();
  final mockRepository = gameStateRepository ?? MockGameStateRepository();

  return [
    supabaseClientProvider.overrideWithValue(mockSupabase),
    gameStateRepositoryProvider.overrideWithValue(mockRepository),
  ];
}

// Helper to create test game state
GameState createTestGameState({
  String? roomId,
  List<GamePlayer>? players,
  List<domain.Card>? deck,
  List<domain.Card>? discardPile,
  int? currentPlayerIndex,
  TurnDirection? turnDirection,
  bool? lastRound,
  String? initiatorPlayerId,
  GameStatus? status,
}) {
  return GameState(
    roomId: roomId ?? 'test-room-id',
    players:
        players ??
        [
          createTestPlayer(id: 'player1', name: 'Player 1'),
          createTestPlayer(id: 'player2', name: 'Player 2'),
        ],
    deck:
        deck ??
        List.generate(
          100,
          (i) => domain.Card(value: i % 13 - 2, isRevealed: false),
        ),
    discardPile: discardPile ?? [domain.Card(value: 5, isRevealed: true)],
    currentPlayerIndex: currentPlayerIndex ?? 0,
    turnDirection: turnDirection ?? TurnDirection.clockwise,
    lastRound: lastRound ?? false,
    initiatorPlayerId: initiatorPlayerId,
    status: status ?? GameStatus.playing,
    actionDeck: [],
    actionDiscard: [],
  );
}

// Helper to create test player
GamePlayer createTestPlayer({
  required String id,
  required String name,
  PlayerGrid? grid,
  List<ActionCard>? actionCards,
  bool? isConnected,
  bool? isHost,
  bool? hasFinishedRound,
  int? scoreMultiplier,
}) {
  return GamePlayer(
    id: id,
    name: name,
    grid:
        grid ??
        PlayerGrid.fromCards(
          List.generate(
            12,
            (i) => domain.Card(value: i % 13 - 2, isRevealed: i < 2),
          ),
        ),
    actionCards: actionCards ?? [],
    isConnected: isConnected ?? true,
    isHost: isHost ?? false,
    hasFinishedRound: hasFinishedRound ?? false,
    scoreMultiplier: scoreMultiplier ?? 1,
  );
}

// Setup function for tests that need initialized repositories
void setupRepositoryStubs(MockGameStateRepository mockRepository) {
  when(
    () => mockRepository.initializeGame(
      roomId: any(named: 'roomId'),
      playerIds: any(named: 'playerIds'),
      creatorId: any(named: 'creatorId'),
    ),
  ).thenAnswer((_) async => createTestGameState());

  when(
    () => mockRepository.getGameState(any()),
  ).thenAnswer((_) async => createTestGameState());

  when(
    () => mockRepository.watchGameState(any()),
  ).thenAnswer((_) => Stream.value(createTestGameState()));
}
