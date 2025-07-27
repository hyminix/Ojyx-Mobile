# Guide de Configuration Ojyx

## 1. Obtenir les clés Supabase

### Étape 1 : Créer un projet Supabase
1. Allez sur [supabase.com](https://supabase.com)
2. Connectez-vous ou créez un compte gratuit
3. Cliquez sur "New Project"
4. Remplissez les informations :
   - **Name** : Ojyx (ou le nom que vous voulez)
   - **Database Password** : Choisissez un mot de passe fort
   - **Region** : Choisissez la région la plus proche
   - **Plan** : Free tier suffit pour le développement

### Étape 2 : Récupérer les clés
1. Une fois le projet créé, allez dans **Settings** (icône engrenage)
2. Cliquez sur **API** dans le menu latéral
3. Vous trouverez :
   - **Project URL** : C'est votre `SUPABASE_URL` (ex: https://xyzxyzxyz.supabase.co)
   - **anon public** : C'est votre `SUPABASE_ANON_KEY` (la clé longue qui commence par eyJ...)

### Étape 3 : Configuration de la base de données
Pour Ojyx, vous devrez créer les tables nécessaires. Vous pouvez le faire depuis l'interface Supabase :
1. Allez dans **Database** → **Tables**
2. Créez les tables selon le schéma du projet (voir la documentation du projet)

## 2. Obtenir les clés Sentry (Optionnel)

Sentry est utilisé pour le monitoring des erreurs en production.

### Étape 1 : Créer un compte Sentry
1. Allez sur [sentry.io](https://sentry.io)
2. Créez un compte gratuit
3. Créez une nouvelle organisation si demandé

### Étape 2 : Créer un projet
1. Cliquez sur "Create Project"
2. Choisissez **Flutter** comme plateforme
3. Nommez votre projet "ojyx"
4. Cliquez sur "Create Project"

### Étape 3 : Récupérer le DSN
1. Après la création, vous verrez le DSN
2. Il ressemble à : `https://1234567890abcdef@o123456.ingest.sentry.io/1234567`
3. C'est votre `SENTRY_DSN`

## 3. Créer le fichier .env

Créez un fichier `.env` à la racine du projet avec ce contenu :

```env
# Supabase Configuration
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=eyJ...votre-clé-longue...

# Sentry Configuration (Optionnel)
SENTRY_DSN=https://votre-dsn@sentry.io/projet
SENTRY_ENABLED=false  # Mettez true pour activer en production

# Debug Options
DEBUG_MODE=true
DEBUG_OVERLAY=false
PERFORMANCE_OVERLAY=false

# Environment
ENVIRONMENT=development

# Feature Flags
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
MOCK_MODE=false
```

## 4. Vérifier la configuration

Pour vérifier que tout fonctionne :

1. Lancez l'application : `flutter run`
2. Si vous avez des erreurs de connexion Supabase, vérifiez :
   - Que l'URL n'a pas de `/` à la fin
   - Que la clé anon est complète (elle est longue !)
   - Que votre projet Supabase est bien actif

## Notes importantes

- **Ne commitez JAMAIS** le fichier `.env` dans Git
- Le fichier `.env` est déjà dans `.gitignore`
- Pour la production, utilisez des variables d'environnement sécurisées
- Les clés "anon" de Supabase sont publiques et sûres côté client