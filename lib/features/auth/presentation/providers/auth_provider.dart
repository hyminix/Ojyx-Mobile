import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/supabase_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    final supabase = ref.watch(supabaseClientProvider);

    // Check if user is already authenticated
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      return currentUser;
    }

    // Sign in anonymously
    try {
      final response = await supabase.auth.signInAnonymously();
      return response.user;
    } catch (e) {
      // If anonymous auth fails, return null
      return null;
    }
  }

  Future<void> signOut() async {
    final supabase = ref.read(supabaseClientProvider);
    await supabase.auth.signOut();
    ref.invalidateSelf();
  }

  String? get currentUserId => state.valueOrNull?.id;
}

@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  return ref.watch(authNotifierProvider).valueOrNull?.id;
}
