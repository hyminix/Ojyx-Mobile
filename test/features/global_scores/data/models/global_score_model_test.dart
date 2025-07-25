import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/data/models/global_score_model.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';

void main() {
  group('GlobalScoreModel', () {
    late DateTime testDateTime;
    late GlobalScoreModel testModel;
    late Map<String, dynamic> testJson;

    setUp(() {
      testDateTime = DateTime(2024, 1, 1, 12, 0, 0);

      testModel = GlobalScoreModel(
        id: 'score123',
        playerId: 'player123',
        playerName: 'Test Player',
        roomId: 'room123',
        totalScore: 42,
        roundNumber: 3,
        position: 1,
        isWinner: true,
        createdAt: testDateTime,
        gameEndedAt: testDateTime.add(const Duration(hours: 1)),
      );

      testJson = {
        'id': 'score123',
        'player_id': 'player123',
        'player_name': 'Test Player',
        'room_id': 'room123',
        'total_score': 42,
        'round_number': 3,
        'position': 1,
        'is_winner': true,
        'created_at': testDateTime.toIso8601String(),
        'game_ended_at': testDateTime
            .add(const Duration(hours: 1))
            .toIso8601String(),
      };
    });

    group('fromJson', () {
      test('should create model from JSON with all fields', () {
        final model = GlobalScoreModel.fromJson(testJson);

        expect(model.id, 'score123');
        expect(model.playerId, 'player123');
        expect(model.playerName, 'Test Player');
        expect(model.roomId, 'room123');
        expect(model.totalScore, 42);
        expect(model.roundNumber, 3);
        expect(model.position, 1);
        expect(model.isWinner, isTrue);
        expect(model.createdAt, testDateTime);
        expect(model.gameEndedAt, testDateTime.add(const Duration(hours: 1)));
      });

      test('should handle null gameEndedAt', () {
        final jsonWithoutEndedAt = Map<String, dynamic>.from(testJson)
          ..remove('game_ended_at');

        final model = GlobalScoreModel.fromJson(jsonWithoutEndedAt);

        expect(model.gameEndedAt, isNull);
        expect(model.id, 'score123');
      });

      test('should handle boolean values correctly', () {
        final jsonFalseWinner = Map<String, dynamic>.from(testJson)
          ..['is_winner'] = false;

        final model = GlobalScoreModel.fromJson(jsonFalseWinner);

        expect(model.isWinner, isFalse);
      });
    });

    group('toJson', () {
      test('should convert model to JSON with all fields', () {
        final json = testModel.toJson();

        expect(json['id'], 'score123');
        expect(json['player_id'], 'player123');
        expect(json['player_name'], 'Test Player');
        expect(json['room_id'], 'room123');
        expect(json['total_score'], 42);
        expect(json['round_number'], 3);
        expect(json['position'], 1);
        expect(json['is_winner'], isTrue);
        expect(json['created_at'], testDateTime.toIso8601String());
        expect(
          json['game_ended_at'],
          testDateTime.add(const Duration(hours: 1)).toIso8601String(),
        );
      });

      test('should handle null gameEndedAt in JSON', () {
        final modelWithoutEndedAt = testModel.copyWith(gameEndedAt: null);
        final json = modelWithoutEndedAt.toJson();

        expect(json['game_ended_at'], isNull);
      });
    });

    group('fromDomain', () {
      test('should create model from domain entity', () {
        final domainScore = GlobalScore(
          id: 'score456',
          playerId: 'player456',
          playerName: 'Domain Player',
          roomId: 'room456',
          totalScore: 100,
          roundNumber: 5,
          position: 2,
          isWinner: false,
          createdAt: testDateTime,
          gameEndedAt: null,
        );

        final model = GlobalScoreModel.fromDomain(domainScore);

        expect(model.id, 'score456');
        expect(model.playerId, 'player456');
        expect(model.playerName, 'Domain Player');
        expect(model.roomId, 'room456');
        expect(model.totalScore, 100);
        expect(model.roundNumber, 5);
        expect(model.position, 2);
        expect(model.isWinner, isFalse);
        expect(model.createdAt, testDateTime);
        expect(model.gameEndedAt, isNull);
      });
    });

    group('toDomain', () {
      test('should convert model to domain entity', () {
        final domain = testModel.toDomain();

        expect(domain.id, 'score123');
        expect(domain.playerId, 'player123');
        expect(domain.playerName, 'Test Player');
        expect(domain.roomId, 'room123');
        expect(domain.totalScore, 42);
        expect(domain.roundNumber, 3);
        expect(domain.position, 1);
        expect(domain.isWinner, isTrue);
        expect(domain.createdAt, testDateTime);
        expect(domain.gameEndedAt, testDateTime.add(const Duration(hours: 1)));
      });

      test('should maintain null gameEndedAt', () {
        final modelWithoutEndedAt = testModel.copyWith(gameEndedAt: null);
        final domain = modelWithoutEndedAt.toDomain();

        expect(domain.gameEndedAt, isNull);
      });
    });

    group('toSupabaseJson', () {
      test('should include id when not empty', () {
        final json = testModel.toSupabaseJson();

        expect(json['id'], 'score123');
        expect(json['player_id'], 'player123');
      });

      test('should remove id when empty', () {
        final modelWithEmptyId = testModel.copyWith(id: '');
        final json = modelWithEmptyId.toSupabaseJson();

        expect(json.containsKey('id'), isFalse);
        expect(json['player_id'], 'player123');
      });

      test('should preserve all other fields when removing empty id', () {
        final modelWithEmptyId = testModel.copyWith(id: '');
        final json = modelWithEmptyId.toSupabaseJson();

        expect(json['player_id'], 'player123');
        expect(json['player_name'], 'Test Player');
        expect(json['room_id'], 'room123');
        expect(json['total_score'], 42);
        expect(json['round_number'], 3);
        expect(json['position'], 1);
        expect(json['is_winner'], isTrue);
        expect(json['created_at'], testDateTime.toIso8601String());
        expect(
          json['game_ended_at'],
          testDateTime.add(const Duration(hours: 1)).toIso8601String(),
        );
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        final updated = testModel.copyWith(
          totalScore: 50,
          position: 2,
          isWinner: false,
        );

        expect(updated.id, testModel.id);
        expect(updated.playerId, testModel.playerId);
        expect(updated.totalScore, 50);
        expect(updated.position, 2);
        expect(updated.isWinner, isFalse);
      });

      test('should maintain original values when not specified', () {
        final updated = testModel.copyWith(totalScore: 100);

        expect(updated.id, testModel.id);
        expect(updated.playerId, testModel.playerId);
        expect(updated.playerName, testModel.playerName);
        expect(updated.roomId, testModel.roomId);
        expect(updated.totalScore, 100);
        expect(updated.roundNumber, testModel.roundNumber);
        expect(updated.position, testModel.position);
        expect(updated.isWinner, testModel.isWinner);
        expect(updated.createdAt, testModel.createdAt);
        expect(updated.gameEndedAt, testModel.gameEndedAt);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final model1 = GlobalScoreModel(
          id: 'same',
          playerId: 'same',
          playerName: 'Same',
          roomId: 'same',
          totalScore: 10,
          roundNumber: 1,
          position: 1,
          isWinner: true,
          createdAt: testDateTime,
          gameEndedAt: null,
        );

        final model2 = GlobalScoreModel(
          id: 'same',
          playerId: 'same',
          playerName: 'Same',
          roomId: 'same',
          totalScore: 10,
          roundNumber: 1,
          position: 1,
          isWinner: true,
          createdAt: testDateTime,
          gameEndedAt: null,
        );

        expect(model1, equals(model2));
      });

      test('should not be equal when any field differs', () {
        final model1 = testModel;
        final model2 = testModel.copyWith(totalScore: 100);

        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
