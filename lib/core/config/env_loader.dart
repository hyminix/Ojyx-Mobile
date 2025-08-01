import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Cross-platform environment loader
/// Uses conditional imports to handle web-specific code
class EnvLoader {
  EnvLoader._();

  /// Load environment variables based on platform
  static void loadEnvironment() {
    if (kIsWeb) {
      _loadWebEnvironment();
    } else {
      _loadMobileEnvironment();
    }
  }

  /// Load environment variables for web platform
  static void _loadWebEnvironment() {
    // For web, we'll use dart-define since dart:html import causes issues
    // The values will be injected at build time
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const sentryDsn = String.fromEnvironment('SENTRY_DSN');

    if (supabaseUrl.isNotEmpty && !supabaseUrl.contains('%')) {
      dotenv.env['SUPABASE_URL'] = supabaseUrl;
    }

    if (supabaseAnonKey.isNotEmpty && !supabaseAnonKey.contains('%')) {
      dotenv.env['SUPABASE_ANON_KEY'] = supabaseAnonKey;
    }

    if (sentryDsn.isNotEmpty && !sentryDsn.contains('%')) {
      dotenv.env['SENTRY_DSN'] = sentryDsn;
    }

    debugPrint('Web environment loaded from dart-define');
  }

  /// Load environment variables for mobile platforms
  static void _loadMobileEnvironment() {
    // On mobile, environment variables are already loaded from .env file
    // or from dart-define during build
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const sentryDsn = String.fromEnvironment('SENTRY_DSN');

    // Override with dart-define values if available
    if (supabaseUrl.isNotEmpty) {
      dotenv.env['SUPABASE_URL'] = supabaseUrl;
    }

    if (supabaseAnonKey.isNotEmpty) {
      dotenv.env['SUPABASE_ANON_KEY'] = supabaseAnonKey;
    }

    if (sentryDsn.isNotEmpty) {
      dotenv.env['SENTRY_DSN'] = sentryDsn;
    }

    debugPrint('Mobile environment loaded');
  }
}