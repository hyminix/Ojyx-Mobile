import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 10),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseStorageClient get storage => client.storage;

  static RealtimeClient get realtime => client.realtime;

  static Future<void> signInAnonymously() async {
    final response = await auth.signInAnonymously();
    if (response.user == null) {
      throw Exception('Failed to sign in anonymously');
    }
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }

  static bool get isAuthenticated => auth.currentUser != null;

  static String? get userId => auth.currentUser?.id;
}
