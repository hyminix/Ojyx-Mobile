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
    String id = 'room123',
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
            return Stream.value(room ?? createTestRoom());
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

  group('RoomLobbyScreen', () {
    const testRoomId = 'room123';

    testWidgets('should display app bar with correct title', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom();

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'user123',
        ),
      );

      // Assert
      expect(find.text('Salle d\'attente'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should show loading state', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          isLoading: true,
          currentUserId: 'user123',
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error state', (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Room not found';

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          error: Exception(errorMessage),
          currentUserId: 'user123',
        ),
      );

      // Assert
      expect(find.text('Erreur: Exception: $errorMessage'), findsOneWidget);
      expect(find.text('Retour à l\'accueil'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display room information correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        id: 'room123456789',
        status: RoomStatus.waiting,
        playerIds: ['creator1', 'player2'],
        maxPlayers: 4,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'creator1',
        ),
      );

      // Assert
      expect(find.text('Partie #room1234'), findsOneWidget);
      expect(find.text('En attente'), findsOneWidget);
      expect(find.text('Joueurs'), findsOneWidget);
      expect(find.text('2/4'), findsOneWidget);
      expect(find.byIcon(Icons.meeting_room), findsOneWidget);
    });

    testWidgets('should display players list correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1', 'player2'],
        maxPlayers: 4,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'player2',
        ),
      );

      // Assert
      expect(find.text('Joueur 1'), findsOneWidget);
      expect(find.text('Vous'), findsOneWidget);
      expect(find.text('En attente...'), findsNWidgets(2)); // 2 empty slots
      expect(find.text('Créateur'), findsOneWidget);
      expect(find.text('Joueur'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget); // Host icon
      expect(find.byIcon(Icons.person), findsOneWidget); // Player icon
      expect(
        find.byIcon(Icons.person_outline),
        findsNWidgets(2),
      ); // Empty slots
    });

    testWidgets('should show start button for creator when can start', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1', 'player2'],
        maxPlayers: 4,
        status: RoomStatus.waiting,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'creator1',
        ),
      );

      // Assert
      expect(find.text('Lancer la partie'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should disable start button when not enough players', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1'], // Only 1 player
        maxPlayers: 4,
        status: RoomStatus.waiting,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'creator1',
        ),
      );

      // Assert
      expect(find.text('En attente de joueurs (minimum 2)'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should show waiting message for non-creator', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1', 'player2'],
        maxPlayers: 4,
        status: RoomStatus.waiting,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'player2',
        ),
      );

      // Assert
      expect(find.text('En attente du créateur...'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Lancer la partie'), findsNothing);
    });

    testWidgets('should start game when button pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1', 'player2'],
        maxPlayers: 4,
        status: RoomStatus.waiting,
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'creator1',
        ),
      );

      // Act
      await tester.tap(find.text('Lancer la partie'));
      await tester.pumpAndSettle();

      // Assert - should navigate to game screen
      expect(find.text('Game $testRoomId'), findsOneWidget);
    });

    testWidgets('should leave room when back button pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      const currentUserId = 'player2';
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1', currentUserId],
        maxPlayers: 4,
      );

      when(
        () => mockRoomRepository.leaveRoom(
          roomId: testRoomId,
          playerId: currentUserId,
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: currentUserId,
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockRoomRepository.leaveRoom(
          roomId: testRoomId,
          playerId: currentUserId,
        ),
      ).called(1);

      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('should handle back button without user ID', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom();

      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: null,
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - should still navigate but not call leaveRoom
      verifyNever(
        () => mockRoomRepository.leaveRoom(
          roomId: any(named: 'roomId'),
          playerId: any(named: 'playerId'),
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('should display correct status colors and text', (
      WidgetTester tester,
    ) async {
      // Test different room statuses
      final statusTests = [
        (RoomStatus.waiting, 'En attente'),
        (RoomStatus.inGame, 'En cours'),
        (RoomStatus.finished, 'Terminée'),
        (RoomStatus.cancelled, 'Annulée'),
      ];

      for (final (status, expectedText) in statusTests) {
        final room = createTestRoom(status: status);

        await tester.pumpWidget(
          createWidgetUnderTest(
            roomId: testRoomId,
            room: room,
            currentUserId: 'creator1',
          ),
        );

        expect(find.text(expectedText), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should not show start button for non-waiting rooms', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1', 'player2'],
        status: RoomStatus.inGame,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'creator1',
        ),
      );

      // Assert
      expect(find.text('Lancer la partie'), findsNothing);
      expect(find.text('En attente du créateur...'), findsNothing);
    });

    testWidgets('should highlight current user correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['creator1', 'player2'],
        maxPlayers: 4,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'player2',
        ),
      );

      // Assert
      expect(find.text('Vous'), findsOneWidget);
      expect(
        find.text('Joueur 1'),
        findsOneWidget,
      ); // Creator shown as Joueur 1

      // Check that current user has different styling
      final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
      final currentUserTile = listTiles.firstWhere(
        (tile) => (tile.title as Text).data == 'Vous',
      );
      final titleStyle = (currentUserTile.title as Text).style;
      expect(titleStyle?.fontWeight, FontWeight.bold);
    });

    testWidgets('should handle max players correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final room = createTestRoom(
        playerIds: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6'],
        maxPlayers: 6,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'p3',
        ),
      );

      // Assert
      expect(find.text('6/6'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(6)); // Exactly 6 tiles
      expect(find.text('En attente...'), findsNothing); // No empty slots
    });

    testWidgets('should apply correct styling', (WidgetTester tester) async {
      // Arrange
      final room = createTestRoom();

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'creator1',
        ),
      );

      // Assert
      expect(find.byType(SafeArea), findsOneWidget);
      expect(
        find.byType(Card),
        findsNWidgets(2),
      ); // Room info card + players card
      expect(find.byType(CircleAvatar), findsAtLeastNWidgets(1));

      // Check proper padding
      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(SafeArea),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(padding.padding, const EdgeInsets.all(24.0));
    });

    testWidgets('should navigate to home on error button press', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          error: Exception('Test error'),
          currentUserId: 'user123',
        ),
      );

      // Act
      await tester.tap(find.text('Retour à l\'accueil'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('should disable start for too many players', (
      WidgetTester tester,
    ) async {
      // Arrange - Test with 9 players (over the limit of 8)
      final room = createTestRoom(
        creatorId: 'creator1',
        playerIds: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8', 'p9'],
        maxPlayers: 10,
        status: RoomStatus.waiting,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomId: testRoomId,
          room: room,
          currentUserId: 'creator1',
        ),
      );

      // Assert - should be disabled due to too many players (>8)
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}
