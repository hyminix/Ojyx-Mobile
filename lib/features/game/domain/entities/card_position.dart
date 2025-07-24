import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_position.freezed.dart';

@freezed
class CardPosition with _$CardPosition {
  const factory CardPosition({required int row, required int col}) =
      _CardPosition;

  const CardPosition._();

  /// Convert to target data format for action cards
  Map<String, dynamic> toTargetData() => {'row': row, 'col': col};

  /// Check if this position equals another position
  bool equals(int row, int col) => this.row == row && this.col == col;
}
