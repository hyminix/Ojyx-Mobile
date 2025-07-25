import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';

void main() {
  group('CardPosition', () {
    test('should correctly identify grid positions for game logic', () {
      // Test cases for position comparison behavior
      final testCases = [
        // (position, checkRow, checkCol, shouldMatch, description)
        (const CardPosition(row: 1, col: 2), 1, 2, true, 'same position'),
        (const CardPosition(row: 1, col: 2), 2, 2, false, 'different row'),
        (const CardPosition(row: 1, col: 2), 1, 3, false, 'different col'),
        (const CardPosition(row: 1, col: 2), 3, 4, false, 'both different'),
        (const CardPosition(row: 0, col: 0), 0, 0, true, 'top-left corner'),
        (const CardPosition(row: 2, col: 3), 2, 3, true, 'bottom-right corner'),
      ];

      for (final (position, checkRow, checkCol, shouldMatch, description)
          in testCases) {
        expect(
          position.equals(checkRow, checkCol),
          shouldMatch,
          reason:
              'Position comparison for $description should ${shouldMatch ? "match" : "not match"}',
        );
      }
    });

    test('should provide grid coordinate data for action targeting', () {
      const position = CardPosition(row: 3, col: 4);
      final targetData = position.toTargetData();

      // Verify position data can be used for game actions
      expect(
        targetData,
        isA<Map<String, dynamic>>(),
        reason: 'Should provide map for action targeting',
      );
      expect(
        targetData['row'],
        3,
        reason: 'Should preserve row for action target',
      );
      expect(
        targetData['col'],
        4,
        reason: 'Should preserve col for action target',
      );
      expect(
        targetData.keys.length,
        2,
        reason: 'Should contain only necessary coordinates',
      );
    });

    test('should support position equality for game state comparison', () {
      const position1 = CardPosition(row: 1, col: 2);
      const position2 = CardPosition(row: 1, col: 2);
      const position3 = CardPosition(row: 2, col: 1);

      // Verify positions can be compared for game logic
      expect(
        position1,
        equals(position2),
        reason: 'Same coordinates should be equal for game state',
      );
      expect(
        position1,
        isNot(equals(position3)),
        reason: 'Different coordinates should not be equal',
      );
    });

    test('should allow position modification for game moves', () {
      const original = CardPosition(row: 1, col: 2);
      final moved = original.copyWith(row: 3);

      // Verify position can be modified for move actions
      expect(moved.row, 3, reason: 'Should update row for movement');
      expect(moved.col, 2, reason: 'Should preserve col when not changed');
      expect(
        moved,
        isNot(equals(original)),
        reason: 'Modified position should be different for game state',
      );
    });
  });
}
