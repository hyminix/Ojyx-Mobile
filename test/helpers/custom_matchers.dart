import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/player_state.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
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

/// Matcher pour vérifier qu'un joueur a un score spécifique
Matcher hasScore(int expectedScore) => _HasScore(expectedScore);

class _HasScore extends Matcher {
  final int expectedScore;

  _HasScore(this.expectedScore);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! PlayerState) return false;
    return item.currentScore == expectedScore;
  }

  @override
  Description describe(Description description) {
    return description.add('a player with score $expectedScore');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! PlayerState) {
      return mismatchDescription.add('is not a PlayerState object');
    }
    return mismatchDescription.add('has score ${item.currentScore}');
  }
}

/// Matcher pour vérifier si un joueur a terminé
Matcher get hasFinished => _HasFinished(true);
Matcher get hasNotFinished => _HasFinished(false);

class _HasFinished extends Matcher {
  final bool expectedFinished;

  _HasFinished(this.expectedFinished);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! PlayerState) return false;
    return item.hasFinished == expectedFinished;
  }

  @override
  Description describe(Description description) {
    return description.add(
      expectedFinished
          ? 'a player who has finished'
          : 'a player who has not finished',
    );
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! PlayerState) {
      return mismatchDescription.add('is not a PlayerState object');
    }
    return mismatchDescription.add(
      item.hasFinished ? 'has finished' : 'has not finished',
    );
  }
}

/// Matcher pour vérifier l'état d'une partie
Matcher isInGameState(String state) => _IsInGameState(state);

class _IsInGameState extends Matcher {
  final String expectedState;

  _IsInGameState(this.expectedState);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! GameState) return false;

    switch (expectedState.toLowerCase()) {
      case 'paused':
        return item.isPaused;
      case 'playing':
        return !item.isPaused && !item.isLastRound;
      case 'last_round':
        return item.isLastRound && !item.isPaused;
      default:
        return false;
    }
  }

  @override
  Description describe(Description description) {
    return description.add('a game in "$expectedState" state');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! GameState) {
      return mismatchDescription.add('is not a GameState object');
    }

    String actualState;
    if (item.isPaused) {
      actualState = 'paused';
    } else if (item.isLastRound) {
      actualState = 'last_round';
    } else {
      actualState = 'playing';
    }

    return mismatchDescription.add('is in "$actualState" state');
  }
}

/// Matcher pour vérifier le nombre de cartes révélées d'un joueur
Matcher hasRevealedCount(int expectedCount) => _HasRevealedCount(expectedCount);

class _HasRevealedCount extends Matcher {
  final int expectedCount;

  _HasRevealedCount(this.expectedCount);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! PlayerState) return false;
    return item.revealedCount == expectedCount;
  }

  @override
  Description describe(Description description) {
    return description.add('a player with $expectedCount revealed card(s)');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! PlayerState) {
      return mismatchDescription.add('is not a PlayerState object');
    }
    return mismatchDescription.add(
      'has ${item.revealedCount} revealed card(s)',
    );
  }
}

/// Matcher pour vérifier le nombre de joueurs dans une partie
Matcher hasPlayerCount(int expectedCount) => _HasPlayerCount(expectedCount);

class _HasPlayerCount extends Matcher {
  final int expectedCount;

  _HasPlayerCount(this.expectedCount);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! GameState) return false;
    return item.players.length == expectedCount;
  }

  @override
  Description describe(Description description) {
    return description.add('a game with $expectedCount player(s)');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! GameState) {
      return mismatchDescription.add('is not a GameState object');
    }
    return mismatchDescription.add('has ${item.players.length} player(s)');
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

/// Matcher pour vérifier le timing d'une carte d'action
Matcher get isImmediateActionCard => _HasActionTiming(ActionTiming.immediate);
Matcher get isOptionalActionCard => _HasActionTiming(ActionTiming.optional);
Matcher get isReactiveActionCard => _HasActionTiming(ActionTiming.reactive);

class _HasActionTiming extends Matcher {
  final ActionTiming expectedTiming;

  _HasActionTiming(this.expectedTiming);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! ActionCard) return false;
    return item.timing == expectedTiming;
  }

  @override
  Description describe(Description description) {
    String timingStr;
    switch (expectedTiming) {
      case ActionTiming.immediate:
        timingStr = 'an immediate action card';
        break;
      case ActionTiming.optional:
        timingStr = 'an optional action card';
        break;
      case ActionTiming.reactive:
        timingStr = 'a reactive action card';
        break;
    }
    return description.add(timingStr);
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! ActionCard) {
      return mismatchDescription.add('is not an ActionCard object');
    }

    String actualTiming;
    switch (item.timing) {
      case ActionTiming.immediate:
        actualTiming = 'immediate';
        break;
      case ActionTiming.optional:
        actualTiming = 'optional';
        break;
      case ActionTiming.reactive:
        actualTiming = 'reactive';
        break;
    }

    return mismatchDescription.add('has $actualTiming timing');
  }
}
