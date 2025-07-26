import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/multiplayer/presentation/screens/create_room_screen.dart';
import '../../features/multiplayer/presentation/screens/join_room_screen.dart';
import '../../features/multiplayer/presentation/screens/room_lobby_screen.dart';
import '../../features/game/presentation/screens/game_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

part 'router_config_v2_example.g.dart';

/// Example of improved router configuration with guards and state integration
@riverpod
GoRouter router(RouterRef ref) {
  // Watch auth state for automatic redirects
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Refresh router when auth state changes
    refreshListenable: RouterRefreshNotifier(ref),
    // Global redirect for auth guard
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      
      final isAuthRoute = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/register';
      
      // Redirect to login if not authenticated and trying to access protected route
      if (!isAuthenticated && !isAuthRoute) {
        return '/login?redirect=${state.uri}';
      }
      
      // Redirect to home if authenticated and trying to access auth routes
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }
      
      return null;
    },
    routes: [
      // Public routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return LoginScreen(redirectUrl: redirect);
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Protected routes with shell for consistent navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              // Nested routes for better organization
              GoRoute(
                path: 'create-room',
                name: 'createRoom',
                builder: (context, state) => const CreateRoomScreen(),
              ),
              GoRoute(
                path: 'join-room',
                name: 'joinRoom',
                builder: (context, state) => const JoinRoomScreen(),
              ),
            ],
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
              // Could check if user has access to this room
              final roomId = state.pathParameters['roomId'];
              if (roomId == null || roomId.isEmpty) {
                return '/';
              }
              return null;
            },
          ),
          GoRoute(
            path: '/game/:roomId',
            name: 'game',
            pageBuilder: (context, state) {
              final roomId = state.pathParameters['roomId']!;
              return CustomTransitionPage(
                key: state.pageKey,
                child: GameScreen(roomId: roomId),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
            // Game-specific guard
            redirect: (context, state) async {
              final roomId = state.pathParameters['roomId'];
              // Could verify game state before allowing access
              if (roomId == null) {
                return '/';
              }
              return null;
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(
      error: state.error,
      onRetry: () => context.go('/'),
    ),
  );
}

/// Notifier to refresh router when auth state changes
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this.ref) {
    // Listen to auth state changes
    ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref ref;
}

/// Shell widget for consistent navigation structure
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});
  
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Créer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Rejoindre',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location == '/create-room') return 1;
    if (location == '/join-room') return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/create-room');
      case 2:
        context.go('/join-room');
    }
  }
}

/// Enhanced error page
class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.error,
    this.onRetry,
    super.key,
  });

  final Exception? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(error?.toString() ?? 'Erreur inconnue'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry ?? () => context.go('/'),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for example
class LoginScreen extends StatelessWidget {
  const LoginScreen({this.redirectUrl, super.key});
  final String? redirectUrl;

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}