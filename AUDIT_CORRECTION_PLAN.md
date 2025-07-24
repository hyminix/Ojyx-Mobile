# Plan d'Audit et de Correction Complet pour Ojyx

## 🚨 État Critique Actuel

### Résumé des Problèmes Identifiés
- **688 tests sur 986 échouent (70% d'échec)**
- **Architecture incohérente** entre domain et data layers
- **Base de données mal intégrée** (action cards complètement en mémoire)
- **Providers Riverpod cassés** empêchant le fonctionnement du jeu
- **Duplication d'entités** (2 versions de Player dans différents features)
- **Violations de Clean Architecture** (presentation accède aux datasources)

### Analyse Détaillée des Problèmes

#### 1. Problèmes d'Architecture
- **Deux entités Player différentes** : Une dans game/domain et une dans multiplayer/domain
- **GameState vs GameStateModel** : Mapping incomplet et incohérent
- **Entités domain avec sérialisation JSON** : Violation du principe de séparation
- **DbPlayerGrid dans domain layer** : Entité orientée DB dans la mauvaise couche
- **Repositories retournant des Map<String, dynamic>** : Au lieu d'entités domain

#### 2. Problèmes de Base de Données
- **ActionCards entièrement en mémoire locale** via `ActionCardLocalDataSource`
- **GameStateRepository non injecté** dans les providers
- **Mapping incomplet** entre modèles DB et entités domain
- **Pas de tests pour les nouveaux repositories** Supabase

#### 3. Problèmes de Tests
- **688 tests échouent** principalement à cause des changements d'architecture
- **3 fichiers de tests UI désactivés** (.disabled) à cause de la migration Riverpod
- **Tests manquants** pour toutes les nouvelles fonctionnalités phases 5.1-5.4
- **Aucune couverture** sur les repositories serveur-autoritaires

## 📋 Plan d'Action Structuré

### Phase 1 : Correction Architecture (Priorité MAXIMALE)

#### 1.1 Unifier les entités Player
**Objectif** : Éliminer la duplication et clarifier les responsabilités

**Actions** :
1. Analyser les deux versions de Player et leurs usages
2. Créer deux entités distinctes :
   - `GamePlayer` dans `/lib/features/game/domain/entities/` pour la logique de jeu
   - `LobbyPlayer` dans `/lib/features/multiplayer/domain/entities/` pour le lobby
3. Mettre à jour tous les imports et usages
4. Écrire les tests unitaires pour chaque entité (TDD)
5. Vérifier que tous les tests passent

**Fichiers à modifier** :
- `/lib/features/game/domain/entities/player.dart` → `game_player.dart`
- `/lib/features/multiplayer/domain/entities/player.dart` → `lobby_player.dart`
- Tous les fichiers qui importent Player

#### 1.2 Refactoriser GameState/GameStateModel
**Objectif** : Séparer clairement l'état runtime de sa persistance

**Actions** :
1. Retirer toute sérialisation JSON de `GameState` (entité domain)
2. Créer des mappers complets dans `GameStateModel` :
   ```dart
   // Mapper complet avec récupération des données liées
   Future<GameState> toDomainComplete({
     required List<Player> players,
     required List<Card> deck,
     required List<Card> discardPile,
     // etc.
   });
   ```
3. Implémenter `fromDomainComplete` pour la persistance
4. Retirer `DbPlayerGrid` du domain layer
5. Tests unitaires pour tous les mappers

**Fichiers à modifier** :
- `/lib/features/game/domain/entities/game_state.dart`
- `/lib/features/game/data/models/game_state_model.dart`
- `/lib/features/game/domain/entities/db_player_grid.dart` → à déplacer dans data

#### 1.3 Corriger les Providers Riverpod
**Objectif** : Rétablir l'injection de dépendances correcte

**Actions** :
1. Créer `gameStateRepositoryProvider` :
   ```dart
   @riverpod
   GameStateRepository gameStateRepository(GameStateRepositoryRef ref) {
     final supabase = ref.watch(supabaseClientProvider);
     return SupabaseGameStateRepository(supabase);
   }
   ```

2. Corriger tous les providers de use cases :
   ```dart
   @riverpod
   GameInitializationUseCase gameInitializationUseCase(ref) {
     final repository = ref.watch(gameStateRepositoryProvider);
     return GameInitializationUseCase(repository);
   }
   ```

3. Supprimer l'accès direct aux datasources depuis presentation
4. Tests pour chaque provider

**Fichiers à créer/modifier** :
- Créer `/lib/features/game/presentation/providers/repository_providers.dart`
- Modifier `/lib/features/game/presentation/providers/game_state_notifier.dart`
- Modifier tous les providers de use cases

### Phase 2 : Migration Base de Données (Priorité HAUTE)

#### 2.1 Migrer les Action Cards vers Supabase
**Objectif** : Éliminer le stockage en mémoire locale

**Actions** :
1. Créer la migration SQL :
   ```sql
   -- Tables pour les cartes actions
   CREATE TABLE action_cards_deck (
     game_state_id uuid REFERENCES game_states(id),
     cards jsonb NOT NULL,
     created_at timestamptz DEFAULT now()
   );
   
   CREATE TABLE player_action_cards (
     id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
     game_state_id uuid REFERENCES game_states(id),
     player_id uuid REFERENCES players(id),
     cards jsonb NOT NULL,
     updated_at timestamptz DEFAULT now()
   );
   ```

2. Implémenter `SupabaseActionCardDataSource`
3. Créer `SupabaseActionCardRepository`
4. Remplacer `ActionCardLocalDataSource` partout
5. Tests d'intégration avec Supabase

**Fichiers à créer** :
- `/lib/features/game/data/datasources/supabase_action_card_datasource.dart`
- `/lib/features/game/data/repositories/supabase_action_card_repository.dart`
- `/supabase/migrations/20250124_action_cards.sql`

#### 2.2 Compléter l'intégration GameState
**Objectif** : Récupération complète de l'état depuis la DB

**Actions** :
1. Implémenter les fonctions PostgreSQL manquantes :
   ```sql
   CREATE OR REPLACE FUNCTION get_complete_game_state(p_game_state_id uuid)
   RETURNS jsonb AS $$
   -- Retourner l'état complet avec joueurs, cartes, etc.
   ```

2. Mettre à jour `SupabaseGameStateRepository` pour utiliser ces fonctions
3. Implémenter la récupération en cascade des données liées
4. Tests end-to-end de synchronisation

**Fichiers à modifier** :
- `/lib/features/game/data/repositories/supabase_game_state_repository.dart`
- `/supabase/migrations/20250124_complete_game_state.sql`

### Phase 3 : Réparation des Tests (Priorité HAUTE)

#### 3.1 Corriger les 688 tests qui échouent
**Objectif** : Rétablir une suite de tests fonctionnelle

**Actions par catégorie** :
1. **Tests de modèles** (GameStateModel) :
   - Adapter aux nouvelles propriétés
   - Corriger les mappers fromJson/toJson
   - Mettre à jour les fixtures

2. **Tests de repositories** :
   - Créer des mocks pour les nouvelles interfaces
   - Adapter aux nouvelles signatures de méthodes
   - Vérifier les appels Supabase

3. **Tests de use cases** :
   - Injecter les bons repositories
   - Adapter aux nouveaux flux de données
   - Vérifier la logique métier

4. **Tests de providers** :
   - Corriger l'injection de dépendances
   - Mettre à jour les overrides dans les tests
   - Vérifier les états retournés

**Approche** :
- Traiter feature par feature
- Commencer par les tests unitaires puis remonter
- Utiliser des agents parallèles pour accélérer

#### 3.2 Réactiver les tests UI désactivés
**Objectif** : Restaurer les tests d'interface

**Actions** :
1. Renommer les fichiers `.disabled` en `.dart`
2. Migrer vers Riverpod 2.x :
   - Remplacer `ProviderContainer` par `ProviderScope`
   - Mettre à jour les syntaxes de providers
   - Corriger les overrides

3. Adapter aux nouveaux modèles et providers
4. Vérifier que tous les widgets se rendent correctement

**Fichiers à réactiver** :
- `/test/features/multiplayer/presentation/screens/*.disabled`

#### 3.3 Ajouter les tests manquants
**Objectif** : Couvrir les nouvelles fonctionnalités

**Tests à créer** :
1. **Repositories** :
   - `supabase_game_state_repository_test.dart`
   - `server_action_card_repository_test.dart`
   - `supabase_action_card_repository_test.dart`

2. **Datasources** :
   - `supabase_game_state_datasource_test.dart`
   - `supabase_player_datasource_test.dart`

3. **Use Cases serveur-autoritaires** :
   - Tests pour validation serveur
   - Tests pour gestion d'erreurs
   - Tests pour synchronisation

4. **Tests d'intégration** :
   - Flux complet de création de partie
   - Synchronisation multi-joueurs
   - Gestion des déconnexions

### Phase 4 : Validation et Documentation

#### 4.1 Audit de conformité
**Objectif** : Vérifier le respect de Clean Architecture

**Actions** :
1. Vérifier chaque feature :
   - Presentation n'importe que domain
   - Domain n'importe rien de data ou presentation
   - Data n'importe que domain (interfaces)

2. Vérifier les conventions :
   - Nommage des providers
   - Structure des dossiers
   - Imports relatifs vs absolus

3. Créer un rapport de conformité

#### 4.2 Tests de régression
**Objectif** : S'assurer que tout fonctionne

**Actions** :
1. Exécuter la suite complète : `flutter test`
2. Générer le rapport de couverture : `flutter test --coverage`
3. Vérifier la couverture (objectif 80%+)
4. Tests de charge avec plusieurs joueurs simultanés
5. Tests sur différents appareils Android

#### 4.3 Documentation technique
**Objectif** : Documenter l'architecture pour l'équipe

**Documents à créer/mettre à jour** :
1. **Architecture serveur-autoritaire** :
   - Diagramme de flux de données
   - Description des validations serveur
   - Guide d'implémentation

2. **Guide de migration** :
   - Comment passer du local au serveur
   - Gestion des états transitoires
   - Patterns recommandés

3. **Mise à jour CLAUDE.md** :
   - Nouvelles conventions
   - Patterns d'architecture
   - Exemples de code

## 🛠️ Approche d'Exécution

### Stratégie Agents Parallélisés
Pour accélérer l'exécution, utiliser plusieurs agents en parallèle :

**Agent 1** : Architecture Domain
- Refactoring des entités
- Correction des mappers
- Tests unitaires domain

**Agent 2** : Architecture Data
- Migration base de données
- Implémentation repositories
- Tests d'intégration

**Agent 3** : Correction Tests
- Réparer tests existants
- Réactiver tests désactivés
- Adapter aux nouveaux modèles

**Agent 4** : Providers & UI
- Corriger providers Riverpod
- Mettre à jour l'UI
- Tests de widgets

### Workflow Git
1. Créer une branche : `fix/database-architecture-overhaul`
2. Commits atomiques par correction
3. PR avec description détaillée des changements
4. S'assurer que la CI/CD passe avant merge

### Validation Continue
- Exécuter `flutter test` après chaque modification majeure
- Vérifier `flutter analyze` régulièrement
- Maintenir le formatage avec `dart format .`

## ⏱️ Estimation Détaillée

### Phase 1 : Correction Architecture
- Unifier Player : 1-2 heures
- Refactoriser GameState : 2-3 heures
- Corriger Providers : 1 heure
**Total Phase 1 : 4-6 heures**

### Phase 2 : Migration Base de Données
- Migrer Action Cards : 2 heures
- Compléter GameState : 1-2 heures
**Total Phase 2 : 3-4 heures**

### Phase 3 : Réparation des Tests
- Corriger tests échouants : 3-4 heures
- Réactiver tests UI : 1-2 heures
- Ajouter tests manquants : 2 heures
**Total Phase 3 : 6-8 heures**

### Phase 4 : Validation
- Audit conformité : 1 heure
- Tests régression : 0.5 heure
- Documentation : 0.5-1.5 heures
**Total Phase 4 : 2-3 heures**

**TOTAL GLOBAL : 15-21 heures de travail intensif**

## ✅ Critères de Succès

### Techniques
- [ ] 100% des tests passent (0 échec)
- [ ] Couverture de tests > 80%
- [ ] 0 warning avec `flutter analyze`
- [ ] Code formaté avec `dart format`

### Architecture
- [ ] Clean Architecture respectée partout
- [ ] Aucun accès direct aux datasources depuis presentation
- [ ] Mappers complets entre domain et data
- [ ] Providers correctement configurés

### Base de Données
- [ ] Toutes les données persistées en DB (0 stockage mémoire)
- [ ] Architecture serveur-autoritaire complète
- [ ] Synchronisation temps réel fonctionnelle
- [ ] Gestion des déconnexions robuste

### Documentation
- [ ] CLAUDE.md à jour
- [ ] Architecture documentée
- [ ] Tests documentés
- [ ] Guide de contribution clair

## 🚀 Prochaines Étapes

1. **Validation du plan** avec l'équipe
2. **Création de la branche** de travail
3. **Lancement des agents** parallélisés
4. **Exécution phase par phase**
5. **Validation continue** des progrès

Ce plan garantira que le projet Ojyx soit robuste, maintenable et prêt pour la production avec une architecture serveur-autoritaire complète et des tests à 100%.