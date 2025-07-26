// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'4212542c578b68ba228e9687a605ebcbd06a8d45';

/// Provider pour l'utilisateur actuel
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<User?>;
String _$isAuthenticatedHash() => r'b72ba2077fffcbed5f0a4b6a5d3cbf052855b804';

/// Provider pour vérifier l'état d'authentification
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$currentUserIdHash() => r'2ef08710c4a68b6ced9bb918810c2e4667c51c59';

/// Provider pour l'ID de l'utilisateur actuel
///
/// Copied from [currentUserId].
@ProviderFor(currentUserId)
final currentUserIdProvider = AutoDisposeProvider<String?>.internal(
  currentUserId,
  name: r'currentUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserIdRef = AutoDisposeProviderRef<String?>;
String _$supabaseAuthHash() => r'd659cb841a24e46e1409f0a6d658ff1287341569';

/// Provider pour l'état d'authentification Supabase avec gestion d'erreurs améliorée
///
/// Copied from [SupabaseAuth].
@ProviderFor(SupabaseAuth)
final supabaseAuthProvider =
    AutoDisposeStreamNotifierProvider<SupabaseAuth, AuthState>.internal(
      SupabaseAuth.new,
      name: r'supabaseAuthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supabaseAuthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SupabaseAuth = AutoDisposeStreamNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
