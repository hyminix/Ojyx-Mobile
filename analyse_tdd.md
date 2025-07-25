# Audit des Tests TDD - Plan d'Action

Ce document liste toutes les actions de refactoring nécessaires pour améliorer la suite de tests du projet. Chaque point représente une tâche à effectuer.

## Fichier : `test/core/config/env_config_test.dart`

- [ ] **MODIFIER :** Le test `'should have default values'` (lignes 6-15).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Le test vérifie des valeurs vides par défaut au lieu de tester le comportement attendu de configuration. Il devrait tester comment l'application réagit avec une configuration valide/invalide.

- [ ] **MODIFIER :** Le test `'should validate required configuration'` (lignes 23-35).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Le test documente le comportement attendu mais ne peut pas le tester réellement. Il faudrait créer un wrapper testable autour de String.fromEnvironment.

## Fichier : `test/features/multiplayer/data/datasources/supabase_room_datasource_test.dart`

- [ ] **SUPPRIMER :** Le test `'should have all required methods defined'` (lignes 23-38).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement) et Principe n°4 (Bonne Granularité). Ce test vérifie uniquement que les méthodes existent sans tester leur comportement. C'est un test trivial qui n'apporte aucune valeur.

## Fichier : `test/database/migrations/game_states_table_test.dart`

- [ ] **SUPPRIMER :** Tous les tests du fichier.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Les tests vérifient des strings SQL au lieu du comportement de la base de données. Les migrations doivent être testées via des tests d'intégration qui vérifient l'effet des migrations, pas leur contenu SQL.

## Fichier : `test/features/multiplayer/data/models/room_model_test.dart`

- [ ] **FUSIONNER :** Les tests `'should create RoomModel with all required fields'` (lignes 8-33) et `'should create RoomModel with optional fields'` (lignes 35-51).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Ces deux tests vérifient essentiellement la même chose (création du modèle). Un seul test paramétré suffirait.

- [ ] **FUSIONNER :** Les tests de statut individuels (lignes 146-196) dans `'should parse all room statuses correctly'`.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance) et Principe n°5 (Clarté). Ces tests répètent la même logique pour chaque statut. Un test paramétré ou une boucle serait plus lisible.

- [ ] **FUSIONNER :** Les tests de conversion de statut (lignes 260-300) dans `'should convert all RoomStatus values correctly'`.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Logique identique répétée pour chaque statut.

## Fichier : `test/features/game/presentation/widgets/card_widget_test.dart`

- [ ] **FUSIONNER :** Les tests de couleur par valeur de carte (lignes 163-199).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Le test utilise déjà une boucle mais pourrait être simplifié davantage avec un test paramétré.

## Fichier : `test/core/errors/failures_test.dart`

- [ ] **FUSIONNER :** Tous les tests de création de Failure (lignes 6-127) en un seul test paramétré.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Chaque test suit exactement la même structure pour différents types de Failure. Un test paramétré réduirait la duplication de 90%.

## Fichier : `test/features/game/presentation/draw_discard_integration_test.dart`

- [ ] **MODIFIER :** Remplacer l'utilisation de `StatefulBuilder` par des mocks appropriés.
  - **Justification :** Violation du Principe n°3 (Isoler le Code avec des Mocks). Les tests manipulent directement l'état au lieu d'utiliser des providers mockés, ce qui complique les tests et les rend fragiles.

## Fichier : `test/features/game/presentation/providers/game_state_notifier_test.dart`

- [ ] **SUPPRIMER :** Le test `'should have placeholder methods for game actions'` (lignes 183-193).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Ce test vérifie des méthodes placeholder vides qui ne font rien. Aucune valeur ajoutée.

## Fichier : `test/features/game/presentation/widgets/player_grid_widget_test.dart`

- [ ] **FUSIONNER :** Les tests `'should display "Votre grille" when isCurrentPlayer is true'` et `'should not display "Votre grille" when isCurrentPlayer is false'` (lignes 37-78).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Ces deux tests vérifient les deux faces de la même médaille et pourraient être un seul test paramétré.

- [ ] **SUPPRIMER :** Le test vide dans le groupe `'_StatChip'` (lignes 321-326).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test commenté sans implémentation. Soit l'implémenter, soit le supprimer.

## Fichier : `test/features/game/domain/entities/game_state_test.dart`

- [ ] **MODIFIER :** Les noms de test pour plus de clarté.
  - **Justification :** Violation du Principe n°5 (Clarté). Les noms comme `'should create initial game state'` pourraient être plus expressifs : `'should initialize game with waiting status when created'`.

## Fichier : `test/features/game/domain/use_cases/draw_card_test.dart`

- [ ] **FUSIONNER :** Les tests d'échec similaires (lignes 113-274).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Les tests `'should fail if not player turn'`, `'should fail if already drawn card'`, etc. suivent tous la même structure et pourraient être paramétrés.

## Actions Globales Recommandées

- [ ] **CRÉER :** Un dossier `test/unit/` pour les tests unitaires purs.
  - **Justification :** Amélioration de l'organisation et séparation claire des types de tests.

- [ ] **CRÉER :** Un dossier `test/integration/` pour les tests d'intégration.
  - **Justification :** Séparer les tests qui nécessitent plusieurs composants de ceux qui testent des unités isolées.

- [ ] **CRÉER :** Des helpers de test réutilisables pour réduire la duplication.
  - **Justification :** Principe n°2 (Éliminer la Redondance). Beaucoup de tests répètent la même configuration.

- [ ] **MODIFIER :** Standardiser les noms de tests au format `'should [expected behavior] when [condition]'`.
  - **Justification :** Principe n°5 (Clarté). Format cohérent pour tous les tests.

- [ ] **CRÉER :** Des builders de test pour les entités complexes (GameState, Room, etc.).
  - **Justification :** Principe n°2 et n°5. Réduire la duplication et améliorer la lisibilité.

## Métriques d'Amélioration Attendues

- Réduction du nombre de lignes de test de ~40% par élimination de la redondance
- Amélioration du temps d'exécution des tests de ~30%
- Réduction du coût de maintenance des tests
- Amélioration de la couverture comportementale vs couverture structurelle