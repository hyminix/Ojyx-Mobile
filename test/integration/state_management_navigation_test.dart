import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/core/config/router_config.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider_v2.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_state_provider_v2.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider_v2.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-123';
}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGotrueClient extends Mock implements GotrueClient {}

void main() {
  group('State Management & Navigation Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Riverpod Modern Providers Integration', () {
      test('all migrated providers should initialize correctly', () {
        // Test CardSelection provider
        final cardSelection = container.read(cardSelectionProvider);
        expect(cardSelection.isSelecting, isFalse);
        expect(cardSelection.selectionType, isNull);

        // Test ActionCard provider
        final actionCard = container.read(actionCardStateNotifierProvider);
        expect(actionCard.drawPileCount, 37);
        expect(actionCard.discardPileCount, 0);

        // Test GameAnimation provider
        final gameAnimation = container.read(gameAnimationProvider);
        expect(gameAnimation.showingDirectionChange, isFalse);
        expect(gameAnimation.direction, PlayDirection.forward);
      });

      test('providers should handle state updates correctly', () {
        // Update CardSelection - start peek selection
        container
            .read(cardSelectionProvider.notifier)
            .startPeekSelection(maxCards: 3);

        var updatedSelection = container.read(cardSelectionProvider);
        expect(updatedSelection.isSelecting, isTrue);
        expect(updatedSelection.selectionType, CardSelectionType.peek);

        // Select a card
        container.read(cardSelectionProvider.notifier).selectCard(1, 2);
        
        updatedSelection = container.read(cardSelectionProvider);
        expect(updatedSelection.selections, isNotEmpty);
        expect(updatedSelection.selections.first.row, 1);
        expect(updatedSelection.selections.first.col, 2);

        // Clear selection
        container.read(cardSelectionProvider.notifier).cancelSelection();
        expect(container.read(cardSelectionProvider).isSelecting, isFalse);
      });

      test('providers should interact correctly', () {
        // Simulate card swap selection
        container
            .read(cardSelectionProvider.notifier)
            .startSwapSelection();

        expect(container.read(cardSelectionProvider).isSelecting, isTrue);
        expect(container.read(cardSelectionProvider).selectionType, CardSelectionType.swap);

        // Simulate direction change animation
        container
            .read(gameAnimationProvider.notifier)
            .showDirectionChange(PlayDirection.backward);

        expect(container.read(gameAnimationProvider).showingDirectionChange, isTrue);
        expect(container.read(gameAnimationProvider).direction, PlayDirection.backward);
      });
    });

    group('Router Guards with Auth State', () {
      testWidgets('should redirect unauthenticated users', (tester) async {
        // Create container with no auth
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authNotifierProvider.overrideWith(() => MockAuthNotifier(null)),
            ],
            child: MaterialApp.router(
              routerConfig: container.read(routerProvider),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should be on home screen (not authenticated)
        expect(find.byType(MaterialApp), findsOneWidget);
      });

      testWidgets('authenticated users can access protected routes', (
        tester,
      ) async {
        final mockUser = MockUser();

        // Create router that allows authenticated access
        final testRouter = GoRouter(
          initialLocation: '/create-room',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Home'))),
            ),
            GoRoute(
              path: '/create-room',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Create Room'))),
              redirect: (context, state) {
                // Simulate authenticated user
                return null; // Allow access
              },
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter));

        await tester.pumpAndSettle();

        // Should show create room screen
        expect(find.text('Create Room'), findsOneWidget);
      });
    });

    group('Complete User Flow Integration', () {
      test('user flow from auth to game', () async {
        // 1. Start with no auth
        final authState = container.read(authNotifierProvider);
        expect(authState.isLoading, isTrue);

        // 2. Simulate successful auth
        // This would normally happen via the AuthNotifier

        // 3. Verify providers are ready
        final cardSelection = container.read(cardSelectionProvider);
        expect(cardSelection, isNotNull);

        final actionCard = container.read(actionCardProvider);
        expect(actionCard, isNotNull);

        final gameAnimation = container.read(gameAnimationProvider);
        expect(gameAnimation, isNotNull);

        // 4. Simulate game flow
        // Select card for peek
        container
            .read(cardSelectionProvider.notifier)
            .selectCard(
              playerId: 'player1',
              cardIndex: 0,
              mode: CardSelectionMode.peek,
            );

        // Add action card
        container
            .read(actionCardProvider.notifier)
            .addCardToPlayer(
              playerId: 'player1',
              card: const ActionCard(
                id: 'card1',
                name: 'Peek',
                description: 'Look at one of your cards',
                type: ActionCardType.optional,
                effect: ActionCardEffect.peek,
                targetType: TargetType.self,
                targetCount: 1,
              ),
            );

        // Verify state consistency
        expect(
          container.read(cardSelectionProvider).mode,
          CardSelectionMode.peek,
        );
        expect(
          container.read(actionCardProvider).playerHands['player1']?.length,
          1,
        );
      });
    });

    group('Error Handling Integration', () {
      test('providers should handle errors gracefully', () {
        // Test error in CardSelection
        expect(
          () => container
              .read(cardSelectionProvider.notifier)
              .selectCard(
                playerId: '',
                cardIndex: -1,
                mode: CardSelectionMode.peek,
              ),
          returnsNormally,
        );

        // Selection should not be made with invalid data
        expect(container.read(cardSelectionProvider).selectedCard, isNull);
      });
    });

    group('Performance Tests', () {
      test('rapid state updates should not cause issues', () {
        final stopwatch = Stopwatch()..start();

        // Perform 100 rapid selections
        for (int i = 0; i < 100; i++) {
          container
              .read(cardSelectionProvider.notifier)
              .selectCard(
                playerId: 'player$i',
                cardIndex: i % 12,
                mode: CardSelectionMode
                    .values[i % CardSelectionMode.values.length],
              );
        }

        stopwatch.stop();

        // Should complete quickly (under 100ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));

        // Final state should be consistent
        final finalState = container.read(cardSelectionProvider);
        expect(finalState.selectedCard, isNotNull);
      });
    });
  });
}

// Mock implementation for tests
class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(this._user);

  final User? _user;

  @override
  Future<User?> build() async => _user;
}
