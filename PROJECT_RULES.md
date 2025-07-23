# Règles du Projet Ojyx

## Architecture
- **Clean Architecture OBLIGATOIRE**
- Séparation stricte : Presentation | Domain | Data
- Structure par features dans `/lib/features/`

## Stack Technique
- **Gestion d'état** : Riverpod (obligatoire)
- **Modèles** : Freezed + json_serializable (obligatoire)
- **Navigation** : go_router uniquement
- **Backend** : Supabase
- **Monitoring** : Sentry

## Workflow Git
- Branches : `feat/*`, `fix/*`, `chore/*` → main
- PR obligatoires avec CI/CD au vert
- Pas de commit direct sur main

## Standards de Code
- Test-First Development obligatoire
- Pas de warnings (`flutter analyze`)
- Code formaté (`dart format`)
- Coverage minimum : 80%

## Conventions
- Nommage providers : `[entity]RepositoryProvider`
- Nommage états : `[Feature]State`
- Pas de clés API en dur
- Documentation des APIs publiques