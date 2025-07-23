import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/join_room_screen.dart';
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

  group('JoinRoomScreen', () {
    testWidgets('should display available rooms list', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final rooms = [
        Room(
          id: 'room-1',
          creatorId: 'user-1',
          playerIds: ['user-1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          createdAt: DateTime.now(),
        ),
        Room(
          id: 'room-2',
          creatorId: 'user-2',
          playerIds: ['user-2', 'user-3'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
          createdAt: DateTime.now(),
        ),
      ];

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          availableRoomsProvider.overrideWith(() => Stream.value(rooms)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Rejoindre une partie'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Partie #1'), findsOneWidget);
      expect(find.text('Partie #2'), findsOneWidget);
      expect(find.text('1/4 joueurs'), findsOneWidget);
      expect(find.text('2/6 joueurs'), findsOneWidget);
    });

    testWidgets('should show empty state when no rooms available', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          availableRoomsProvider.overrideWith(() => Stream.value([])),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Aucune partie disponible'), findsOneWidget);
      expect(find.text('Créez une nouvelle partie ou attendez qu\'une partie soit créée'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('should show loading indicator while fetching rooms', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          availableRoomsProvider.overrideWith(() => const Stream.empty()),
        ],
      ));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error when fetching rooms fails', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          availableRoomsProvider.overrideWith(() => Stream.error('Network error')),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur'), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('should navigate to room lobby when room is tapped', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());
      when(() => mockRouter.go(any())).thenReturn(null);

      final rooms = [
        Room(
          id: 'room-1',
          creatorId: 'user-1',
          playerIds: ['user-1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          createdAt: DateTime.now(),
        ),
      ];

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          availableRoomsProvider.overrideWith(() => Stream.value(rooms)),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rejoindre'));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockRouter.go('/room/room-1')).called(1);
    });

    testWidgets('should disable join button for full rooms', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final rooms = [
        Room(
          id: 'room-1',
          creatorId: 'user-1',
          playerIds: ['user-1', 'user-2'],
          status: RoomStatus.waiting,
          maxPlayers: 2,
          createdAt: DateTime.now(),
        ),
      ];

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          availableRoomsProvider.overrideWith(() => Stream.value(rooms)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Complet'), findsOneWidget);
      final button = tester.widget<OutlinedButton>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(OutlinedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('should show room status correctly', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final rooms = [
        Room(
          id: 'room-1',
          creatorId: 'user-1',
          playerIds: ['user-1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          createdAt: DateTime.now(),
        ),
        Room(
          id: 'room-2',
          creatorId: 'user-2',
          playerIds: ['user-2', 'user-3'],
          status: RoomStatus.inGame,
          maxPlayers: 4,
          createdAt: DateTime.now(),
        ),
      ];

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          availableRoomsProvider.overrideWith(() => Stream.value(rooms)),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('En attente'), findsOneWidget);
      expect(find.text('En jeu'), findsOneWidget);
    });

    testWidgets('should have refresh button', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should have back button in app bar', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}

// Mock classes for GoRouter
class MockRouterDelegate extends Mock implements RouterDelegate<Object> {}
class MockRouteInformationParser extends Mock implements RouteInformationParser<Object> {}
class MockRouteInformationProvider extends Mock implements RouteInformationProvider {}