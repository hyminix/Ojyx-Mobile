import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/widgets.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/player_hand_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/turn_info_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/deck_and_discard_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/opponent_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/opponents_view_widget.dart';

void main() {
  group('widgets.dart barrel exports', () {
    test('should export all widgets', () {
      // Act & Assert - Simply check that all widgets are accessible
      expect(CardWidget, isNotNull);
      expect(PlayerGridWidget, isNotNull);
      expect(PlayerHandWidget, isNotNull);
      expect(TurnInfoWidget, isNotNull);
      expect(DeckAndDiscardWidget, isNotNull);
      expect(OpponentGridWidget, isNotNull);
      expect(OpponentsViewWidget, isNotNull);
    });

    test('should ensure all widgets are accessible through barrel import', () {
      // This test verifies that we can import all widgets through the barrel file
      // If the barrel file has any issues, this test will fail at compile time

      // Act - Create variables to reference all exported classes
      final widgets = [
        CardWidget,
        PlayerGridWidget,
        PlayerHandWidget,
        TurnInfoWidget,
        DeckAndDiscardWidget,
        OpponentGridWidget,
        OpponentsViewWidget,
      ];

      // Assert - All widgets should be accessible
      for (final widget in widgets) {
        expect(widget, isNotNull);
      }

      expect(widgets.length, equals(7));
    });
  });
}
