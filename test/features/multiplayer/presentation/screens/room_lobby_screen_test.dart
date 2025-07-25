import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/room_lobby_screen.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  late MockRoomRepository mockRoomRepository;

  setUp(() {
    mockRoomRepository = MockRoomRepository();
    registerFallbackValue(RoomStatus.waiting);
  });

  void setLargeScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
  }

  Room createTestRoom({
    String id = 'room12345678',
    String creatorId = 'creator1',
    List<String> playerIds = const ['creator1'],
    RoomStatus status = RoomStatus.waiting,
    int maxPlayers = 4,
  }) {
    return Room(
      id: id,
      creatorId: creatorId,
      playerIds: playerIds,
      status: status,
      maxPlayers: maxPlayers,
    );
  }

  Widget createWidgetUnderTest({
    required String roomId,
    Room? room,
    Object? error,
    bool isLoading = false,
    String? currentUserId,
  }) {
    return ProviderScope(
      overrides: [
        roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        currentUserIdProvider.overrideWithValue(currentUserId),
        currentRoomProvider(roomId).overrideWith((ref) {
          if (isLoading) {
            return const Stream.empty();
          } else if (error != null) {
            return Stream.error(error);
          } else if (room != null) {
            return Stream.value(room);
          } else {
            return Stream.value(createTestRoom());
          }
        }),
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  const Scaffold(body: Text('Home Screen')),
            ),
            GoRoute(
              path: '/room/:id',
              builder: (context, state) =>
                  RoomLobbyScreen(roomId: state.pathParameters['id']!),
            ),
            GoRoute(
              path: '/game/:id',
              builder: (context, state) =>
                  Scaffold(body: Text('Game ${state.pathParameters['id']}')),
            ),
          ],
          initialLocation: '/room/$roomId',
        ),
      ),
    );
  }

  group('Competitive Room Lobby for Strategic Multiplayer Gaming Coordination', () {
    const testRoomId = 'room12345678';

    testWidgets(
      'should provide comprehensive competitive room lobby experience for strategic multiplayer gaming preparation',
      (WidgetTester tester) async {
        // Test behavior: lobby provides complete competitive room management for strategic gaming coordination

        setLargeScreenSize(tester);
        const competitiveHostId = 'tournament-organizer-789';
        const strategicParticipantId = 'competitive-player-456';

        final competitiveRoomWaiting = const Room(
          id: testRoomId,
          creatorId: competitiveHostId,
          playerIds: [competitiveHostId, strategicParticipantId],
          status: RoomStatus.waiting,
          maxPlayers: 4,
        );

        final competitiveRoomReadyToStart = competitiveRoomWaiting.copyWith(
          playerIds: [
            competitiveHostId,
            strategicParticipantId,
            'strategic-competitor-111',
          ],
        );

        when(
          () => mockRoomRepository.leaveRoom(
            roomId: testRoomId,
            playerId: strategicParticipantId,
          ),
        ).thenAnswer((_) async {});

        // Room information display behavior - competitive context awareness
        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            room: competitiveRoomWaiting,
            currentUserId: strategicParticipantId,
          ),
        );
        await tester.pump();

        expect(
          find.text('Salle d\'attente'),
          findsOneWidget,
          reason: 'Should display competitive lobby header',
        );
        expect(
          find.byType(AppBar),
          findsOneWidget,
          reason:
              'Should provide navigation structure for competitive interface',
        );
        expect(
          find.byIcon(Icons.arrow_back),
          findsOneWidget,
          reason: 'Should enable competitive room exit',
        );
        expect(
          find.text('Partie #room1234'),
          findsOneWidget,
          reason: 'Should display competitive room identification',
        );
        expect(
          find.text('En attente'),
          findsOneWidget,
          reason: 'Should indicate competitive room status',
        );
        expect(
          find.text('Joueurs'),
          findsOneWidget,
          reason: 'Should provide competitive participant section',
        );
        expect(
          find.text('2/4'),
          findsOneWidget,
          reason:
              'Should show competitive participant count for strategic planning',
        );
        expect(
          find.byIcon(Icons.meeting_room),
          findsOneWidget,
          reason: 'Should use room icon for competitive context',
        );

        // Competitive participant display behavior - enable strategic awareness
        expect(
          find.text('Joueur 1'),
          findsOneWidget,
          reason: 'Should display host as first competitive participant',
        );
        expect(
          find.text('Vous'),
          findsOneWidget,
          reason: 'Should identify current user in competitive roster',
        );
        expect(
          find.text('En attente...'),
          findsNWidgets(2),
          reason: 'Should indicate available competitive slots',
        );
        expect(
          find.text('Créateur'),
          findsOneWidget,
          reason: 'Should identify competitive room host',
        );
        expect(
          find.text('Joueur'),
          findsOneWidget,
          reason: 'Should identify competitive participants',
        );
        expect(
          find.byIcon(Icons.star),
          findsOneWidget,
          reason: 'Should display host authority icon for competitive control',
        );
        expect(
          find.byIcon(Icons.person),
          findsOneWidget,
          reason: 'Should show participant icon for competitive identification',
        );
        expect(
          find.byIcon(Icons.person_outline),
          findsNWidgets(2),
          reason: 'Should indicate empty competitive slots',
        );

        // Participant state management behavior - competitive coordination
        expect(
          find.text('En attente du créateur...'),
          findsOneWidget,
          reason:
              'Should inform participants about competitive game launch dependency',
        );
        expect(
          find.byType(LinearProgressIndicator),
          findsOneWidget,
          reason:
              'Should display waiting indicator for competitive coordination',
        );
        expect(
          find.text('Lancer la partie'),
          findsNothing,
          reason:
              'Should hide game launch action for non-host competitive participants',
        );

        // Competitive room exit behavior - participant management
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        verify(
          () => mockRoomRepository.leaveRoom(
            roomId: testRoomId,
            playerId: strategicParticipantId,
          ),
        ).called(1);
        expect(
          find.text('Home Screen'),
          findsOneWidget,
          reason: 'Should navigate to home after competitive room exit',
        );
      },
    );

    group('should handle competitive host controls for strategic game management', () {
      testWidgets(
        'when sufficient participants are available for competitive launch',
        (WidgetTester tester) async {
          // Test behavior: host can launch competitive games when strategic conditions are met

          setLargeScreenSize(tester);
          const competitiveHostId = 'tournament-organizer-789';

          final readyCompetitiveRoom = const Room(
            id: testRoomId,
            creatorId: competitiveHostId,
            playerIds: [competitiveHostId, 'strategic-competitor-123'],
            status: RoomStatus.waiting,
            maxPlayers: 4,
          );

          await tester.pumpWidget(
            createWidgetUnderTest(
              roomId: testRoomId,
              room: readyCompetitiveRoom,
              currentUserId: competitiveHostId,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pump();

          expect(
            find.text('Lancer la partie'),
            findsOneWidget,
            reason: 'Should provide competitive game launch action for host',
          );
          expect(
            find.byIcon(Icons.play_arrow),
            findsOneWidget,
            reason: 'Should display launch icon for competitive game start',
          );

          // Competitive game launch behavior
          await tester.tap(find.text('Lancer la partie'));
          await tester.pumpAndSettle();

          expect(
            find.text('Game $testRoomId'),
            findsOneWidget,
            reason: 'Should navigate to competitive game interface',
          );
        },
      );

      testWidgets('when insufficient participants prevent competitive launch', (
        WidgetTester tester,
      ) async {
        // Test behavior: host receives clear feedback about competitive launch constraints

        setLargeScreenSize(tester);
        const competitiveHostId = 'tournament-organizer-789';

        final insufficientCompetitiveRoom = const Room(
          id: testRoomId,
          creatorId: competitiveHostId,
          playerIds: [competitiveHostId],
          status: RoomStatus.waiting,
          maxPlayers: 4,
        );

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            room: insufficientCompetitiveRoom,
            currentUserId: competitiveHostId,
          ),
        );
        await tester.pump();

        expect(
          find.text('En attente de joueurs (minimum 2)'),
          findsOneWidget,
          reason:
              'Should inform host about competitive participant requirements',
        );
        expect(
          find.text('Lancer la partie'),
          findsNothing,
          reason:
              'Should hide launch action when competitive requirements unmet',
        );
      });

      testWidgets('when excessive participants exceed competitive balance limits', (
        WidgetTester tester,
      ) async {
        // Test behavior: host receives feedback about competitive balance constraints

        setLargeScreenSize(tester);
        const competitiveHostId = 'tournament-organizer-789';

        final excessiveCompetitiveRoom = const Room(
          id: testRoomId,
          creatorId: competitiveHostId,
          playerIds: [
            competitiveHostId,
            'p2',
            'p3',
            'p4',
            'p5',
            'p6',
            'p7',
            'p8',
            'p9',
          ],
          status: RoomStatus.waiting,
          maxPlayers: 10,
        );

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            room: excessiveCompetitiveRoom,
            currentUserId: competitiveHostId,
          ),
        );
        await tester.pump();

        expect(
          find.text('En attente de joueurs (minimum 2)'),
          findsOneWidget,
          reason:
              'Should indicate competitive constraints when participant count exceeds strategic balance',
        );
      });
    });

    group(
      'should display accurate competitive room status information for strategic awareness',
      () {
        testWidgets('across all competitive room states', (
          WidgetTester tester,
        ) async {
          // Test behavior: lobby displays precise status information for competitive gaming coordination

          setLargeScreenSize(tester);

          final competitiveStatusTests = [
            (RoomStatus.waiting, 'En attente'),
            (RoomStatus.inGame, 'En cours'),
            (RoomStatus.finished, 'Terminée'),
            (RoomStatus.cancelled, 'Annulée'),
          ];

          for (final (status, expectedText) in competitiveStatusTests) {
            final competitiveRoom = createTestRoom(status: status);

            await tester.pumpWidget(
              createWidgetUnderTest(
                roomId: testRoomId,
                room: competitiveRoom,
                currentUserId: 'creator1',
              ),
            );
            await tester.pump();

            expect(
              find.text(expectedText),
              findsOneWidget,
              reason:
                  'Should display accurate competitive status: $expectedText',
            );

            await tester.pumpWidget(Container());
          }
        });

        testWidgets('for maximum competitive capacity scenarios', (
          WidgetTester tester,
        ) async {
          // Test behavior: lobby handles maximum competitive capacity display accurately

          setLargeScreenSize(tester);

          final maxCapacityCompetitiveRoom = const Room(
            id: testRoomId,
            creatorId: 'creator1',
            playerIds: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6'],
            status: RoomStatus.waiting,
            maxPlayers: 6,
          );

          await tester.pumpWidget(
            createWidgetUnderTest(
              roomId: testRoomId,
              room: maxCapacityCompetitiveRoom,
              currentUserId: 'p3',
            ),
          );
          await tester.pump();

          expect(
            find.text('6/6'),
            findsOneWidget,
            reason: 'Should display accurate maximum competitive capacity',
          );
          expect(
            find.byType(ListTile),
            findsNWidgets(6),
            reason: 'Should show exactly maximum competitive participants',
          );
          expect(
            find.text('En attente...'),
            findsNothing,
            reason:
                'Should not show empty slots when competitive capacity reached',
          );
        });
      },
    );

    group('should handle competitive lobby errors and edge cases gracefully', () {
      testWidgets('when competitive room data loading fails', (
        WidgetTester tester,
      ) async {
        // Test behavior: lobby provides clear error feedback for competitive infrastructure issues

        setLargeScreenSize(tester);

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            isLoading: true,
            currentUserId: 'user123',
          ),
        );
        await tester.pump();

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
          reason:
              'Should display loading indicator during competitive room data retrieval',
        );
      });

      testWidgets('when competitive room infrastructure encounters errors', (
        WidgetTester tester,
      ) async {
        // Test behavior: lobby handles infrastructure failures with appropriate user guidance

        setLargeScreenSize(tester);
        const infrastructureError =
            'Competitive room infrastructure temporarily unavailable';

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            error: Exception(infrastructureError),
            currentUserId: 'user123',
          ),
        );
        await tester.pump();

        expect(
          find.text('Erreur: Exception: $infrastructureError'),
          findsOneWidget,
          reason:
              'Should display specific competitive infrastructure error information',
        );
        expect(
          find.text('Retour à l\'accueil'),
          findsOneWidget,
          reason:
              'Should provide navigation option for competitive error recovery',
        );
        expect(
          find.byIcon(Icons.error_outline),
          findsOneWidget,
          reason:
              'Should use error icon for competitive infrastructure failure indication',
        );

        await tester.tap(find.text('Retour à l\'accueil'));
        await tester.pumpAndSettle();

        expect(
          find.text('Home Screen'),
          findsOneWidget,
          reason: 'Should navigate to home for competitive error recovery',
        );
      });

      testWidgets('when anonymous users participate in competitive rooms', (
        WidgetTester tester,
      ) async {
        // Test behavior: lobby handles anonymous competitive participation gracefully

        setLargeScreenSize(tester);
        final competitiveRoom = createTestRoom();

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            room: competitiveRoom,
            currentUserId: null,
          ),
        );
        await tester.pump();

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        verifyNever(
          () => mockRoomRepository.leaveRoom(
            roomId: any(named: 'roomId'),
            playerId: any(named: 'playerId'),
          ),
        );
        expect(
          find.text('Home Screen'),
          findsOneWidget,
          reason:
              'Should handle anonymous competitive room exit without repository calls',
        );
      });
    });

    group('should prevent competitive actions for inappropriate room states', () {
      testWidgets('when competitive room is already in active game state', (
        WidgetTester tester,
      ) async {
        // Test behavior: lobby prevents inappropriate actions for ongoing competitive games

        setLargeScreenSize(tester);

        final activeCompetitiveRoom = const Room(
          id: testRoomId,
          creatorId: 'creator1',
          playerIds: ['creator1', 'player2'],
          status: RoomStatus.inGame,
          maxPlayers: 4,
        );

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            room: activeCompetitiveRoom,
            currentUserId: 'creator1',
          ),
        );
        await tester.pump();

        expect(
          find.text('Lancer la partie'),
          findsNothing,
          reason: 'Should not show launch action for active competitive games',
        );
        expect(
          find.text('En attente du créateur...'),
          findsNothing,
          reason:
              'Should not show waiting message for active competitive games',
        );
      });
    });

    testWidgets(
      'should maintain proper competitive styling and user identification for strategic gaming interface',
      (WidgetTester tester) async {
        // Test behavior: lobby provides polished interface suitable for competitive gaming coordination

        setLargeScreenSize(tester);

        final styledCompetitiveRoom = const Room(
          id: testRoomId,
          creatorId: 'creator1',
          playerIds: ['creator1', 'player2'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
        );

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            room: styledCompetitiveRoom,
            currentUserId: 'player2',
          ),
        );
        await tester.pump();

        expect(
          find.byType(SafeArea),
          findsWidgets,
          reason:
              'Should respect device boundaries for competitive interface safety',
        );
        expect(
          find.byType(Card),
          findsNWidgets(2),
          reason:
              'Should use card layout for organized competitive information presentation',
        );
        expect(
          find.byType(CircleAvatar),
          findsAtLeastNWidgets(1),
          reason:
              'Should display participant avatars for competitive visual identification',
        );

        // Current user highlighting behavior for competitive awareness
        expect(
          find.text('Vous'),
          findsOneWidget,
          reason: 'Should clearly identify current competitive participant',
        );
        expect(
          find.text('Joueur 1'),
          findsOneWidget,
          reason:
              'Should identify other competitive participants appropriately',
        );

        final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
        final currentUserTile = listTiles.firstWhere(
          (tile) => (tile.title as Text).data == 'Vous',
        );
        final titleStyle = (currentUserTile.title as Text).style;
        expect(
          titleStyle?.fontWeight,
          FontWeight.bold,
          reason:
              'Should highlight current competitive participant with bold styling',
        );

        // Proper spacing for competitive interface comfort
        final paddings = tester.widgetList<Padding>(
          find.descendant(
            of: find.byType(SafeArea),
            matching: find.byType(Padding),
          ),
        );
        final hasPadding24 = paddings.any(
          (p) => p.padding == const EdgeInsets.all(24.0),
        );
        expect(
          hasPadding24,
          isTrue,
          reason:
              'Should apply proper padding for competitive interface comfort',
        );
      },
    );
  });
}
