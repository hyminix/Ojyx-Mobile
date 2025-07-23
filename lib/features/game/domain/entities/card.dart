import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'package:ojyx/core/utils/extensions.dart';

part 'card.freezed.dart';
part 'card.g.dart';

@freezed
class Card with _$Card {
  @Assert('value >= kMinCardValue && value <= kMaxCardValue')
  const factory Card({required int value, @Default(false) bool isRevealed}) =
      _Card;

  const Card._();

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  CardValueColor get color => value.cardColor;

  Card reveal() => copyWith(isRevealed: true);

  Card hide() => copyWith(isRevealed: false);
}
