import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/env_config.dart';
import 'core/config/sentry_config.dart';
import 'core/config/supabase_config.dart';
import 'core/config/router_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate environment configuration
  try {
    EnvConfig.validate();
  } catch (e) {
    // In development, we can continue without proper env config
    if (!EnvConfig.isDevelopment) {
      rethrow;
    }
    debugPrint('Warning: $e');
  }

  // Initialize Sentry with error tracking
  await SentryConfig.initialize(
    appRunner: () async {
      // Initialize Supabase
      if (EnvConfig.supabaseUrl.isNotEmpty) {
        await SupabaseConfig.initialize();
      }

      runApp(const ProviderScope(child: OjyxApp()));
    },
  );
}

class OjyxApp extends ConsumerWidget {
  const OjyxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Ojyx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(elevation: 2, margin: EdgeInsets.all(8)),
      ),
      routerConfig: router,
    );
  }
}
