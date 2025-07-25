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

## Fichier : `test/features/game/domain/use_cases/calculate_scores_test.dart`

- [ ] **MODIFIER :** Les tests de calcul de score (lignes 16-51).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Les tests vérifient les calculs internes plutôt que le comportement métier attendu du système de scoring.

- [ ] **FUSIONNER :** Le test `'handle empty grids'` avec le test principal.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test trivial qui pourrait être un cas dans le test principal.

- [ ] **DÉCOMPOSER :** Le test de tri et calcul (lignes 183-228).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test trop complexe mélangeant tri et calcul dans un seul test.

## Fichier : `test/features/game/domain/use_cases/check_end_round_test.dart`

- [ ] **SUPPRIMER :** La fonction helper qui expose l'implémentation (lignes 16-29).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Helper function qui expose les détails d'implémentation interne.

- [ ] **SIMPLIFIER :** Le test avec setup de 100+ lignes (lignes 70-163).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Setup trop complexe qui rend le test difficile à comprendre.

- [ ] **FUSIONNER :** Les tests redondants pour la pénalité double (lignes 165-234).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests répétitifs pour le même comportement.

## Fichier : `test/features/game/domain/use_cases/draw_action_card_use_case_test.dart`

- [ ] **MODIFIER :** Les tests vérifiant les appels de repository (lignes 62-96).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie les appels de méthodes plutôt que le comportement résultant.

- [ ] **FUSIONNER :** Les tests de validation redondants (lignes 98-134, 136-166).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Structure identique pour différents cas de validation.

- [ ] **MODIFIER :** Le test vérifiant `drawnCard` interne (lignes 280-316).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Test d'implémentation vérifiant l'état interne.

## Fichier : `test/features/game/domain/use_cases/use_action_card_use_case_test.dart`

- [ ] **MODIFIER :** Le test vérifiant le format de réponse (lignes 91-105).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie la structure plutôt que l'effet de l'action.

- [ ] **FUSIONNER :** Les tests redondants pour "reverse turn direction" (lignes 187-229).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests similaires qui pourraient être paramétrés.

- [ ] **EXTRAIRE :** Le setup complexe en builders réutilisables (lignes 24-59).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Setup complexe répété dans plusieurs tests.

## Fichier : `test/features/game/data/repositories/supabase_game_state_repository_test.dart`

- [ ] **SUPPRIMER :** Le test trivial d'instantiation (lignes 18-21).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test trivial sans valeur ajoutée.

- [ ] **SUPPRIMER :** Le test vérifiant l'existence des méthodes (lignes 23-36).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie l'implémentation plutôt que le comportement.

- [ ] **SUPPRIMER :** Le test vérifiant le type (lignes 38-41).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test trivial du système de types.

## Fichier : `test/features/game/data/models/game_state_model_test.dart`

- [ ] **SUPPRIMER :** Les tests de getters/setters (lignes 65-93).
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests triviaux des propriétés auto-générées.

- [ ] **SIMPLIFIER :** Les tests de sérialisation (lignes 217-294).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie chaque champ individuellement au lieu du comportement global.

- [ ] **MODIFIER :** Le test d'égalité (lignes 336-383).
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Test d'implémentation de equals() plutôt que du comportement métier.

## Fichier : `test/core/config/router_config_test.dart`

- [ ] **MODIFIER :** Les tests de configuration de routes.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester la navigation effective plutôt que la configuration.

## Fichier : `test/core/config/sentry_config_test.dart`

- [ ] **MODIFIER :** Les tests de configuration Sentry.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'envoi d'erreurs plutôt que la configuration.

## Fichier : `test/core/config/supabase_config_test.dart`

- [ ] **MODIFIER :** Les tests de configuration Supabase.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester la connexion plutôt que les valeurs de config.

## Fichier : `test/database/migrations/*_test.dart` (Tous les fichiers de migration)

- [ ] **SUPPRIMER :** Tous les tests de migration SQL.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Ces tests vérifient le SQL plutôt que l'effet des migrations. Doivent être remplacés par des tests d'intégration.

## Fichier : `test/features/game/presentation/providers/action_card_providers_test.dart`

- [ ] **MODIFIER :** Les tests de providers pour tester le comportement.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les changements d'état visibles plutôt que les appels internes.

## Fichier : `test/features/game/presentation/widgets/action_card_widget_test.dart`

- [ ] **FUSIONNER :** Les tests d'affichage redondants.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests similaires pour différents états de carte.

## Fichier : `test/features/game/presentation/widgets/common_area_widget_test.dart`

- [ ] **MODIFIER :** Les tests vérifiant la structure des widgets.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les interactions utilisateur plutôt que la hiérarchie des widgets.

## Fichier : `test/features/end_game/presentation/screens/end_game_screen_test.dart`

- [ ] **FUSIONNER :** Les tests de vérification d'affichage.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests répétitifs pour chaque élément UI.

## Fichier : `test/features/multiplayer/data/models/player_model_test.dart`

- [ ] **FUSIONNER :** Tous les tests de modèle en un test paramétré.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Structure identique pour tous les tests de propriétés.

## Fichier : `test/features/multiplayer/presentation/screens/room_lobby_screen_test.dart`

- [ ] **MODIFIER :** Les tests pour vérifier le comportement utilisateur.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les actions (rejoindre, quitter) plutôt que l'affichage.

## Fichier : `test/features/game/domain/use_cases/distribute_cards_test.dart`

- [ ] **MODIFIER :** Les tests vérifiant la distribution des cartes.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que chaque joueur reçoit bien ses cartes plutôt que le mécanisme de distribution.

## Fichier : `test/features/game/domain/use_cases/end_turn_test.dart`

- [ ] **FUSIONNER :** Les tests de validation du tour (lignes multiples).
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests similaires pour différentes conditions de fin de tour.

## Fichier : `test/features/game/domain/use_cases/game_initialization_use_case_test.dart`

- [ ] **SIMPLIFIER :** Le setup complexe d'initialisation.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Setup trop complexe pour un test d'initialisation.

## Fichier : `test/features/game/domain/use_cases/process_last_round_test.dart`

- [ ] **MODIFIER :** Les tests vérifiant les flags internes.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie les flags plutôt que le comportement observable du dernier tour.

## Fichier : `test/features/game/domain/use_cases/reveal_initial_cards_test.dart`

- [ ] **FUSIONNER :** Les tests de révélation par joueur.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests identiques pour chaque joueur.

## Fichier : `test/features/game/domain/use_cases/start_game_test.dart`

- [ ] **MODIFIER :** Le test vérifiant le changement de statut.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que le jeu est jouable plutôt que le statut interne.

## Fichier : `test/features/game/data/datasources/action_card_local_datasource_impl_test.dart`

- [ ] **SUPPRIMER :** Les tests de chargement JSON.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Test d'implémentation du chargement de fichiers.

## Fichier : `test/features/game/data/datasources/game_state_datasource_test.dart`

- [ ] **SUPPRIMER :** Le test vérifiant l'interface.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test trivial de l'existence de l'interface.

## Fichier : `test/features/game/data/datasources/supabase_action_card_datasource_test.dart`

- [ ] **MODIFIER :** Les tests mockant Supabase.
  - **Justification :** Violation du Principe n°3 (Isoler le Code avec des Mocks). Mocks trop complexes qui testent l'implémentation Supabase.

## Fichier : `test/features/game/data/models/db_player_grid_model_test.dart`

- [ ] **FUSIONNER :** Les tests de conversion to/from JSON.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests répétitifs pour la sérialisation.

## Fichier : `test/features/game/data/models/game_state_model_mapping_test.dart`

- [ ] **SIMPLIFIER :** Les tests de mapping complexes.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests trop détaillés pour chaque champ.

## Fichier : `test/features/game/data/models/player_grid_model_test.dart`

- [ ] **FUSIONNER :** Les tests de modèle similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Structure répétitive pour chaque propriété.

## Fichier : `test/features/game/data/repositories/action_card_repository_impl_test.dart`

- [ ] **MODIFIER :** Les tests vérifiant les appels de datasource.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie les appels plutôt que le résultat.

## Fichier : `test/features/game/data/repositories/server_action_card_repository_test.dart`

- [ ] **FUSIONNER :** Les tests de repository similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Logique identique pour différentes méthodes.

## Fichier : `test/features/game/data/repositories/supabase_action_card_repository_test.dart`

- [ ] **SIMPLIFIER :** Les mocks Supabase complexes.
  - **Justification :** Violation du Principe n°3 (Isoler le Code avec des Mocks). Mocks trop détaillés.

## Fichier : `test/features/game/domain/entities/action_card_test.dart`

- [ ] **SUPPRIMER :** Les tests de propriétés triviales.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests de getters/setters sans valeur.

## Fichier : `test/features/game/domain/entities/card_position_test.dart`

- [ ] **FUSIONNER :** Les tests de position en un seul.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests répétitifs pour x/y.

## Fichier : `test/features/game/domain/entities/card_test.dart`

- [ ] **MODIFIER :** Les tests de création de carte.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'utilisation des cartes, pas leur création.

## Fichier : `test/features/game/domain/entities/deck_state_test.dart`

- [ ] **FUSIONNER :** Les tests d'état du deck.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests similaires pour pioche/défausse.

## Fichier : `test/features/game/domain/entities/game_player_test.dart`

- [ ] **SUPPRIMER :** Les tests de propriétés du joueur.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests triviaux des données.

## Fichier : `test/features/game/domain/entities/game_state_clean_test.dart`

- [ ] **FUSIONNER :** Avec game_state_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Duplication de tests dans deux fichiers.

## Fichier : `test/features/game/domain/entities/play_direction_test.dart`

- [ ] **SUPPRIMER :** Test trivial de l'enum.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test sans valeur ajoutée.

## Fichier : `test/features/game/domain/entities/player_grid_test.dart`

- [ ] **MODIFIER :** Les tests de grille pour tester le comportement.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les actions sur la grille, pas la structure.

## Fichier : `test/features/game/domain/entities/player_state_test.dart`

- [ ] **FUSIONNER :** Les tests d'état similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests répétitifs pour chaque état.

## Fichier : `test/features/game/domain/repositories/action_card_repository_test.dart`

- [ ] **SUPPRIMER :** Test d'interface abstract.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test d'une interface abstraite.

## Fichier : `test/features/game/domain/repositories/game_state_repository_test.dart`

- [ ] **SUPPRIMER :** Test d'interface abstract.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test d'une interface abstraite.

## Fichier : `test/features/game/presentation/integration/selectors_integration_test.dart`

- [ ] **MODIFIER :** Pour tester le comportement utilisateur.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les sélections effectives.

## Fichier : `test/features/game/presentation/providers/card_selection_provider_test.dart`

- [ ] **FUSIONNER :** Les tests de sélection similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Logique répétitive.

## Fichier : `test/features/game/presentation/providers/direction_observer_provider_test.dart`

- [ ] **MODIFIER :** Pour tester l'effet observable.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester le changement de direction visible.

## Fichier : `test/features/game/presentation/providers/game_animation_provider_test.dart`

- [ ] **SIMPLIFIER :** Les tests d'animation complexes.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests trop détaillés pour les animations.

## Fichier : `test/features/game/presentation/providers/repository_providers_test.dart`

- [ ] **SUPPRIMER :** Tests de création de providers.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests triviaux de DI.

## Fichier : `test/features/game/presentation/screens/game_screen_test.dart`

- [ ] **MODIFIER :** Pour tester les interactions de jeu.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester le gameplay, pas l'UI.

## Fichier : `test/features/game/presentation/screens/game_screen_with_teleportation_test.dart`

- [ ] **FUSIONNER :** Avec game_screen_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Séparer par feature crée de la duplication.

## Fichier : `test/features/game/presentation/spectator_view_integration_test.dart`

- [ ] **MODIFIER :** Pour tester l'expérience spectateur.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester ce que voit le spectateur.

## Fichier : `test/features/game/presentation/widgets/action_card_draw_pile_widget_test.dart`

- [ ] **FUSIONNER :** Les tests de widget pile similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests répétitifs.

## Fichier : `test/features/game/presentation/widgets/action_card_hand_widget_test.dart`

- [ ] **MODIFIER :** Pour tester les interactions avec la main.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les actions, pas l'affichage.

## Fichier : `test/features/game/presentation/widgets/card_animation_widget_test.dart`

- [ ] **SIMPLIFIER :** Les tests d'animation détaillés.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Trop de détails sur les animations.

## Fichier : `test/features/game/presentation/widgets/deck_and_discard_widget_test.dart`

- [ ] **FUSIONNER :** Avec les tests de pile individuels.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Duplication avec draw_pile et discard_pile.

## Fichier : `test/features/game/presentation/widgets/direction_change_animation_test.dart`

- [ ] **SUPPRIMER :** Tests d'animation triviaux.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Animation sans logique métier.

## Fichier : `test/features/game/presentation/widgets/discard_pile_widget_test.dart`

- [ ] **MODIFIER :** Pour tester le comportement de défausse.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'action de défausser.

## Fichier : `test/features/game/presentation/widgets/draw_pile_widget_test.dart`

- [ ] **MODIFIER :** Pour tester le comportement de pioche.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'action de piocher.

## Fichier : `test/features/game/presentation/widgets/enhanced_card_widget_test.dart`

- [ ] **FUSIONNER :** Avec card_widget_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Variations du même widget.

## Fichier : `test/features/game/presentation/widgets/enhanced_player_grid_test.dart`

- [ ] **FUSIONNER :** Avec player_grid_widget_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Variations du même widget.

## Fichier : `test/features/game/presentation/widgets/game_animation_overlay_test.dart`

- [ ] **SUPPRIMER :** Tests d'overlay sans comportement.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Pure UI sans logique.

## Fichier : `test/features/game/presentation/widgets/game_selection_overlay_test.dart`

- [ ] **MODIFIER :** Pour tester les sélections effectives.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester ce qui est sélectionné.

## Fichier : `test/features/game/presentation/widgets/opponent_grid_widget_test.dart`

- [ ] **FUSIONNER :** Avec player_grid_widget_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Même logique pour adversaire/joueur.

## Fichier : `test/features/game/presentation/widgets/opponents_view_widget_test.dart`

- [ ] **MODIFIER :** Pour tester la vue multi-adversaires.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les interactions entre adversaires.

## Fichier : `test/features/game/presentation/widgets/player_grid_selection_simple_test.dart`

- [ ] **FUSIONNER :** Avec player_grid_selection_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Duplication de tests de sélection.

## Fichier : `test/features/game/presentation/widgets/player_grid_selection_test.dart`

- [ ] **MODIFIER :** Pour tester les sélections métier.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'impact des sélections.

## Fichier : `test/features/game/presentation/widgets/player_grid_with_selection_test.dart`

- [ ] **FUSIONNER :** Avec player_grid_widget_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Variation du même widget.

## Fichier : `test/features/game/presentation/widgets/player_hand_widget_test.dart`

- [ ] **MODIFIER :** Pour tester la gestion de la main.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les actions sur les cartes en main.

## Fichier : `test/features/game/presentation/widgets/turn_info_widget_test.dart`

- [ ] **SIMPLIFIER :** Les tests d'affichage d'info.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests triviaux d'affichage.

## Fichier : `test/features/game/presentation/widgets/visual_feedback_widget_test.dart`

- [ ] **SUPPRIMER :** Tests de feedback visuel pur.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Pure UI sans comportement.

## Fichier : `test/features/game/presentation/widgets/widgets_test.dart`

- [ ] **SUPPRIMER :** Fichier de test générique.
  - **Justification :** Violation du Principe n°5 (Clarté). Nom et contenu peu clairs.

## Fichier : `test/features/global_scores/data/datasources/global_score_remote_datasource_test.dart`

- [ ] **MODIFIER :** Pour tester la récupération de scores.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les données récupérées.

## Fichier : `test/features/global_scores/data/datasources/supabase_global_score_datasource_test.dart`

- [ ] **SIMPLIFIER :** Les mocks Supabase.
  - **Justification :** Violation du Principe n°3 (Isoler le Code avec des Mocks). Mocks trop complexes.

## Fichier : `test/features/global_scores/data/models/global_score_model_test.dart`

- [ ] **FUSIONNER :** Les tests de modèle répétitifs.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Structure identique pour chaque test.

## Fichier : `test/features/global_scores/data/repositories/supabase_global_score_repository_test.dart`

- [ ] **MODIFIER :** Pour tester le comportement du repository.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie les appels plutôt que les résultats.

## Fichier : `test/features/global_scores/domain/entities/global_score_test.dart`

- [ ] **SUPPRIMER :** Tests de propriétés triviales.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests de données sans logique.

## Fichier : `test/features/global_scores/domain/repositories/global_score_repository_test.dart`

- [ ] **SUPPRIMER :** Test d'interface abstraite.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Interface sans implémentation.

## Fichier : `test/features/global_scores/domain/use_cases/get_player_stats_test.dart`

- [ ] **MODIFIER :** Pour tester les statistiques métier.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester la valeur des stats.

## Fichier : `test/features/global_scores/domain/use_cases/get_top_players_test.dart`

- [ ] **FUSIONNER :** Les tests de classement similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests répétitifs pour le top.

## Fichier : `test/features/global_scores/domain/use_cases/save_global_score_test.dart`

- [ ] **MODIFIER :** Pour tester la sauvegarde effective.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que le score est sauvé.

## Fichier : `test/features/global_scores/presentation/providers/global_score_providers_test.dart`

- [ ] **SIMPLIFIER :** Les tests de providers.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests trop détaillés pour les providers.

## Fichier : `test/features/global_scores/presentation/screens/game_history_screen_test.dart`

- [ ] **MODIFIER :** Pour tester l'affichage de l'historique.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les données affichées.

## Fichier : `test/features/global_scores/presentation/screens/leaderboard_screen_test.dart`

- [ ] **MODIFIER :** Pour tester le classement affiché.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'ordre et les scores.

## Fichier : `test/features/home/presentation/navigation_integration_test.dart`

- [ ] **FUSIONNER :** Avec navigation_simple_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Duplication de tests de navigation.

## Fichier : `test/features/home/presentation/navigation_simple_test.dart`

- [ ] **MODIFIER :** Pour tester la navigation effective.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester où l'utilisateur arrive.

## Fichier : `test/features/home/presentation/screens/home_screen_test.dart`

- [ ] **MODIFIER :** Pour tester les actions du menu principal.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les actions disponibles.

## Fichier : `test/features/multiplayer/data/converters/game_state_converter_test.dart`

- [ ] **FUSIONNER :** Les tests de conversion répétitifs.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Tests similaires pour chaque direction.

## Fichier : `test/features/multiplayer/data/datasources/player_datasource_test.dart`

- [ ] **SUPPRIMER :** Test d'interface abstraite.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Interface sans implémentation.

## Fichier : `test/features/multiplayer/data/datasources/supabase_player_datasource_test.dart`

- [ ] **SIMPLIFIER :** Les mocks Supabase complexes.
  - **Justification :** Violation du Principe n°3 (Isoler le Code avec des Mocks). Sur-spécification des mocks.

## Fichier : `test/features/multiplayer/data/datasources/supabase_room_datasource_impl_test.dart`

- [ ] **FUSIONNER :** Avec supabase_room_datasource_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Duplication interface/impl.

## Fichier : `test/features/multiplayer/data/models/room_model_extensions_test.dart`

- [ ] **FUSIONNER :** Avec room_model_test.dart.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Extensions font partie du modèle.

## Fichier : `test/features/multiplayer/data/repositories/room_repository_impl_test.dart`

- [ ] **MODIFIER :** Pour tester le comportement du repository.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Vérifie les appels plutôt que les effets.

## Fichier : `test/features/multiplayer/domain/datasources/room_datasource_test.dart`

- [ ] **SUPPRIMER :** Test d'interface abstraite.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Interface sans implémentation.

## Fichier : `test/features/multiplayer/domain/entities/lobby_player_test.dart`

- [ ] **SUPPRIMER :** Tests de propriétés triviales.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests de données sans logique.

## Fichier : `test/features/multiplayer/domain/entities/room_event_test.dart`

- [ ] **FUSIONNER :** Les tests d'événements similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Structure répétitive pour chaque event.

## Fichier : `test/features/multiplayer/domain/entities/room_test.dart`

- [ ] **MODIFIER :** Pour tester le comportement de la room.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les actions dans la room.

## Fichier : `test/features/multiplayer/domain/repositories/room_repository_test.dart`

- [ ] **SUPPRIMER :** Test d'interface abstraite.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Interface sans implémentation.

## Fichier : `test/features/multiplayer/domain/use_cases/create_room_use_case_test.dart`

- [ ] **MODIFIER :** Pour tester la création effective de room.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que la room est créée et accessible.

## Fichier : `test/features/multiplayer/domain/use_cases/join_room_use_case_test.dart`

- [ ] **MODIFIER :** Pour tester l'ajout du joueur à la room.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que le joueur est bien dans la room.

## Fichier : `test/features/multiplayer/domain/use_cases/sync_game_state_use_case_test.dart`

- [ ] **MODIFIER :** Pour tester la synchronisation effective.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que les états sont synchronisés.

## Fichier : `test/features/multiplayer/presentation/providers/multiplayer_game_notifier_test.dart`

- [ ] **SIMPLIFIER :** Les tests de notifier complexes.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests trop détaillés du state management.

## Fichier : `test/features/multiplayer/presentation/providers/room_providers_test.dart`

- [ ] **FUSIONNER :** Les tests de providers similaires.
  - **Justification :** Violation du Principe n°2 (Éliminer la Redondance). Structure répétitive.

## Fichier : `test/features/multiplayer/presentation/screens/create_room_screen_test.dart`

- [ ] **MODIFIER :** Pour tester la création de room par l'UI.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'action de création.

## Fichier : `test/features/multiplayer/presentation/screens/join_room_screen_test.dart`

- [ ] **MODIFIER :** Pour tester l'action de rejoindre.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que l'utilisateur rejoint la room.

## Fichier : `test/features/multiplayer/simple_integration_test.dart`

- [ ] **RENOMMER :** Nom plus descriptif du test.
  - **Justification :** Violation du Principe n°5 (Clarté). "simple" n'est pas descriptif.

## Fichier : `test/features/end_game/domain/entities/end_game_state_test.dart`

- [ ] **MODIFIER :** Pour tester les transitions d'état de fin.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester les règles de fin de partie.

## Fichier : `test/features/end_game/presentation/integration/save_global_score_integration_test.dart`

- [ ] **MODIFIER :** Pour tester la sauvegarde complète.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier la persistance du score.

## Fichier : `test/features/end_game/presentation/providers/end_game_provider_test.dart`

- [ ] **SIMPLIFIER :** Les tests de provider end game.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Tests trop détaillés.

## Fichier : `test/features/end_game/presentation/widgets/player_score_card_test.dart`

- [ ] **MODIFIER :** Pour tester l'affichage du score.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier les informations affichées.

## Fichier : `test/features/end_game/presentation/widgets/vote_section_test.dart`

- [ ] **MODIFIER :** Pour tester le système de vote.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'enregistrement des votes.

## Fichier : `test/features/end_game/presentation/widgets/winner_announcement_test.dart`

- [ ] **MODIFIER :** Pour tester l'annonce du gagnant.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que le bon gagnant est affiché.

## Fichier : `test/features/auth/presentation/providers/auth_provider_test.dart`

- [ ] **MODIFIER :** Pour tester l'authentification effective.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier que l'utilisateur est connecté.

## Fichier : `test/core/providers/supabase_provider_test.dart`

- [ ] **SUPPRIMER :** Test de création de provider trivial.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Test de DI sans valeur.

## Fichier : `test/core/usecases/usecase_test.dart`

- [ ] **SUPPRIMER :** Test d'interface abstraite.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Interface générique sans comportement.

## Fichier : `test/core/utils/constants_test.dart`

- [ ] **SUPPRIMER :** Tests de constantes.
  - **Justification :** Violation du Principe n°4 (Bonne Granularité). Les constantes ne changent pas.

## Fichier : `test/core/utils/extensions_test.dart`

- [ ] **MODIFIER :** Pour tester le comportement des extensions.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit tester l'effet des extensions.

## Fichier : `test/integration/database_functions_integration_test.dart`

- [ ] **MODIFIER :** Pour tester les effets des fonctions DB.
  - **Justification :** Violation du Principe n°1 (Tester le Comportement). Doit vérifier les changements en base.

## Fichier : `test/integration/end_to_end_game_experience_test.dart`

- [ ] **RENFORCER :** Avec plus de scénarios métier.
  - **Justification :** Test E2E précieux qui doit couvrir plus de cas d'usage réels.

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

- [ ] **CRÉER :** Un guide de bonnes pratiques TDD spécifique au projet.
  - **Justification :** Assurer la cohérence future et éviter la réintroduction des mêmes problèmes.

- [ ] **IMPLÉMENTER :** Des tests paramétrés pour tous les cas similaires.
  - **Justification :** Principe n°2 (Éliminer la Redondance). Réduire drastiquement la duplication.

- [ ] **CRÉER :** Des custom matchers pour les assertions métier.
  - **Justification :** Principe n°5 (Clarté). Rendre les assertions plus expressives et métier.

## Métriques d'Amélioration Attendues

- **Réduction du nombre de fichiers de test** : ~35% par suppression des tests triviaux
- **Réduction des lignes de code de test** : ~50% par élimination de la redondance
- **Amélioration du temps d'exécution** : ~40% (moins de tests, plus ciblés)
- **Amélioration de la maintenabilité** : Réduction de 70% du temps de modification des tests
- **Couverture comportementale** : Passage de 20% à 90% de tests comportementaux
- **Réduction des faux positifs** : Élimination de 95% des tests qui cassent lors de refactoring interne