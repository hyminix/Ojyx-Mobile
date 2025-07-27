import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

/// Matcher pour valider qu'une carte est valide selon les règles du jeu
Matcher get isValidCard => _IsValidCard();

class _IsValidCard extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Card) return false;
    return item.value >= kMinCardValue && item.value <= kMaxCardValue;
  }

  @override
  Description describe(Description description) {
    return description.add(
      'a valid card with value between $kMinCardValue and $kMaxCardValue',
    );
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Card) {
      return mismatchDescription.add('is not a Card object');
    }
    return mismatchDescription.add(
      'has value ${item.value} which is outside valid range [$kMinCardValue, $kMaxCardValue]',
    );
  }
}

/// Matcher pour vérifier qu'une carte a une valeur spécifique
Matcher hasCardValue(int expectedValue) => _HasCardValue(expectedValue);

class _HasCardValue extends Matcher {
  final int expectedValue;

  _HasCardValue(this.expectedValue);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Card) return false;
    return item.value == expectedValue;
  }

  @override
  Description describe(Description description) {
    return description.add('a card with value $expectedValue');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Card) {
      return mismatchDescription.add('is not a Card object');
    }
    return mismatchDescription.add('has value ${item.value}');
  }
}

/// Matcher pour vérifier le statut de révélation d'une carte
Matcher get isRevealed => _IsRevealed(true);
Matcher get isHidden => _IsRevealed(false);

class _IsRevealed extends Matcher {
  final bool expectedRevealed;

  _IsRevealed(this.expectedRevealed);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Card) return false;
    return item.isRevealed == expectedRevealed;
  }

  @override
  Description describe(Description description) {
    return description.add(
      expectedRevealed ? 'a revealed card' : 'a hidden card',
    );
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Card) {
      return mismatchDescription.add('is not a Card object');
    }
    return mismatchDescription.add(
      item.isRevealed ? 'is revealed' : 'is hidden',
    );
  }
}

/// Matcher pour vérifier la couleur d'une carte
Matcher hasCardColor(CardValueColor expectedColor) =>
    _HasCardColor(expectedColor);

class _HasCardColor extends Matcher {
  final CardValueColor expectedColor;

  _HasCardColor(this.expectedColor);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Card) return false;
    return item.color == expectedColor;
  }

  @override
  Description describe(Description description) {
    return description.add('a card with color $expectedColor');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Card) {
      return mismatchDescription.add('is not a Card object');
    }
    return mismatchDescription.add(
      'has color ${item.color} (value: ${item.value})',
    );
  }
}
