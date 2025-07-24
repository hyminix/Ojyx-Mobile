import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/entities/player_grid.dart';
import '../models/db_player_grid_model.dart';

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

  PlayerGrid toDomain() {
    // Convert the gridCards data to Card entities and create PlayerGrid
    final cards = gridCards.map((cardData) => Card(
      value: cardData['value'] as int,
      isRevealed: cardData['is_revealed'] as bool? ?? false,
    )).toList();
    
    return PlayerGrid.fromCards(cards);
  }
  
  DbPlayerGrid toDbPlayerGrid() {
    return DbPlayerGridModel(
      id: id,
      gameStateId: gameStateId,
      playerId: playerId,
      gridCards: gridCards.map((cardData) => Card(
        value: cardData['value'] as int,
        isRevealed: cardData['is_revealed'] as bool? ?? false,
      )).toList(),
      actionCards: actionCards.map((cardData) => ActionCard(
        id: cardData['id'] as String,
        type: ActionCardType.values.firstWhere(
          (e) => e.name == cardData['type'],
        ),
        name: cardData['name'] as String,
        description: cardData['description'] as String,
        timing: ActionTiming.values.firstWhere(
          (e) => e.name == cardData['timing'],
        ),
        target: ActionTarget.values.firstWhere(
          (e) => e.name == cardData['target'],
        ),
        parameters: (cardData['parameters'] as Map<dynamic, dynamic>?)?.cast<String, dynamic>() ?? {},
      )).toList(),
      score: score,
      position: position,
      isActive: isActive,
      hasRevealedAll: hasRevealedAll,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}