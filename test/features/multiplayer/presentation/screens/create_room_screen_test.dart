import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/create_room_screen.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/create_room_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import '../../../../helpers/go_router_test_helpers.dart';

class MockCreateRoomUseCase extends Mock implements CreateRoomUseCase {}

void main() {
  late MockCreateRoomUseCase mockCreateRoomUseCase;

  setUp(() {
    mockCreateRoomUseCase = MockCreateRoomUseCase();
  });

  void setLargeScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
  }

  Widget createWidgetUnderTest({String? userId}) {
    return ProviderScope(
      overrides: [
        createRoomUseCaseProvider.overrideWithValue(mockCreateRoomUseCase),
        currentUserIdProvider.overrideWithValue(userId),
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const CreateRoomScreen(),
            ),
            GoRoute(
              path: '/room/:id',
              builder: (context, state) =>
                  Scaffold(body: Text('Room ${state.pathParameters['id']}')),
            ),
          ],
        ),
      ),
    );
  }

  group('Room Creation UI for Competitive Multiplayer Setup', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets(
      'should enable comprehensive competitive room creation workflow with proper constraints and user feedback',
      (WidgetTester tester) async {
        // Test behavior: screen provides complete room setup experience for competitive multiplayer gaming coordination

        setLargeScreenSize(tester);
        const competitiveHostId = 'tournament-organizer-789';
        const strategicRoomId = 'competitive-arena-456';

        final successfulCompetitiveRoom = const Room(
          id: strategicRoomId,
          creatorId: competitiveHostId,
          playerIds: [competitiveHostId],
          status: RoomStatus.waiting,
          maxPlayers: 6,
        );

        when(
          () => mockCreateRoomUseCase.call(
            creatorId: competitiveHostId,
            maxPlayers: 6,
          ),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return successfulCompetitiveRoom;
        });

        // Initial UI state - ready for competitive configuration
        await tester.pumpWidget(
          createWidgetUnderTest(userId: competitiveHostId),
        );

        expect(
          find.text('Créer une partie'),
          findsOneWidget,
          reason: 'Should display competitive room creation header',
        );
        expect(
          find.text('Configuration de la partie'),
          findsOneWidget,
          reason: 'Should provide configuration section for strategic setup',
        );
        expect(
          find.text('Nombre de joueurs'),
          findsOneWidget,
          reason:
              'Should enable player capacity selection for competitive balance',
        );
        expect(
          find.text('4'),
          findsOneWidget,
          reason: 'Should default to balanced competitive capacity',
        );
        expect(
          find.text('2 à 8 joueurs'),
          findsOneWidget,
          reason: 'Should indicate competitive capacity constraints',
        );
        expect(
          find.byIcon(Icons.group_add),
          findsOneWidget,
          reason: 'Should display competitive room icon',
        );
        expect(
          find.byIcon(Icons.add_circle_outline),
          findsOneWidget,
          reason:
              'Should enable capacity increase for larger competitive groups',
        );
        expect(
          find.byIcon(Icons.remove_circle_outline),
          findsOneWidget,
          reason:
              'Should enable capacity decrease for focused competitive play',
        );
        expect(
          find.text('Créer la partie'),
          findsOneWidget,
          reason: 'Should provide competitive room creation action',
        );

        // Capacity adjustment behavior - enable strategic group sizing
        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();

        expect(
          find.text('6'),
          findsOneWidget,
          reason:
              'Should enable competitive capacity adjustment for strategic group gameplay',
        );

        // Constraint enforcement behavior - maintain competitive balance
        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pump();

        expect(
          find.text('2'),
          findsOneWidget,
          reason: 'Should enforce minimum competitive capacity',
        );

        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pump();

        expect(
          find.text('2'),
          findsOneWidget,
          reason:
              'Should prevent sub-competitive capacity to maintain multiplayer integrity',
        );

        // Maximum capacity constraint
        for (int i = 0; i < 6; i++) {
          await tester.tap(find.byIcon(Icons.add_circle_outline));
          await tester.pump();
        }

        expect(
          find.text('8'),
          findsOneWidget,
          reason: 'Should reach maximum competitive capacity',
        );

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();

        expect(
          find.text('8'),
          findsOneWidget,
          reason:
              'Should enforce maximum competitive capacity to maintain strategic balance',
        );

        // Reset to strategic capacity for creation test
        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pump();

        expect(find.text('6'), findsOneWidget);

        // Room creation workflow behavior - competitive environment establishment
        await tester.tap(find.text('Créer la partie'));
        await tester.pump();

        // Loading state behavior - provide user feedback during creation
        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
          reason:
              'Should display loading indicator during competitive room creation',
        );
        expect(
          find.text('Créer la partie'),
          findsNothing,
          reason: 'Should hide creation button during processing',
        );

        // Control disabling behavior - prevent interference during creation
        final increaseButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.add_circle_outline),
        );
        final decreaseButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.remove_circle_outline),
        );
        final createButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        expect(
          increaseButton.onPressed,
          isNull,
          reason:
              'Should disable capacity controls during competitive room creation',
        );
        expect(
          decreaseButton.onPressed,
          isNull,
          reason:
              'Should disable capacity controls during competitive room creation',
        );
        expect(
          createButton.onPressed,
          isNull,
          reason: 'Should disable creation button during processing',
        );

        await tester.pumpAndSettle();

        // Navigation behavior - transition to competitive room
        expect(
          find.text('Room $strategicRoomId'),
          findsOneWidget,
          reason:
              'Should navigate to created competitive room for participant coordination',
        );

        verify(
          () => mockCreateRoomUseCase.call(
            creatorId: competitiveHostId,
            maxPlayers: 6,
          ),
        ).called(1);
      },
    );

    group(
      'should handle competitive room creation failures with proper user feedback',
      () {
        testWidgets('when user authentication is missing', (
          WidgetTester tester,
        ) async {
          // Test behavior: screen validates user authentication to ensure competitive room ownership

          setLargeScreenSize(tester);

          await tester.pumpWidget(createWidgetUnderTest(userId: null));

          await tester.tap(find.text('Créer la partie'));
          await tester.pump();
          await tester.pump();

          expect(
            find.text('Erreur: Exception: Utilisateur non connecté'),
            findsOneWidget,
            reason:
                'Should inform user about authentication requirement for competitive room creation',
          );
          expect(
            find.byType(SnackBar),
            findsOneWidget,
            reason: 'Should display error feedback for authentication failure',
          );
        });

        testWidgets('when infrastructure fails during creation', (
          WidgetTester tester,
        ) async {
          // Test behavior: screen handles creation failures gracefully to maintain user experience

          setLargeScreenSize(tester);
          const competitiveHostId = 'tournament-organizer-789';
          const infrastructureError =
              'Competitive infrastructure temporarily unavailable';

          when(
            () => mockCreateRoomUseCase.call(
              creatorId: competitiveHostId,
              maxPlayers: 4,
            ),
          ).thenThrow(Exception(infrastructureError));

          await tester.pumpWidget(
            createWidgetUnderTest(userId: competitiveHostId),
          );

          await tester.tap(find.text('Créer la partie'));
          await tester.pump();
          await tester.pump();

          expect(
            find.text('Erreur: Exception: $infrastructureError'),
            findsOneWidget,
            reason:
                'Should provide clear error feedback when competitive infrastructure fails',
          );
          expect(
            find.byType(SnackBar),
            findsOneWidget,
            reason:
                'Should display error notification for infrastructure failures',
          );
        });
      },
    );

    testWidgets(
      'should maintain proper competitive styling and layout for strategic gaming interface',
      (WidgetTester tester) async {
        // Test behavior: screen provides polished interface suitable for competitive gaming setup

        setLargeScreenSize(tester);

        await tester.pumpWidget(
          createWidgetUnderTest(userId: 'competitive-host-123'),
        );

        expect(
          find.byType(Card),
          findsOneWidget,
          reason:
              'Should use card layout for organized competitive setup interface',
        );
        expect(
          find.byType(ConstrainedBox),
          findsWidgets,
          reason:
              'Should constrain layout for consistent competitive interface',
        );
        expect(
          find.byType(SafeArea),
          findsWidgets,
          reason:
              'Should respect device boundaries for competitive interface safety',
        );

        // Circular player count display for competitive clarity
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(Row),
                matching: find.byType(Container),
              )
              .first,
        );
        final decoration = container.decoration as BoxDecoration;
        expect(
          decoration.shape,
          BoxShape.circle,
          reason:
              'Should display player count in circular format for competitive visual clarity',
        );
      },
    );
  });
}
