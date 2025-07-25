# Tests Unitaires Purs

Ce dossier contient les tests unitaires purs qui testent des unités isolées de code sans dépendances externes.

## Critères pour les Tests Unitaires Purs

### ✅ Ce qui DOIT être dans ce dossier :

1. **Tests d'entités métier** (`domain/entities/`)
   - Tests des règles de calcul
   - Tests de validation des données
   - Tests de logique métier pure

2. **Tests d'extensions et utilitaires** (`core/utils/`)
   - Extensions Dart/Flutter
   - Fonctions d'aide pure
   - Transformations de données

3. **Tests de modèles avec sérialisation** (`data/models/`)
   - Tests de conversion JSON ↔ Objet
   - Tests de mappage entre couches
   - Tests de validation de format

4. **Tests de cas d'usage simples** (`domain/use_cases/`)
   - Cas d'usage sans dépendances externes
   - Logique métier encapsulée
   - Calculs et transformations

### ❌ Ce qui NE DOIT PAS être dans ce dossier :

1. **Tests avec mocks complexes** → `test/integration/`
2. **Tests de widgets** → garder dans `test/features/*/presentation/widgets/`  
3. **Tests de providers Riverpod** → garder dans `test/features/*/presentation/providers/`
4. **Tests de repositories** → `test/integration/`
5. **Tests de datasources** → `test/integration/`
6. **Tests end-to-end** → `test/integration/`

## Structure Recommandée

```
test/unit/
├── core/
│   ├── utils/
│   │   ├── extensions_test.dart
│   │   └── validators_test.dart
│   └── errors/
│       └── failures_test.dart
├── features/
│   ├── game/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── card_test.dart
│   │   │   │   ├── game_state_test.dart
│   │   │   │   └── player_grid_test.dart
│   │   │   └── use_cases/
│   │   │       └── calculate_scores_test.dart
│   │   └── data/
│   │       └── models/
│   │           └── game_state_model_test.dart
│   └── multiplayer/
│       └── domain/
│           └── entities/
│               ├── room_test.dart
│               └── lobby_player_test.dart
└── README.md (ce fichier)
```

## Bonnes Pratiques

1. **Tests rapides** : Doivent s'exécuter en < 1ms
2. **Sans dépendances** : Pas de base de données, réseau, ou filesystem
3. **Deterministes** : Même input = même output
4. **Isolés** : Un test ne dépend pas d'un autre
5. **Lisibles** : Nom du test décrit le comportement attendu

## Migration des Tests Existants

Lors de la réorganisation, déplacer ici uniquement les tests qui respectent les critères ci-dessus. Les autres tests restent dans leur localisation actuelle ou sont déplacés vers `test/integration/`.