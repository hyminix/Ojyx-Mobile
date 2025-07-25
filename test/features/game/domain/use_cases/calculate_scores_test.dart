import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/calculate_scores.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  late CalculateScores calculateScores;

  setUp(() {
    calculateScores = CalculateScores();
  });

  group('Competitive Score Calculation for Strategic Game Ranking', () {
    test('should provide comprehensive competitive scoring and ranking system for strategic game conclusion', () async {
      // Test behavior: scoring system determines winners and provides fair competitive rankings based on strategic performance
      
      final competitivePlayerScenarios = [
        // Strategic winner with optimal play
        GamePlayer(
          id: 'strategic-winner-123',
          name: 'Elite Strategic Player',
          grid: PlayerGrid.empty()
              .placeCard(const Card(value: -2, isRevealed: true), 0, 0)  // Bonus points
              .placeCard(const Card(value: -1, isRevealed: true), 0, 1)  // Bonus points
              .placeCard(const Card(value: 0, isRevealed: true), 1, 0),   // Neutral
          isHost: false,
          scoreMultiplier: 1,
        ),
        
        // Average competitive performance
        GamePlayer(
          id: 'competitive-player-456',
          name: 'Tactical Competitor',
          grid: PlayerGrid.empty()
              .placeCard(const Card(value: 5, isRevealed: true), 0, 0)
              .placeCard(const Card(value: 3, isRevealed: true), 0, 1)
              .placeCard(const Card(value: 8, isRevealed: false), 1, 0),  // Hidden card
          isHost: false,
          scoreMultiplier: 1,
        ),
        
        // Host with penalty multiplier
        GamePlayer(
          id: 'penalized-host-789',
          name: 'Tournament Organizer',
          grid: PlayerGrid.empty()
              .placeCard(const Card(value: 6, isRevealed: true), 0, 0)
              .placeCard(const Card(value: 4, isRevealed: true), 0, 1),
          isHost: true,
          scoreMultiplier: 2,  // Double penalty for initiating round
        ),
        
        // Player with mixed revealed/hidden strategy
        GamePlayer(
          id: 'strategic-player-999',
          name: 'Mixed Strategy Player',
          grid: PlayerGrid.empty()
              .placeCard(const Card(value: 10, isRevealed: true), 0, 0)
              .placeCard(const Card(value: -2, isRevealed: true), 0, 1)
              .placeCard(const Card(value: 12, isRevealed: false), 1, 0)  // High hidden value
              .placeCard(const Card(value: 1, isRevealed: false), 1, 1),   // Low hidden value
          isHost: false,
          scoreMultiplier: 1,
        ),
      ];

      final competitiveGameState = GameState.initial(
        roomId: 'tournament-arena-555',
        players: competitivePlayerScenarios,
      );

      // Competitive ranking calculation - revealed cards only (standard endgame)
      final revealedScoresResult = await calculateScores(
        CalculateScoresParams(gameState: competitiveGameState, onlyRevealed: true, sorted: true),
      );

      expect(revealedScoresResult.isRight(), true, reason: 'Scoring calculation should succeed for competitive ranking');
      
      revealedScoresResult.fold(
        (failure) => fail('Competitive scoring should not fail'),
        (rankedScores) {
          final competitiveRanking = rankedScores.entries.toList();
          
          // Strategic winner should rank first (lowest score)
          expect(competitiveRanking[0].key, 'strategic-winner-123', reason: 'Strategic player with bonus cards should win');
          expect(competitiveRanking[0].value, -3, reason: 'Bonus cards should provide competitive advantage');
          
          // Tactical player should rank second
          expect(competitiveRanking[1].key, 'competitive-player-456', reason: 'Moderate performance should rank in middle');
          expect(competitiveRanking[1].value, 8, reason: 'Standard scoring should reflect revealed card values');
          
          // Mixed strategy player should rank third
          expect(competitiveRanking[2].key, 'strategic-player-999', reason: 'Mixed strategy should rank based on revealed cards');
          expect(competitiveRanking[2].value, 8, reason: 'Only revealed cards count for strategic ranking');
          
          // Penalized host should rank last (highest score due to multiplier)
          expect(competitiveRanking[3].key, 'penalized-host-789', reason: 'Host penalty should affect competitive ranking');
          expect(competitiveRanking[3].value, 20, reason: 'Score multiplier should penalize round initiator');
        },
      );

      // Complete scoring calculation - all cards (for detailed analysis)
      final completeScoresResult = await calculateScores(
        CalculateScoresParams(gameState: competitiveGameState, onlyRevealed: false, sorted: false),
      );

      expect(completeScoresResult.isRight(), true, reason: 'Complete scoring should succeed for analysis');
      
      completeScoresResult.fold(
        (failure) => fail('Complete scoring should not fail'),
        (allScores) {
          expect(allScores['strategic-winner-123'], -3, reason: 'Strategic winner maintains advantage with complete scoring');
          expect(allScores['competitive-player-456'], 16, reason: 'Complete scoring includes hidden cards for analysis');
          expect(allScores['strategic-player-999'], 21, reason: 'Hidden high-value cards affect complete analysis');
          expect(allScores['penalized-host-789'], 20, reason: 'Host penalty applies regardless of calculation method');
        },
      );
    });

    group('should handle specialized competitive scoring scenarios', () {
      test('when players achieve negative scores through strategic bonus card collection', () async {
        // Test behavior: negative scores should be properly handled for competitive advantage
        
        final bonusCardMaster = GamePlayer(
          id: 'bonus-specialist-123',
          name: 'Bonus Card Specialist',
          grid: PlayerGrid.empty()
              .placeCard(const Card(value: -2, isRevealed: true), 0, 0)
              .placeCard(const Card(value: -2, isRevealed: true), 0, 1)
              .placeCard(const Card(value: -1, isRevealed: true), 1, 0)
              .placeCard(const Card(value: 3, isRevealed: true), 1, 1),  // One penalty card
          isHost: false,
        );

        final gameState = GameState.initial(roomId: 'bonus-test-room', players: [bonusCardMaster]);
        
        final result = await calculateScores(CalculateScoresParams(gameState: gameState));
        
        expect(result.isRight(), true, reason: 'Negative score calculation should succeed');
        result.fold(
          (failure) => fail('Bonus scoring should not fail'),
          (scores) {
            expect(scores['bonus-specialist-123'], -2, reason: 'Negative scores should provide competitive advantage');
          },
        );
      });

      test('when only revealed cards contribute to competitive final scoring', () async {
        // Test behavior: hidden cards should not affect competitive rankings in standard gameplay
        
        final strategicPlayer = GamePlayer(
          id: 'strategic-revealer-456',
          name: 'Strategic Card Revealer',
          grid: PlayerGrid.empty()
              .placeCard(const Card(value: 10, isRevealed: false), 0, 0)  // Hidden high penalty
              .placeCard(const Card(value: 5, isRevealed: true), 0, 1)    // Revealed moderate
              .placeCard(const Card(value: 8, isRevealed: false), 1, 0)   // Hidden moderate penalty
              .placeCard(const Card(value: 2, isRevealed: true), 1, 1),   // Revealed low
          isHost: false,
        );

        final gameState = GameState.initial(roomId: 'revealed-test-room', players: [strategicPlayer]);
        
        final result = await calculateScores(CalculateScoresParams(gameState: gameState, onlyRevealed: true));
        
        expect(result.isRight(), true, reason: 'Revealed-only scoring should succeed');
        result.fold(
          (failure) => fail('Revealed scoring should not fail'),
          (scores) {
            expect(scores['strategic-revealer-456'], 7, reason: 'Only revealed cards should contribute to competitive score');
          },
        );
      });

      test('when score multipliers apply competitive penalties for round initiation', () async {
        // Test behavior: multipliers should fairly penalize players who trigger final rounds without winning
        
        final competitiveScenarios = [
          GamePlayer(
            id: 'successful-initiator-123',
            name: 'Successful Round Initiator',
            grid: PlayerGrid.empty()
                .placeCard(const Card(value: 3, isRevealed: true), 0, 0)
                .placeCard(const Card(value: 2, isRevealed: true), 0, 1),
            isHost: false,
            scoreMultiplier: 1,  // No penalty for successful strategy
          ),
          GamePlayer(
            id: 'failed-initiator-456',
            name: 'Failed Round Initiator',
            grid: PlayerGrid.empty()
                .placeCard(const Card(value: 3, isRevealed: true), 0, 0)
                .placeCard(const Card(value: 2, isRevealed: true), 0, 1),
            isHost: false,
            scoreMultiplier: 2,  // Double penalty for failed strategy
          ),
        ];

        final gameState = GameState.initial(roomId: 'multiplier-test-room', players: competitiveScenarios);
        
        final result = await calculateScores(CalculateScoresParams(gameState: gameState));
        
        expect(result.isRight(), true, reason: 'Multiplier scoring should succeed');
        result.fold(
          (failure) => fail('Multiplier scoring should not fail'),
          (scores) {
            expect(scores['successful-initiator-123'], 5, reason: 'Successful initiator should receive standard scoring');
            expect(scores['failed-initiator-456'], 10, reason: 'Failed initiator should receive penalty multiplier');
          },
        );
      });
    });

    test('should provide sorted competitive rankings for tournament organization and winner determination', () async {
      // Test behavior: ranking system should organize players from best to worst performance for competitive clarity
      
      final tournamentPlayers = [
        GamePlayer(
          id: 'third-place-789',
          name: 'Bronze Medal Player',
          grid: PlayerGrid.empty().placeCard(const Card(value: 10, isRevealed: true), 0, 0),
          isHost: false,
        ),
        GamePlayer(
          id: 'champion-123',
          name: 'Gold Medal Winner',
          grid: PlayerGrid.empty().placeCard(const Card(value: 3, isRevealed: true), 0, 0),
          isHost: false,
        ),
        GamePlayer(
          id: 'runner-up-456',
          name: 'Silver Medal Player',
          grid: PlayerGrid.empty().placeCard(const Card(value: 7, isRevealed: true), 0, 0),
          isHost: false,
        ),
      ];

      final tournamentGameState = GameState.initial(roomId: 'tournament-finals', players: tournamentPlayers);
      
      final result = await calculateScores(CalculateScoresParams(gameState: tournamentGameState, sorted: true));
      
      expect(result.isRight(), true, reason: 'Tournament ranking should succeed');
      result.fold(
        (failure) => fail('Tournament ranking should not fail'),
        (tournamentRanking) {
          final rankedResults = tournamentRanking.entries.toList();
          
          expect(rankedResults[0].key, 'champion-123', reason: 'Lowest score should achieve first place');
          expect(rankedResults[0].value, 3, reason: 'Champion should have best competitive score');
          
          expect(rankedResults[1].key, 'runner-up-456', reason: 'Second lowest score should achieve second place');
          expect(rankedResults[1].value, 7, reason: 'Runner-up should have intermediate competitive score');
          
          expect(rankedResults[2].key, 'third-place-789', reason: 'Highest score should achieve last place');
          expect(rankedResults[2].value, 10, reason: 'Third place should have highest competitive score');
        },
      );
    });
  });
}