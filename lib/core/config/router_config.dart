import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/multiplayer/presentation/screens/create_room_screen.dart';
import '../../features/multiplayer/presentation/screens/join_room_screen.dart';
import '../../features/multiplayer/presentation/screens/room_lobby_screen.dart';
import '../../features/game/presentation/screens/game_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'router_refresh_notifier.dart';
import 'app_navigation_observer.dart';

part 'router_config.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  // Watch auth state for automatic redirects
  final authAsync = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Refresh router when auth state changes
    refreshListenable: ref.watch(routerRefreshProvider),
    // Navigation observer for tracking
    observers: [AppNavigationObserver()],
    // Global redirect for auth guard
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authAsync.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      final isPublicRoute =
          state.matchedLocation == '/' || state.matchedLocation == '/join-room';

      // Allow access to home and join-room without auth
      // But require auth for creating rooms and playing
      if (!isAuthenticated && !isPublicRoute) {
        return '/?redirect=${Uri.encodeComponent(state.uri.toString())}';
      }

      return null;
    },
    routes: [
      // Public routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return HomeScreen(redirectUrl: redirect);
        },
      ),
      GoRoute(
        path: '/join-room',
        name: 'joinRoom',
        builder: (context, state) => const JoinRoomScreen(),
      ),
      GoRoute(
        path: '/rules',
        name: 'rules',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Règles du Jeu'),
          ),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Règles du Jeu Ojyx',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cette page est en cours de développement.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Protected routes
      GoRoute(
        path: '/create-room',
        name: 'createRoom',
        builder: (context, state) => const CreateRoomScreen(),
        // Additional guard for room creation
        redirect: (context, state) {
          final hasUser = ref.read(authNotifierProvider).valueOrNull != null;
          if (!hasUser) {
            return '/?redirect=/create-room';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/room/:roomId',
        name: 'roomLobby',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return RoomLobbyScreen(roomId: roomId);
        },
        // Room-specific guard
        redirect: (context, state) {
          final roomId = state.pathParameters['roomId'];
          if (roomId == null || roomId.isEmpty) {
            return '/';
          }

          final hasUser = ref.read(authNotifierProvider).valueOrNull != null;
          if (!hasUser) {
            return '/?redirect=${Uri.encodeComponent(state.uri.toString())}';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/game/:gameId',
        name: 'game',
        pageBuilder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: GameScreen(gameId: gameId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
        // Game-specific guard
        redirect: (context, state) {
          final gameId = state.pathParameters['gameId'];
          if (gameId == null || gameId.isEmpty) {
            return '/';
          }

          final hasUser = ref.read(authNotifierProvider).valueOrNull != null;
          if (!hasUser) {
            return '/?redirect=${Uri.encodeComponent(state.uri.toString())}';
          }

          // TODO: Additional check if user is in the game

          return null;
        },
      ),
      
      // Admin routes
      GoRoute(
        path: '/admin',
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboardScreen(),
        // Admin guard - only for development
        redirect: (context, state) {
          final hasUser = ref.read(authNotifierProvider).valueOrNull != null;
          if (!hasUser) {
            return '/?redirect=/admin';
          }
          // TODO: Add proper admin check in production
          return null;
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error?.toString() ?? 'Erreur inconnue'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
}
