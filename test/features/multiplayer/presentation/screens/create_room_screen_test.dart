import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:dartz/dartz.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/create_room_screen.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/core/errors/failures.dart';

class MockGoRouter extends Mock implements GoRouter {}
class MockRoomNotifier extends Mock implements AsyncNotifier<Room?> {
  @override
  AsyncValue<Room?> get state => const AsyncValue.data(null);
}

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

  group('CreateRoomScreen', () {
    testWidgets('should display create room form', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Créer une partie'), findsOneWidget);
      expect(find.text('Nombre de joueurs'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display player count slider from 2 to 8', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, equals(2));
      expect(slider.max, equals(8));
      expect(slider.divisions, equals(6)); // 8 - 2 = 6 divisions
    });

    testWidgets('should update player count when slider changes', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial value should be 4
      expect(find.text('4 joueurs'), findsOneWidget);

      // Drag slider
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Value should have changed
      expect(find.text('4 joueurs'), findsNothing);
    });

    testWidgets('should show loading indicator when creating room', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final mockNotifier = MockRoomNotifier();
      when(() => mockNotifier.state).thenReturn(const AsyncValue.loading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          roomNotifierProvider.overrideWith(() => mockNotifier),
        ],
      ));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('should navigate to room lobby on successful creation', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());
      when(() => mockRouter.go(any())).thenReturn(null);

      final room = Room(
        id: 'room-123',
        creatorId: 'test-user-id',
        playerIds: ['test-user-id'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      final mockNotifier = MockRoomNotifier();
      when(() => mockNotifier.state).thenReturn(AsyncValue.data(room));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          roomNotifierProvider.overrideWith(() => mockNotifier),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockRouter.go('/room/room-123')).called(1);
    });

    testWidgets('should show error message on failure', (tester) async {
      // Arrange
      when(() => mockRouter.routerDelegate).thenReturn(MockRouterDelegate());
      when(() => mockRouter.routeInformationParser).thenReturn(MockRouteInformationParser());
      when(() => mockRouter.routeInformationProvider).thenReturn(MockRouteInformationProvider());

      final mockNotifier = MockRoomNotifier();
      when(() => mockNotifier.state).thenReturn(
        AsyncValue.error('Failed to create room', StackTrace.empty),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(
        overrides: [
          roomNotifierProvider.overrideWith(() => mockNotifier),
        ],
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur'), findsOneWidget);
      expect(find.text('Failed to create room'), findsOneWidget);
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