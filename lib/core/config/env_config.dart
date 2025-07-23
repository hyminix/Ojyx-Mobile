class EnvConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  static const String sentryEnvironment = String.fromEnvironment(
    'SENTRY_ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isProduction => sentryEnvironment == 'production';
  static bool get isDevelopment => sentryEnvironment == 'development';

  static void validate() {
    if (supabaseUrl.isEmpty) {
      throw Exception('SUPABASE_URL is not configured');
    }
    if (supabaseAnonKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY is not configured');
    }
    if (sentryDsn.isEmpty && isProduction) {
      throw Exception('SENTRY_DSN is not configured for production');
    }
  }
}
