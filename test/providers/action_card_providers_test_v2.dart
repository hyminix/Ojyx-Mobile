import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/riverpod_test_helpers.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_providers.dart';

void main() {
  group('ActionCardStateNotifier', () {
    late ProviderContainer container;
    late ActionCardStateNotifier notifier;

    setUp(() {
      container = createTestContainer();
      notifier = container.read(actionCardStateNotifierProvider.notifier);
    });

    test('initial state should have correct values', () {
      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 37);
      expect(state.discardPileCount, 0);
      expect(state.isLoading, false);
    });

    test('should update draw pile count', () {
      notifier.updateCounts(drawPileCount: 25);

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 25);
      expect(state.discardPileCount, 0); // Unchanged
    });

    test('should update discard pile count', () {
      notifier.updateCounts(discardPileCount: 5);

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 37); // Unchanged
      expect(state.discardPileCount, 5);
    });

    test('should update both counts', () {
      notifier.updateCounts(drawPileCount: 20, discardPileCount: 17);

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 20);
      expect(state.discardPileCount, 17);
    });

    test('should set loading state', () {
      notifier.setLoading(true);
      expect(container.read(actionCardStateNotifierProvider).isLoading, true);

      notifier.setLoading(false);
      expect(container.read(actionCardStateNotifierProvider).isLoading, false);
    });

    test('should handle draw card action', () async {
      await notifier.drawCard();

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 36); // One card drawn
      expect(state.discardPileCount, 0);
    });
  });

  group('ActionCardNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = createTestContainer();
    });

    test('initial state should be AsyncData with null', () {
      final state = container.read(actionCardNotifierProvider);
      expect(state, equals(const AsyncData<void>(null)));
    });

    test('should have notifier instance', () {
      final notifier = container.read(actionCardNotifierProvider.notifier);
      expect(notifier, isNotNull);
    });
  });

  group('Provider Functions', () {
    test('actionCardLocalDataSource provider should provide instance', () {
      final container = createTestContainer();
      final dataSource = container.read(actionCardLocalDataSourceProvider);
      expect(dataSource, isNotNull);
      container.dispose();
    });

    test('actionCardRepository provider should provide instance', () {
      final container = createTestContainer();
      final repository = container.read(actionCardRepositoryProvider);
      expect(repository, isNotNull);
      container.dispose();
    });
  });
}
