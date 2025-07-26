import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/app_initializer.dart';
import 'core/config/router_config.dart';

Future<void> main() async {
  // Initialize all app services
  await AppInitializer.initialize();

  // Run app with Sentry performance monitoring
  await SentryFlutter.init(
    (options) {
      // Options are already configured in AppInitializer
    },
    appRunner: () => runApp(
      const ProviderScope(child: OjyxApp()),
    ),
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
