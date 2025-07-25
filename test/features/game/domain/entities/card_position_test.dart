import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';

void main() {
  group('CardPosition', () {
    test('should create CardPosition with row and col', () {
      const position = CardPosition(row: 1, col: 2);

      expect(position.row, 1);
      expect(position.col, 2);
    });

    test('should support equality', () {
      const position1 = CardPosition(row: 1, col: 2);
      const position2 = CardPosition(row: 1, col: 2);
      const position3 = CardPosition(row: 2, col: 1);

      expect(position1, equals(position2));
      expect(position1, isNot(equals(position3)));
    });

    group('toTargetData', () {
      test('should convert to target data format', () {
        const position = CardPosition(row: 3, col: 4);
        final targetData = position.toTargetData();

        expect(targetData, isA<Map<String, dynamic>>());
        expect(targetData['row'], 3);
        expect(targetData['col'], 4);
        expect(targetData.keys.length, 2);
      });
    });

    group('equals', () {
      test('should return true for same position', () {
        const position = CardPosition(row: 1, col: 2);

        expect(position.equals(1, 2), isTrue);
      });

      test('should return false for different row', () {
        const position = CardPosition(row: 1, col: 2);

        expect(position.equals(2, 2), isFalse);
      });

      test('should return false for different col', () {
        const position = CardPosition(row: 1, col: 2);

        expect(position.equals(1, 3), isFalse);
      });

      test('should return false for both different', () {
        const position = CardPosition(row: 1, col: 2);

        expect(position.equals(3, 4), isFalse);
      });
    });

    test('should work with copyWith', () {
      const original = CardPosition(row: 1, col: 2);
      final copied = original.copyWith(row: 3);

      expect(copied.row, 3);
      expect(copied.col, 2);
      expect(copied, isNot(equals(original)));
    });
  });
}
