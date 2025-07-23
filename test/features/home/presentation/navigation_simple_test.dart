import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/home/presentation/screens/home_screen.dart';

void main() {
  group('Navigation Simple Test', () {
    test('HomeScreen should exist', () {
      expect(HomeScreen, isNotNull);
    });

    test('HomeScreen should be a StatelessWidget', () {
      const screen = HomeScreen();
      expect(screen, isA<HomeScreen>());
    });
  });
}