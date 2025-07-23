import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/room_lobby_screen.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
  });

  Widget createWidgetUnderTest({
    required String roomId,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        currentUserIdProvider.overrideWithValue('test-user-id'),
        ...overrides,
      ],
      child: MaterialApp.router(
        routerConfig: mockRouter,
      ),
    );
  }

  group('RoomLobbyScreen', () {
    testWidgets('should display room information', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final room = Room(
        id: 'room-123',
        creatorId: 'test-user-id',
        playerIds: ['test-user-id', 'user-2'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Salle d\'attente'), findsOneWidget);
      expect(find.text('Code de la partie: room-123'), findsOneWidget);
      expect(find.text('2/4 joueurs'), findsOneWidget);
    });

    testWidgets('should display player list', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final room = Room(
        id: 'room-123',
        creatorId: 'test-user-id',
        playerIds: ['test-user-id', 'user-2', 'user-3'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Joueurs (3/4)'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNWidgets(3));
      expect(find.byIcon(Icons.star), findsOneWidget); // Host icon
    });

    testWidgets('should show start button for room creator', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final room = Room(
        id: 'room-123',
        creatorId: 'test-user-id',
        playerIds: ['test-user-id', 'user-2'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Démarrer la partie'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('should not show start button for non-creator', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final room = Room(
        id: 'room-123',
        creatorId: 'other-user-id',
        playerIds: ['other-user-id', 'test-user-id'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Démarrer la partie'), findsNothing);
      expect(find.text('En attente du créateur'), findsOneWidget);
    });

    testWidgets('should disable start button if not enough players', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final room = Room(
        id: 'room-123',
        creatorId: 'test-user-id',
        playerIds: ['test-user-id'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Démarrer la partie'),
      );
      expect(button.onPressed, isNull);
      expect(find.text('Minimum 2 joueurs'), findsOneWidget);
    });

    testWidgets('should navigate to game screen when game starts', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());
      when(() => mockRouter.go(any())).thenReturn(null);

      final room = Room(
        id: 'room-123',
        creatorId: 'test-user-id',
        playerIds: ['test-user-id', 'user-2'],
        status: RoomStatus.inGame,
        maxPlayers: 4,
        createdAt: DateTime.now(),
        currentGameId: 'game-123',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockRouter.go('/game/room-123')).called(1);
    });

    testWidgets('should show leave button', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final room = Room(
        id: 'room-123',
        creatorId: 'other-user-id',
        playerIds: ['other-user-id', 'test-user-id'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Quitter'), findsOneWidget);
      expect(find.byIcon(Icons.exit_to_app), findsOneWidget);
    });

    testWidgets('should show loading state', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => const Stream.empty()),
        ],
      ));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error state', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.error('Room not found')),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur'), findsOneWidget);
      expect(find.text('Room not found'), findsOneWidget);
    });

    testWidgets('should copy room code to clipboard', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final room = Room(
        id: 'room-123',
        creatorId: 'test-user-id',
        playerIds: ['test-user-id'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        roomId: 'room-123',
        overrides: [
          watchRoomProvider('room-123').overrideWith(() => Stream.value(room)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.copy), findsOneWidget);
    });
  });
}

// Mock classes for GoRouter
class MockRouterDelegate extends Mock implements RouterDelegate<Object> {}
class MockRouteInformationParser extends Mock implements RouteInformationParser<Object> {}
class MockRouteInformationProvider extends Mock implements RouteInformationProvider {}