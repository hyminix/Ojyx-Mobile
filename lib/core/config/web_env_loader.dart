import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;

/// Loader for environment variables on web platform
/// Reads from window.ENV object injected in index.html
class WebEnvLoader {
  WebEnvLoader._();

  /// Load environment variables from window.ENV on web
  static void loadWebEnvironment() {
    if (!kIsWeb) return;

    try {
      // Access window.ENV object from JavaScript
      final jsWindow = js.context['window'];
      if (jsWindow == null) return;

      final env = js.context['ENV'];
      if (env == null) {
        debugPrint('window.ENV not found, using dart-define or .env fallback');
        return;
      }

      // Read each environment variable from window.ENV
      final supabaseUrl = env['SUPABASE_URL'];
      final supabaseAnonKey = env['SUPABASE_ANON_KEY'];
      final sentryDsn = env['SENTRY_DSN'];

      // Only override if the values are not placeholders
      if (supabaseUrl != null && 
          supabaseUrl is String && 
          !supabaseUrl.contains('%') &&
          supabaseUrl.isNotEmpty) {
        dotenv.env['SUPABASE_URL'] = supabaseUrl;
      }

      if (supabaseAnonKey != null && 
          supabaseAnonKey is String && 
          !supabaseAnonKey.contains('%') &&
          supabaseAnonKey.isNotEmpty) {
        dotenv.env['SUPABASE_ANON_KEY'] = supabaseAnonKey;
      }

      if (sentryDsn != null && 
          sentryDsn is String && 
          !sentryDsn.contains('%') &&
          sentryDsn.isNotEmpty) {
        dotenv.env['SENTRY_DSN'] = sentryDsn;
      }

      debugPrint('Web environment variables loaded from window.ENV');
    } catch (e) {
      debugPrint('Failed to load web environment variables: $e');
      // Fall back to dart-define or .env
    }
  }

  /// Helper to inject environment variables for development
  /// This can be called from the browser console for testing
  static void injectDevEnvironment({
    required String supabaseUrl,
    required String supabaseAnonKey,
    String? sentryDsn,
  }) {
    if (!kIsWeb) return;

    js.context['ENV'] = js.JsObject.jsify({
      'SUPABASE_URL': supabaseUrl,
      'SUPABASE_ANON_KEY': supabaseAnonKey,
      if (sentryDsn != null) 'SENTRY_DSN': sentryDsn,
    });

    loadWebEnvironment();
    debugPrint('Dev environment injected');
  }
}