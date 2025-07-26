import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Type definition for route guards
typedef RouteGuard =
    FutureOr<String?> Function(BuildContext context, GoRouterState state);

/// Collection of reusable route guards
class RouteGuards {
  /// Guard that requires authentication
  static RouteGuard requireAuth(WidgetRef ref) {
    return (context, state) {
      final hasUser = ref.read(authNotifierProvider).valueOrNull != null;
      if (!hasUser) {
        return '/?redirect=${Uri.encodeComponent(state.uri.toString())}';
      }
      return null;
    };
  }

  /// Guard that validates room ID parameter
  static RouteGuard validateRoomId() {
    return (context, state) {
      final roomId = state.pathParameters['roomId'];
      if (roomId == null || roomId.isEmpty) {
        return '/';
      }
      return null;
    };
  }

  /// Guard that checks room membership (placeholder for future implementation)
  static RouteGuard requireRoomMembership(WidgetRef ref) {
    return (context, state) async {
      final roomId = state.pathParameters['roomId'];
      if (roomId == null) return '/';

      // TODO: Implement actual room membership check
      // final roomProvider = ref.read(currentRoomProvider(roomId));
      // final isMember = await roomProvider.checkMembership();
      // if (!isMember) return '/';

      return null;
    };
  }

  /// Compose multiple guards into a single guard
  static RouteGuard compose(List<RouteGuard> guards) {
    return (context, state) async {
      for (final guard in guards) {
        final result = await guard(context, state);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// Guard with custom redirect message
  static RouteGuard withMessage(RouteGuard guard, String message) {
    return (context, state) async {
      final result = await guard(context, state);
      if (result != null) {
        // Could store message in a provider for display
        debugPrint('Guard blocked navigation: $message');
      }
      return result;
    };
  }
}
