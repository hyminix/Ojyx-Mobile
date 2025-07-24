import 'package:freezed_annotation/freezed_annotation.dart';
import 'card.dart';
import 'action_card.dart';

part 'db_player_grid.freezed.dart';

@freezed
class DbPlayerGrid with _$DbPlayerGrid {
  const factory DbPlayerGrid({
    required String id,
    required String gameStateId,
    required String playerId,
    required List<Card> gridCards,
    required List<ActionCard> actionCards,
    required int score,
    required int position,
    required bool isActive,
    required bool hasRevealedAll,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DbPlayerGrid;
}