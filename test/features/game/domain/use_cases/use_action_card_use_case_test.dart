import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';

class MockGameStateRepository extends Mock implements GameStateRepository {}

void main() {
  late UseActionCardUseCase useCase;
  late MockGameStateRepository mockRepository;

  setUp(() {
    mockRepository = MockGameStateRepository();
    useCase = UseActionCardUseCase(mockRepository);
  });

  group('UseActionCardUseCase', () {
    test(
      'should enable strategic action card usage for competitive gameplay disruption',
      () async {
        // Test behavior: Action cards create strategic disruptions that affect game flow,
        // player turns, and competitive dynamics

        final actionCardScenarios = [
          // Scenario 1: Skip card disrupts opponent's turn
          {
            'description': 'skip opponent turn for strategic advantage',
            'gameStateId': 'competitive-match-123',
            'playerId': 'strategic-player-456',
            'actionCardType': ActionCardType.skip,
            'targetData': null,
            'mockResponse': {
              'valid': true,
              'gameState': {
                'currentPlayerIndex': 2, // Skips to player after target
                'skippedPlayerId': 'opponent-789',
                'nextPlayerId': 'ally-012',
                'turnFlow': 'disrupted',
              },
            },
            'expectedBehavior': (Map<String, dynamic> response) {
              expect(
                response['valid'],
                true,
                reason: 'Skip card should successfully disrupt turn order',
              );
              expect(
                response['gameState']['turnFlow'],
                'disrupted',
                reason: 'Turn flow should be strategically disrupted',
              );
              expect(
                response['gameState']['skippedPlayerId'],
                'opponent-789',
                reason: 'Target opponent should lose their turn',
              );
            },
          },

          // Scenario 2: Turn around reverses game direction
          {
            'description': 'reverse turn direction for tactical repositioning',
            'gameStateId': 'tournament-arena-456',
            'playerId': 'tactician-789',
            'actionCardType': ActionCardType.turnAround,
            'targetData': null,
            'mockResponse': {
              'valid': true,
              'gameState': {
                'turnDirection': 'counterClockwise',
                'previousDirection': 'clockwise',
                'playersAffected': ['player1', 'player2', 'player3', 'player4'],
                'strategicImpact': 'high',
              },
            },
            'expectedBehavior': (Map<String, dynamic> response) {
              expect(
                response['gameState']['turnDirection'],
                'counterClockwise',
                reason: 'Direction should reverse for tactical advantage',
              );
              expect(
                response['gameState']['strategicImpact'],
                'high',
                reason: 'Turn reversal has high strategic impact',
              );
            },
          },

          // Scenario 3: Teleportation swaps strategic positions
          {
            'description': 'teleport cards between strategic positions',
            'gameStateId': 'strategic-game-789',
            'playerId': 'master-player-012',
            'actionCardType': ActionCardType.teleport,
            'targetData': {
              'position1': {'row': 0, 'col': 0, 'value': 12}, // High card
              'position2': {'row': 2, 'col': 3, 'value': -2}, // Bonus card
            },
            'mockResponse': {
              'valid': true,
              'gameState': {
                'cards_swapped': true,
                'strategic_value': 'optimal',
                'score_impact': -14, // Significant improvement
              },
            },
            'expectedBehavior': (Map<String, dynamic> response) {
              expect(
                response['gameState']['cards_swapped'],
                true,
                reason: 'Cards should swap for strategic repositioning',
              );
              expect(
                response['gameState']['strategic_value'],
                'optimal',
                reason: 'Swap should create optimal positioning',
              );
              expect(
                response['gameState']['score_impact'] < 0,
                true,
                reason: 'Strategic swap should improve score',
              );
            },
          },

          // Scenario 4: Shield reaction blocks opponent action
          {
            'description': 'shield blocks incoming attack action',
            'gameStateId': 'defensive-match-345',
            'playerId': 'defender-678',
            'actionCardType': ActionCardType.shield,
            'targetData': {'blocking': 'freeze_attempt'},
            'mockResponse': {
              'valid': true,
              'gameState': {
                'shield_activated': true,
                'blocked_action': 'freeze',
                'defensive_play': 'successful',
                'turn_preserved': true,
              },
            },
            'expectedBehavior': (Map<String, dynamic> response) {
              expect(
                response['gameState']['shield_activated'],
                true,
                reason: 'Shield should activate as defensive reaction',
              );
              expect(
                response['gameState']['turn_preserved'],
                true,
                reason: 'Shield should preserve player agency',
              );
            },
          },
        ];

        // Execute action card scenarios
        for (final scenario in actionCardScenarios) {
          when(
            () => mockRepository.useActionCard(
              gameStateId: scenario['gameStateId'] as String,
              playerId: scenario['playerId'] as String,
              actionCardType: scenario['actionCardType'] as ActionCardType,
              targetData: scenario['targetData'] as Map<String, dynamic>?,
            ),
          ).thenAnswer(
            (_) async => scenario['mockResponse'] as Map<String, dynamic>,
          );

          final result = await useCase(
            UseActionCardParams(
              gameStateId: scenario['gameStateId'] as String,
              playerId: scenario['playerId'] as String,
              actionCardType: scenario['actionCardType'] as ActionCardType,
              targetData: scenario['targetData'] as Map<String, dynamic>?,
            ),
          );

          expect(
            result.isRight(),
            true,
            reason: 'Scenario "${scenario['description']}" should succeed',
          );

          result.fold(
            (failure) =>
                fail('Should not fail for "${scenario['description']}"'),
            (response) => (scenario['expectedBehavior'] as Function)(response),
          );
        }

        // Validation scenarios - improper usage
        final validationScenarios = [
          {
            'description': 'card not in player hand',
            'gameStateId': 'invalid-game-111',
            'playerId': 'cheater-999',
            'actionCardType': ActionCardType.freeze,
            'targetData': {'target': 'opponent-123'},
            'mockResponse': {
              'valid': false,
              'error': 'action card not available',
              'reason': 'player does not possess this card',
            },
          },
          {
            'description': 'not player turn for non-reaction card',
            'gameStateId': 'turn-order-222',
            'playerId': 'impatient-888',
            'actionCardType': ActionCardType.skip,
            'targetData': null,
            'mockResponse': {
              'valid': false,
              'error': 'not your turn',
              'reason': 'skip requires active turn',
            },
          },
          {
            'description': 'missing required target data',
            'gameStateId': 'incomplete-333',
            'playerId': 'careless-777',
            'actionCardType': ActionCardType.teleport,
            'targetData': null,
            'mockResponse': {
              'valid': false,
              'error': 'invalid positions',
              'reason': 'teleport requires two positions',
            },
          },
        ];

        for (final validation in validationScenarios) {
          when(
            () => mockRepository.useActionCard(
              gameStateId: validation['gameStateId'] as String,
              playerId: validation['playerId'] as String,
              actionCardType: validation['actionCardType'] as ActionCardType,
              targetData: validation['targetData'] as Map<String, dynamic>?,
            ),
          ).thenAnswer(
            (_) async => validation['mockResponse'] as Map<String, dynamic>,
          );

          final result = await useCase(
            UseActionCardParams(
              gameStateId: validation['gameStateId'] as String,
              playerId: validation['playerId'] as String,
              actionCardType: validation['actionCardType'] as ActionCardType,
              targetData: validation['targetData'] as Map<String, dynamic>?,
            ),
          );

          expect(
            result.isLeft(),
            true,
            reason: 'Validation "${validation['description']}" should fail',
          );

          result.fold((failure) {
            expect(
              failure.message,
              contains((validation['mockResponse'] as Map)['error']),
              reason:
                  'Should fail with appropriate error for ${validation['description']}',
            );
          }, (_) => fail('Should not succeed for ${validation['description']}'));
        }
      },
    );
  });
}
