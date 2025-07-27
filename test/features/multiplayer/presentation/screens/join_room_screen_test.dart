import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/join_room_screen.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/join_room_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import '../../../../helpers/go_router_test_helpers.dart';

class MockJoinRoomUseCase extends Mock implements JoinRoomUseCase {}

void main() {
  late MockJoinRoomUseCase mockJoinRoomUseCase;

  setUp(() {
    mockJoinRoomUseCase = MockJoinRoomUseCase();
  });

  void setLargeScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
  }

  Widget createWidgetUnderTest({
    List<Room>? rooms,
    Object? error,
    bool isLoading = false,
    String? userId,
  }) {
    return ProviderScope(
      overrides: [
        joinRoomUseCaseProvider.overrideWithValue(mockJoinRoomUseCase),
        currentUserIdProvider.overrideWithValue(userId),
        availableRoomsProvider.overrideWith((ref) async {
          if (isLoading) {
            await Completer<Never>().future;
            return [];
          } else if (error != null) {
            throw error;
          } else {
            return rooms ?? [];
          }
        }),
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const JoinRoomScreen(),
            ),
            GoRoute(
              path: '/room/:id',
              builder: (context, state) =>
                  Scaffold(body: Text('Room ${state.pathParameters['id']}')),
            ),
            GoRoute(
              path: '/create-room',
              builder: (context, state) =>
                  const Scaffold(body: Text('Create Room Screen')),
            ),
          ],
        ),
      ),
    );
  }

  Room createTestRoom({
    String id = 'room12345678',
    String creatorId = 'creator1',
    List<String> playerIds = const ['creator1'],
    RoomStatus status = RoomStatus.waiting,
    int maxPlayers = 4,
    DateTime? createdAt,
  }) {
    return Room(
      id: id,
      creatorId: creatorId,
      playerIds: playerIds,
      status: status,
      maxPlayers: maxPlayers,
      createdAt: createdAt,
    );
  }

  group('Room Discovery UI for Competitive Multiplayer Matchmaking', () {
    testWidgets(
      'should provide comprehensive competitive room discovery and joining experience for strategic multiplayer gaming',
      (WidgetTester tester) async {
        // Test behavior: screen enables complete competitive matchmaking workflow from discovery to participation

        setLargeScreenSize(tester);
        const competitivePlayerId = 'strategic-competitor-789';
        const strategicRoomId = 'tournament-arena-456';

        final availableCompetitiveRooms = [
          Room(
            id: strategicRoomId,
            creatorId: 'tournament-host-123',
            playerIds: ['tournament-host-123'],
            status: RoomStatus.waiting,
            maxPlayers: 4,
            createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          Room(
            id: 'tactical-room-789',
            creatorId: 'strategic-host-456',
            playerIds: ['strategic-host-456', 'competitive-player-111'],
            status: RoomStatus.waiting,
            maxPlayers: 6,
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
          Room(
            id: 'capacity-reached-room-999',
            creatorId: 'host-full-room',
            playerIds: ['host-full-room', 'player-1', 'player-2', 'player-3'],
            status: RoomStatus.waiting,
            maxPlayers: 4,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ];

        final joinedCompetitiveRoom = availableCompetitiveRooms[0].copyWith(
          playerIds: ['tournament-host-123', competitivePlayerId],
        );

        when(
          () => mockJoinRoomUseCase.call(
            roomId: strategicRoomId,
            playerId: competitivePlayerId,
          ),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return joinedCompetitiveRoom;
        });

        // Initial interface state - competitive room discovery
        await tester.pumpWidget(
          createWidgetUnderTest(
            rooms: availableCompetitiveRooms,
            userId: competitivePlayerId,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Rejoindre une partie'),
          findsOneWidget,
          reason: 'Should display competitive matchmaking header',
        );
        expect(
          find.byType(AppBar),
          findsOneWidget,
          reason:
              'Should provide navigation structure for competitive interface',
        );
        expect(
          find.byType(ListView),
          findsOneWidget,
          reason:
              'Should display competitive room listings for strategic selection',
        );
        expect(
          find.byType(Card),
          findsNWidgets(3),
          reason:
              'Should show all available competitive rooms as interactive cards',
        );
        expect(
          find.byType(RefreshIndicator),
          findsOneWidget,
          reason:
              'Should enable room list refresh for up-to-date competitive opportunities',
        );

        // Room information display behavior - enable strategic decision making
        expect(
          find.text('Partie #tourname'),
          findsOneWidget,
          reason: 'Should display first competitive room for identification',
        );
        expect(
          find.text('Partie #tactical'),
          findsOneWidget,
          reason:
              'Should display second competitive room with strategic context',
        );
        expect(
          find.text('Partie #capacity'),
          findsOneWidget,
          reason: 'Should display third competitive room at capacity',
        );
        expect(
          find.text('1/4 joueurs'),
          findsOneWidget,
          reason: 'Should show participant capacity for strategic planning',
        );
        expect(
          find.text('2/6 joueurs'),
          findsOneWidget,
          reason: 'Should display current competitive participation level',
        );
        expect(
          find.text('4/4 joueurs'),
          findsOneWidget,
          reason: 'Should indicate capacity-reached competitive rooms',
        );
        expect(
          find.textContaining('5 min'),
          findsOneWidget,
          reason: 'Should display room age for freshness assessment',
        );
        expect(
          find.textContaining('30 min'),
          findsOneWidget,
          reason: 'Should show time-based room information',
        );
        expect(
          find.textContaining('2 h'),
          findsOneWidget,
          reason: 'Should indicate longer-standing competitive opportunities',
        );

        // Icon-based visual coordination for competitive clarity
        expect(
          find.byIcon(Icons.groups),
          findsWidgets,
          reason:
              'Should use group icons for competitive participant visualization',
        );
        expect(
          find.byIcon(Icons.person),
          findsWidgets,
          reason:
              'Should display person icons for individual competitive context',
        );
        expect(
          find.byIcon(Icons.access_time),
          findsWidgets,
          reason: 'Should show time icons for competitive timeline awareness',
        );

        // Action availability behavior - enable competitive participation
        expect(
          find.text('Rejoindre'),
          findsNWidgets(2),
          reason: 'Should provide join actions for available competitive rooms',
        );
        expect(
          find.text('Complet'),
          findsOneWidget,
          reason:
              'Should indicate full competitive rooms to prevent joining attempts',
        );

        final fullRoomButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton).last,
        );
        expect(
          fullRoomButton.onPressed,
          isNull,
          reason:
              'Should disable join action for capacity-reached competitive rooms',
        );

        // Competitive room joining workflow behavior
        await tester.tap(find.text('Rejoindre').first);
        await tester.pump();

        // Loading state behavior during competitive coordination
        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
          reason:
              'Should display loading indicator during competitive room joining',
        );
        expect(
          find.text('Rejoindre'),
          findsOneWidget,
          reason: 'Should maintain interface consistency during processing',
        );

        await tester.pumpAndSettle();

        // Navigation behavior - transition to competitive environment
        expect(
          find.text('Room $strategicRoomId'),
          findsOneWidget,
          reason:
              'Should navigate to joined competitive room for gameplay coordination',
        );

        verify(
          () => mockJoinRoomUseCase.call(
            roomId: strategicRoomId,
            playerId: competitivePlayerId,
          ),
        ).called(1);
      },
    );

    group(
      'should handle competitive room discovery scenarios with appropriate user feedback',
      () {
        testWidgets('when loading competitive room listings', (
          WidgetTester tester,
        ) async {
          // Test behavior: screen provides loading feedback during competitive room discovery

          setLargeScreenSize(tester);

          await tester.pumpWidget(createWidgetUnderTest(isLoading: true));
          await tester.pump();

          expect(
            find.byType(CircularProgressIndicator),
            findsOneWidget,
            reason:
                'Should display loading indicator during competitive room discovery',
          );
        });

        testWidgets('when no competitive rooms are available for joining', (
          WidgetTester tester,
        ) async {
          // Test behavior: screen guides users to create competitive opportunities when none exist

          setLargeScreenSize(tester);

          await tester.pumpWidget(createWidgetUnderTest(rooms: []));
          await tester.pumpAndSettle();

          expect(
            find.text('Aucune partie disponible'),
            findsOneWidget,
            reason:
                'Should inform users about absence of competitive opportunities',
          );
          expect(
            find.text('Créez une nouvelle partie pour commencer'),
            findsOneWidget,
            reason: 'Should guide users toward creating competitive rooms',
          );
          expect(
            find.text('Créer une partie'),
            findsOneWidget,
            reason: 'Should provide competitive room creation action',
          );
          expect(
            find.byIcon(Icons.search_off),
            findsOneWidget,
            reason:
                'Should use appropriate icon for empty competitive discovery state',
          );
          expect(
            find.byIcon(Icons.add),
            findsOneWidget,
            reason:
                'Should display creation icon for competitive room establishment',
          );

          // Navigation to room creation behavior
          await tester.tap(find.text('Créer une partie'));
          await tester.pumpAndSettle();

          expect(
            find.text('Create Room Screen'),
            findsOneWidget,
            reason: 'Should navigate to competitive room creation interface',
          );
        });

        testWidgets('when competitive infrastructure encounters loading failures', (
          WidgetTester tester,
        ) async {
          // Test behavior: screen handles infrastructure failures gracefully for competitive continuity

          setLargeScreenSize(tester);
          const infrastructureError =
              'Competitive room infrastructure temporarily unavailable';

          await tester.pumpWidget(
            createWidgetUnderTest(error: Exception(infrastructureError)),
          );
          await tester.pumpAndSettle();

          expect(
            find.text('Erreur de chargement'),
            findsOneWidget,
            reason: 'Should display error header for infrastructure failures',
          );
          expect(
            find.text('Exception: $infrastructureError'),
            findsOneWidget,
            reason:
                'Should provide specific error information for troubleshooting',
          );
          expect(
            find.text('Réessayer'),
            findsOneWidget,
            reason: 'Should enable retry action for infrastructure recovery',
          );
          expect(
            find.byIcon(Icons.error_outline),
            findsOneWidget,
            reason:
                'Should use error icon for infrastructure failure indication',
          );
        });
      },
    );

    group('should handle competitive joining failures with proper user feedback', () {
      testWidgets('when user lacks authentication for competitive participation', (
        WidgetTester tester,
      ) async {
        // Test behavior: screen validates authentication for competitive room access

        setLargeScreenSize(tester);
        final competitiveRoom = createTestRoom(
          playerIds: ['creator1'],
          maxPlayers: 4,
        );

        await tester.pumpWidget(
          createWidgetUnderTest(rooms: [competitiveRoom], userId: null),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Rejoindre'));
        await tester.pump();
        await tester.pump();

        expect(
          find.text('Erreur: Exception: Utilisateur non connecté'),
          findsOneWidget,
          reason:
              'Should inform users about authentication requirement for competitive participation',
        );
        expect(
          find.byType(SnackBar),
          findsOneWidget,
          reason:
              'Should display authentication error via snackbar notification',
        );
      });

      testWidgets(
        'when competitive room joining encounters capacity or infrastructure issues',
        (WidgetTester tester) async {
          // Test behavior: screen handles joining failures gracefully to maintain competitive experience

          setLargeScreenSize(tester);
          const competitivePlayerId = 'strategic-competitor-789';
          const strategicRoomId = 'competitive-arena-456';
          const capacityError =
              'Competitive room capacity exceeded during joining attempt';

          final competitiveRoom = createTestRoom(
            id: strategicRoomId,
            playerIds: ['creator1'],
            maxPlayers: 4,
          );

          when(
            () => mockJoinRoomUseCase.call(
              roomId: strategicRoomId,
              playerId: competitivePlayerId,
            ),
          ).thenThrow(Exception(capacityError));

          await tester.pumpWidget(
            createWidgetUnderTest(
              rooms: [competitiveRoom],
              userId: competitivePlayerId,
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.text('Rejoindre'));
          await tester.pump();
          await tester.pump();

          expect(
            find.text('Erreur: Exception: $capacityError'),
            findsOneWidget,
            reason:
                'Should provide clear error feedback for competitive joining failures',
          );
          expect(
            find.byType(SnackBar),
            findsOneWidget,
            reason: 'Should display joining error via snackbar notification',
          );
        },
      );

      testWidgets('when competitive room joining returns unexpected results', (
        WidgetTester tester,
      ) async {
        // Test behavior: screen handles unexpected joining responses to maintain interface stability

        setLargeScreenSize(tester);
        const competitivePlayerId = 'strategic-competitor-789';
        const strategicRoomId = 'competitive-arena-456';

        final competitiveRoom = createTestRoom(
          id: strategicRoomId,
          playerIds: ['creator1'],
          maxPlayers: 4,
        );

        when(
          () => mockJoinRoomUseCase.call(
            roomId: strategicRoomId,
            playerId: competitivePlayerId,
          ),
        ).thenAnswer((_) async => null);

        await tester.pumpWidget(
          createWidgetUnderTest(
            rooms: [competitiveRoom],
            userId: competitivePlayerId,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Rejoindre'));
        await tester.pump();
        await tester.pumpAndSettle();

        expect(
          find.text('Room $strategicRoomId'),
          findsNothing,
          reason: 'Should not navigate when joining returns unexpected results',
        );
        expect(
          find.text('Rejoindre une partie'),
          findsOneWidget,
          reason:
              'Should maintain discovery interface when joining fails unexpectedly',
        );
      });
    });

    testWidgets(
      'should provide comprehensive time formatting for competitive room freshness assessment',
      (WidgetTester tester) async {
        // Test behavior: screen displays precise timing information for strategic competitive decision making

        setLargeScreenSize(tester);

        final competitiveRoomsWithVariedAges = [
          createTestRoom(
            id: 'fresh-room-12345',
            createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
          ),
          createTestRoom(
            id: 'recent-room-67890',
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
          createTestRoom(
            id: 'aged-room-11111',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          createTestRoom(
            id: 'old-room-22222',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          createTestRoom(id: 'undated-room-33333', createdAt: null),
        ];

        await tester.pumpWidget(
          createWidgetUnderTest(rooms: competitiveRoomsWithVariedAges),
        );
        await tester.pumpAndSettle();

        expect(
          find.textContaining('à l\'instant'),
          findsOneWidget,
          reason: 'Should display immediate timing for fresh competitive rooms',
        );
        expect(
          find.textContaining('30 min'),
          findsOneWidget,
          reason:
              'Should show minute-based timing for recent competitive opportunities',
        );
        expect(
          find.textContaining('2 h'),
          findsOneWidget,
          reason: 'Should display hour-based timing for aged competitive rooms',
        );
        expect(
          find.textContaining('1 j'),
          findsOneWidget,
          reason:
              'Should show day-based timing for long-standing competitive opportunities',
        );
        expect(
          find.text('Créée récemment'),
          findsOneWidget,
          reason:
              'Should handle missing timing data gracefully for competitive rooms',
        );
      },
    );

    testWidgets(
      'should maintain proper competitive styling and interface polish for strategic gaming',
      (WidgetTester tester) async {
        // Test behavior: screen provides polished interface suitable for competitive gaming discovery

        setLargeScreenSize(tester);
        final competitiveRoom = createTestRoom(id: 'styled-room-789');

        await tester.pumpWidget(
          createWidgetUnderTest(rooms: [competitiveRoom]),
        );
        await tester.pumpAndSettle();

        expect(
          find.byType(SafeArea),
          findsWidgets,
          reason:
              'Should respect device boundaries for competitive interface safety',
        );
        expect(
          find.byType(Card),
          findsOneWidget,
          reason:
              'Should use card layout for organized competitive room presentation',
        );
        expect(
          find.byType(ListTile),
          findsOneWidget,
          reason:
              'Should structure room information with proper competitive layout',
        );
        expect(
          find.byType(CircleAvatar),
          findsOneWidget,
          reason:
              'Should display room avatars for competitive visual identification',
        );

        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(
          listTile.contentPadding,
          const EdgeInsets.all(16),
          reason:
              'Should apply proper padding for competitive interface comfort',
        );

        // Pull-to-refresh capability for competitive room updates
        await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      },
    );
  });
}
