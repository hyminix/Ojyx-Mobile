// Game Constants
const int kMaxPlayers = 8;
const int kMinPlayers = 2;
const int kCardsPerPlayer = 12;
const int kGridRows = 3;
const int kGridColumns = 4;
const int kInitialRevealedCards = 2;
const int kMaxActionCardsInHand = 3;

// Card Values
const int kMinCardValue = -2;
const int kMaxCardValue = 12;

// Timing Constants
const Duration kReconnectionTimeout = Duration(minutes: 2);
const Duration kTurnTimeout = Duration(seconds: 60);
const Duration kAnimationDuration = Duration(milliseconds: 300);

// Card Distribution
const Map<int, int> kCardDistribution = {
  -2: 5,
  -1: 10,
  0: 15,
  1: 10,
  2: 10,
  3: 10,
  4: 10,
  5: 10,
  6: 10,
  7: 10,
  8: 10,
  9: 10,
  10: 10,
  11: 10,
  12: 10,
};

// Colors for card values
enum CardValueColor {
  darkBlue, // -2, -1
  lightBlue, // 0
  green, // 1-4
  yellow, // 5-8
  red, // 9-12
}
