# Mise à jour Task 16 : Configuration Sentry Automatique

## Contexte
Le DSN Sentry est déjà présent dans `.env` et peut être récupéré via flutter_dotenv. 
L'objectif est une configuration automatique de Sentry au démarrage de l'app.

## Nouvelles Sous-tâches

### 16.1 : Vérifier l'intégration flutter_dotenv existante
- Valider que flutter_dotenv charge correctement le .env
- Vérifier que SENTRY_DSN est accessible via dotenv.env['SENTRY_DSN']
- S'assurer que le .env est dans pubspec.yaml assets

### 16.2 : Configuration Sentry automatique dans AppInitializer
- Modifier `lib/core/config/app_initializer.dart` pour initialiser Sentry
- Détecter automatiquement l'environnement (debug vs release)
- Utiliser le DSN du .env sans configuration utilisateur

### 16.3 : Intégration avec runZonedGuarded dans main.dart
- Wrapper l'app avec runZonedGuarded pour capture des erreurs
- Configuration du SentryFlutter.init avec options automatiques
- Pas de code de configuration visible par l'utilisateur

### 16.4 : Configuration filtres et contexte automatiques
- Filtres beforeSend pour éviter spam d'erreurs
- Ajout automatique des informations de version
- Configuration des breadcrumbs et user context

### 16.5 : Validation fonctionnement transparent
- Test que Sentry fonctionne dès `flutter run`
- Vérification dashboard Sentry reçoit les erreurs
- Confirmation aucune configuration manuelle requise

## Objectif Final
L'utilisateur lance `flutter run` et Sentry est automatiquement actif avec le DSN du .env, sans aucune configuration supplémentaire.