import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';

void main() {
  group('PlayDirection', () {
    test('should have forward value', () {
      expect(PlayDirection.forward, isA<PlayDirection>());
      expect(PlayDirection.forward.toString(), 'PlayDirection.forward');
    });

    test('should have backward value', () {
      expect(PlayDirection.backward, isA<PlayDirection>());
      expect(PlayDirection.backward.toString(), 'PlayDirection.backward');
    });

    test('values should be different', () {
      expect(PlayDirection.forward, isNot(PlayDirection.backward));
    });

    test('should contain all expected values', () {
      expect(PlayDirection.values.length, 2);
      expect(PlayDirection.values, contains(PlayDirection.forward));
      expect(PlayDirection.values, contains(PlayDirection.backward));
    });

    test('should be able to get value by index', () {
      expect(PlayDirection.values[0], PlayDirection.forward);
      expect(PlayDirection.values[1], PlayDirection.backward);
    });

    test('should maintain index values', () {
      expect(PlayDirection.forward.index, 0);
      expect(PlayDirection.backward.index, 1);
    });
  });
}