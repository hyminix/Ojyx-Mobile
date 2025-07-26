#!/usr/bin/env dart

import 'dart:io';

/// Script de migration pour passer du router v1 au router v2 avec guards
void main() async {
  print('🚀 Migration du router vers la v2 avec guards d\'authentification\n');

  // 1. Backup du router actuel
  print('📋 Backup du router actuel...');
  final routerFile = File('lib/core/config/router_config.dart');
  final backupFile = File('lib/core/config/router_config_backup.dart');

  if (routerFile.existsSync()) {
    await routerFile.copy(backupFile.path);
    print('✅ Backup créé: ${backupFile.path}');
  }

  // 2. Remplacer l'import dans main.dart
  print('\n📝 Mise à jour de main.dart...');
  final mainFile = File('lib/main.dart');
  if (mainFile.existsSync()) {
    var mainContent = await mainFile.readAsString();

    // Remplacer l'import
    mainContent = mainContent.replaceAll(
      "import 'core/config/router_config.dart';",
      "import 'core/config/router_config_v2.dart';",
    );

    // Remplacer le provider
    mainContent = mainContent.replaceAll('routerProvider', 'routerProviderV2');

    await mainFile.writeAsString(mainContent);
    print('✅ main.dart mis à jour');
  }

  // 3. Mettre à jour le HomeScreen
  print('\n📝 Mise à jour du HomeScreen...');
  final homeFile = File(
    'lib/features/home/presentation/screens/home_screen.dart',
  );
  final homeBackupFile = File(
    'lib/features/home/presentation/screens/home_screen_backup.dart',
  );

  if (homeFile.existsSync()) {
    await homeFile.copy(homeBackupFile.path);

    // Copier la v2 sur l'original
    final homeV2File = File(
      'lib/features/home/presentation/screens/home_screen_v2.dart',
    );
    if (homeV2File.existsSync()) {
      await homeV2File.copy(homeFile.path);
      print('✅ HomeScreen mis à jour avec gestion des redirections');
    }
  }

  // 4. Instructions pour les tests
  print('\n📋 Étapes de test recommandées:');
  print('1. flutter pub get');
  print('2. flutter test test/navigation/router_v2_test.dart');
  print('3. flutter run');
  print('4. Tester les cas suivants:');
  print('   - Accès à la home sans auth ✓');
  print('   - Accès à join-room sans auth ✓');
  print('   - Tentative d\'accès à create-room sans auth → redirection');
  print('   - Tentative d\'accès à room/:id sans auth → redirection');
  print('   - Tentative d\'accès à game/:id sans auth → redirection');
  print('   - Connexion puis redirection automatique vers l\'URL cible');

  // 5. Rollback instructions
  print('\n⚠️  Pour rollback si nécessaire:');
  print(
    '1. cp lib/core/config/router_config_backup.dart lib/core/config/router_config.dart',
  );
  print(
    '2. cp lib/features/home/presentation/screens/home_screen_backup.dart lib/features/home/presentation/screens/home_screen.dart',
  );
  print('3. Restaurer les imports dans main.dart');

  print('\n✅ Migration préparée! Lancer les tests pour valider.');
}
