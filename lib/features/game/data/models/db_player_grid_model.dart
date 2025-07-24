import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/entities/player_grid.dart';

part 'db_player_grid_model.freezed.dart';
part 'db_player_grid_model.g.dart';

// Type alias for the model
typedef DbPlayerGrid = DbPlayerGridModel;

@freezed
class DbPlayerGridModel with _$DbPlayerGridModel {
  const factory DbPlayerGridModel({
    required String id,
    @JsonKey(name: 'game_state_id') required String gameStateId,
    @JsonKey(name: 'player_id') required String playerId,
    @JsonKey(name: 'grid_cards') required List<Card> gridCards,
    @JsonKey(name: 'action_cards') required List<ActionCard> actionCards,
    required int score,
    required int position,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'has_revealed_all') required bool hasRevealedAll,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DbPlayerGridModel;

  const DbPlayerGridModel._();

  factory DbPlayerGridModel.fromJson(Map<String, dynamic> json) => 
      _$DbPlayerGridModelFromJson(json);

  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'game_state_id': gameStateId,
      'player_id': playerId,
      'grid_cards': gridCards.map((card) => {
        'value': card.value,
        'is_revealed': card.isRevealed,
      }).toList(),
      'action_cards': actionCards.map((card) => {
        'id': card.id,
        'type': card.type.name,
        'name': card.name,
        'description': card.description,
        'timing': card.timing.name,
        'target': card.target.name,
        'parameters': card.parameters,
      }).toList(),
      'score': score,
      'position': position,
      'is_active': isActive,
      'has_revealed_all': hasRevealedAll,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PlayerGrid toPlayerGrid() {
    // Convert flat list of cards to grid structure
    return PlayerGrid.fromCards(gridCards);
  }
}