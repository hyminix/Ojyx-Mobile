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

  group('JoinRoomScreen', () {
    testWidgets('should display app bar', (WidgetTester tester) async {
      setLargeScreenSize(tester);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Rejoindre une partie'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Act
      await tester.pumpWidget(createWidgetUnderTest(isLoading: true));
      await tester.pump(); // Don't use pumpAndSettle for loading state

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty state when no rooms available', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Act
      await tester.pumpWidget(createWidgetUnderTest(rooms: []));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Aucune partie disponible'), findsOneWidget);
      expect(
        find.text('Créez une nouvelle partie pour commencer'),
        findsOneWidget,
      );
      expect(find.text('Créer une partie'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets(
      'should navigate to create room when button pressed in empty state',
      (WidgetTester tester) async {
        setLargeScreenSize(tester);

        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(rooms: []));
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text('Créer une partie'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Create Room Screen'), findsOneWidget);
      },
    );

    testWidgets('should show error state when loading fails', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      const errorMessage = 'Network error';

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(error: Exception(errorMessage)),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur de chargement'), findsOneWidget);
      expect(find.text('Exception: $errorMessage'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display list of available rooms', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      final rooms = [
        createTestRoom(id: 'room1234567890', playerIds: ['creator1']),
        createTestRoom(
          id: 'room2234567890',
          playerIds: ['creator2', 'player2'],
          maxPlayers: 6,
        ),
      ];

      // Act
      await tester.pumpWidget(createWidgetUnderTest(rooms: rooms));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('Partie #room1234'), findsOneWidget);
      expect(find.text('Partie #room2234'), findsOneWidget);
    });

    testWidgets('should show room details correctly', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      final room = createTestRoom(
        id: 'room123456789',
        playerIds: ['creator1', 'player2'],
        maxPlayers: 4,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(rooms: [room]));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Partie #room1234'), findsOneWidget);
      expect(find.text('2/4 joueurs'), findsOneWidget);
      expect(find.textContaining('5 min'), findsOneWidget);
      expect(find.byIcon(Icons.groups), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('should show join button for available rooms', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      final room = createTestRoom(playerIds: ['creator1'], maxPlayers: 4);

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(rooms: [room], userId: 'user123'),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Rejoindre'), findsOneWidget);
    });

    testWidgets('should show full status for full rooms', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      final room = createTestRoom(
        playerIds: ['creator1', 'player2', 'player3', 'player4'],
        maxPlayers: 4,
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(rooms: [room], userId: 'user123'),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Complet'), findsOneWidget);
      expect(find.text('Rejoindre'), findsNothing);

      // Check that button is disabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should join room successfully', (WidgetTester tester) async {
      setLargeScreenSize(tester);

      // Arrange
      const userId = 'user123';
      const roomId = 'room12345678';
      final room = createTestRoom(
        id: roomId,
        playerIds: ['creator1'],
        maxPlayers: 4,
      );
      final joinedRoom = createTestRoom(
        id: roomId,
        playerIds: ['creator1', userId],
        maxPlayers: 4,
      );

      when(
        () => mockJoinRoomUseCase.call(roomId: roomId, playerId: userId),
      ).thenAnswer((_) async => joinedRoom);

      await tester.pumpWidget(
        createWidgetUnderTest(rooms: [room], userId: userId),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Rejoindre'));
      await tester.pump();
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockJoinRoomUseCase.call(roomId: roomId, playerId: userId),
      ).called(1);

      // Verify navigation occurred
      expect(find.text('Room $roomId'), findsOneWidget);
    });

    testWidgets('should show loading state during join', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      const userId = 'user123';
      const roomId = 'room12345678';
      final room = createTestRoom(
        id: roomId,
        playerIds: ['creator1'],
        maxPlayers: 4,
      );
      final joinedRoom = createTestRoom(
        id: roomId,
        playerIds: ['creator1', userId],
        maxPlayers: 4,
      );

      when(
        () => mockJoinRoomUseCase.call(roomId: roomId, playerId: userId),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return joinedRoom;
      });

      await tester.pumpWidget(
        createWidgetUnderTest(rooms: [room], userId: userId),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Rejoindre'));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Rejoindre'), findsNothing);

      // Wait for completion
      await tester.pumpAndSettle();
    });

    testWidgets('should show error when user not logged in', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      final room = createTestRoom(playerIds: ['creator1'], maxPlayers: 4);

      await tester.pumpWidget(
        createWidgetUnderTest(rooms: [room], userId: null),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Rejoindre'));
      await tester.pump();
      await tester.pump(); // Allow snackbar to appear

      // Assert
      expect(
        find.text('Erreur: Exception: Utilisateur non connecté'),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should show error when join fails', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      const userId = 'user123';
      const roomId = 'room12345678';
      const errorMessage = 'Room is full';
      final room = createTestRoom(
        id: roomId,
        playerIds: ['creator1'],
        maxPlayers: 4,
      );

      when(
        () => mockJoinRoomUseCase.call(roomId: roomId, playerId: userId),
      ).thenThrow(Exception(errorMessage));

      await tester.pumpWidget(
        createWidgetUnderTest(rooms: [room], userId: userId),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Rejoindre'));
      await tester.pump();
      await tester.pump(); // Allow snackbar to appear

      // Assert
      expect(find.text('Erreur: Exception: $errorMessage'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should handle null result from join room', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange
      const userId = 'user123';
      const roomId = 'room12345678';
      final room = createTestRoom(
        id: roomId,
        playerIds: ['creator1'],
        maxPlayers: 4,
      );

      when(
        () => mockJoinRoomUseCase.call(roomId: roomId, playerId: userId),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(
        createWidgetUnderTest(rooms: [room], userId: userId),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Rejoindre'));
      await tester.pump();
      await tester.pumpAndSettle();

      // Assert - should not navigate
      expect(find.text('Room $roomId'), findsNothing);
      expect(
        find.text('Rejoindre une partie'),
        findsOneWidget,
      ); // Still on join screen
    });

    testWidgets('should display time formatting correctly', (
      WidgetTester tester,
    ) async {
      setLargeScreenSize(tester);

      // Arrange - Test various time formats
      final rooms = [
        createTestRoom(
          id: 'room1234567890',
          createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
        ),
        createTestRoom(
          id: 'room2234567890',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        createTestRoom(
          id: 'room3234567890',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        createTestRoom(
          id: 'room4234567890',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      // Act
      await tester.pumpWidget(createWidgetUnderTest(rooms: rooms));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('à l\'instant'), findsOneWidget);
      expect(find.textContaining('30 min'), findsOneWidget);
      expect(find.textContaining('2 h'), findsOneWidget);
      expect(find.textContaining('1 j'), findsOneWidget);
    });

    testWidgets('should handle null created time', (WidgetTester tester) async {
      setLargeScreenSize(tester);

      // Arrange
      final room = createTestRoom(id: 'room12345678', createdAt: null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest(rooms: [room]));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Créée récemment'), findsOneWidget);
    });

    testWidgets('should support pull to refresh', (WidgetTester tester) async {
      setLargeScreenSize(tester);

      // Arrange
      final rooms = [createTestRoom(id: 'room12345678')];

      await tester.pumpWidget(createWidgetUnderTest(rooms: rooms));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Act & Assert
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Simulate pull to refresh
      await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('should apply correct styling', (WidgetTester tester) async {
      setLargeScreenSize(tester);

      // Arrange
      final room = createTestRoom(id: 'room12345678');

      // Act
      await tester.pumpWidget(createWidgetUnderTest(rooms: [room]));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SafeArea), findsWidgets);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.contentPadding, const EdgeInsets.all(16));
    });
  });
}
