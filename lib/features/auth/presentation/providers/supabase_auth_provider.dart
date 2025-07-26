import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/providers/supabase_provider_v2.dart';
import 'package:ojyx/core/errors/supabase_error_handling.dart';
import 'package:ojyx/core/utils/resilient_supabase_service.dart';

part 'supabase_auth_provider.g.dart';

/// Provider pour l'état d'authentification Supabase avec gestion d'erreurs améliorée
@riverpod
class SupabaseAuth extends _$SupabaseAuth {
  @override
  Stream<AuthState> build() {
    final client = ref.watch(supabaseClientProvider);

    // Stream avec reconnexion automatique
    return ResilientSupabaseService.resilientStream(
      () => client.auth.onAuthStateChange,
      maxReconnectAttempts: 5,
      reconnectDelay: const Duration(seconds: 2),
    );
  }

  /// Connexion anonyme avec metadata enrichies
  Future<void> signInAnonymously() async {
    final client = ref.read(supabaseClientProvider);

    try {
      await ResilientSupabaseService.resilientExecute(
        () => client.auth.signInAnonymously(
          data: {
            'app_version': '1.0.0',
            'platform': Platform.operatingSystem,
            'device_type': _getDeviceType(),
            'created_at': DateTime.now().toIso8601String(),
          },
        ),
        maxAttempts: 3,
        timeout: const Duration(seconds: 20),
      );
    } on AuthException catch (e) {
      throw AppException.fromAuth(e);
    }
  }

  /// Déconnexion avec nettoyage
  Future<void> signOut() async {
    final client = ref.read(supabaseClientProvider);

    try {
      await ResilientSupabaseService.withTimeout(
        () => client.auth.signOut(),
        timeout: const Duration(seconds: 10),
      );
    } on AuthException catch (e) {
      throw AppException.fromAuth(e);
    }
  }

  /// Récupère l'utilisateur actuel avec vérification
  User? get currentUser {
    final client = ref.read(supabaseClientProvider);
    return client.auth.currentUser;
  }

  /// Vérifie si l'utilisateur est connecté
  bool get isAuthenticated => currentUser != null;

  /// Récupère le type d'appareil
  String _getDeviceType() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Rafraîchit la session si nécessaire
  Future<void> refreshSession() async {
    final client = ref.read(supabaseClientProvider);

    try {
      await ResilientSupabaseService.withTimeout(
        () => client.auth.refreshSession(),
        timeout: const Duration(seconds: 15),
      );
    } on AuthException catch (e) {
      if (e.requiresReauth) {
        // Session expirée, se reconnecter en anonyme
        await signInAnonymously();
      } else {
        throw AppException.fromAuth(e);
      }
    }
  }
}

/// Provider pour l'utilisateur actuel
@riverpod
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(supabaseAuthProvider);

  return authState.whenOrNull(data: (state) => state.session?.user);
}

/// Provider pour vérifier l'état d'authentification
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(currentUserProvider) != null;
}

/// Provider pour l'ID de l'utilisateur actuel
@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  return ref.watch(currentUserProvider)?.id;
}
