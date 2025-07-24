import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/db_player_grid.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/action_card.dart';

part 'player_grid_model.freezed.dart';
part 'player_grid_model.g.dart';

@freezed
class PlayerGridModel with _$PlayerGridModel {
  const factory PlayerGridModel({
    required String id,
    required String gameStateId,
    required String playerId,
    required List<Map<String, dynamic>> gridCards,
    required List<Map<String, dynamic>> actionCards,
    required int score,
    required int position,
    required bool isActive,
    required bool hasRevealedAll,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlayerGridModel;

  const PlayerGridModel._();

  factory PlayerGridModel.fromJson(Map<String, dynamic> json) => _$PlayerGridModelFromJson(json);

  factory PlayerGridModel.fromDomain(DbPlayerGrid playerGrid) {
    return PlayerGridModel(
      id: playerGrid.id,
      gameStateId: playerGrid.gameStateId,
      playerId: playerGrid.playerId,
      gridCards: playerGrid.gridCards.map((card) => {
        'value': card.value,
        'is_revealed': card.isRevealed,
      }).toList(),
      actionCards: playerGrid.actionCards.map((card) => {
        'id': card.id,
        'type': card.type.name,
        'timing': card.timing.name,
        'name': card.name,
        'description': card.description,
        'target': card.target.name,
        'parameters': card.parameters,
      }).toList(),
      score: playerGrid.score,
      position: playerGrid.position,
      isActive: playerGrid.isActive,
      hasRevealedAll: playerGrid.hasRevealedAll,
      createdAt: playerGrid.createdAt,
      updatedAt: playerGrid.updatedAt,
    );
  }

  DbPlayerGrid toDomain() {
    return DbPlayerGrid(
      id: id,
      gameStateId: gameStateId,
      playerId: playerId,
      gridCards: gridCards.map((cardJson) => Card(
        value: cardJson['value'] as int,
        isRevealed: cardJson['is_revealed'] as bool,
      )).toList(),
      actionCards: actionCards.map((cardJson) => ActionCard(
        id: cardJson['id'] as String,
        type: ActionCardType.values.firstWhere(
          (type) => type.name == cardJson['type'],
          orElse: () => ActionCardType.teleport,
        ),
        name: cardJson['name'] as String,
        description: cardJson['description'] as String,
        timing: ActionTiming.values.firstWhere(
          (timing) => timing.name == cardJson['timing'],
          orElse: () => ActionTiming.optional,
        ),
        target: ActionTarget.values.firstWhere(
          (target) => target.name == cardJson['target'],
          orElse: () => ActionTarget.none,
        ),
        parameters: Map<String, dynamic>.from(cardJson['parameters'] as Map? ?? {}),
      )).toList(),
      score: score,
      position: position,
      isActive: isActive,
      hasRevealedAll: hasRevealedAll,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'game_state_id': gameStateId,
      'player_id': playerId,
      'grid_cards': gridCards,
      'action_cards': actionCards,
      'score': score,
      'position': position,
      'is_active': isActive,
      'has_revealed_all': hasRevealedAll,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}