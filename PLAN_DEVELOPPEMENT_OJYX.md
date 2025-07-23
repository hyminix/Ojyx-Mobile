# Plan de Développement Ojyx - État Détaillé

## 📋 Plan Initial (19 Tâches)

### Phase 1 : Fondations (Tâches 1-4) ✅ COMPLÉTÉES
1. **Modélisation du Domaine** - Créer les entités du jeu
2. **Logique de Distribution** - Implémenter la distribution initiale  
3. **Mécaniques de Pioche et Défausse** - Actions de base du tour
4. **Détection de Fin de Manche** - Conditions de fin et calcul des scores

### Phase 2 : Multijoueur (Tâches 5-6) ✅ COMPLÉTÉES
5. **Synchronisation Temps Réel** - Infrastructure Supabase
6. **Écran d'Accueil et Navigation** - Interface utilisateur de base

### Phase 3 : Interface de Jeu (Tâches 7-10) 🚧 EN COURS
7. **Interface de Jeu - Grille Personnelle** ✅ COMPLÉTÉE
8. **Vue Spectateur Dynamique** ✅ COMPLÉTÉE
9. **Zones de Pioche et Défausse** ✅ COMPLÉTÉE (avec problèmes)
10. **Infrastructure Cartes Actions** ❌ NON COMMENCÉE

### Phase 4 : Cartes Actions (Tâches 11-13) ❌ NON COMMENCÉES
11. **Implémentation Demi-tour** - Première carte action
12. **Implémentation Téléportation** - Carte avec sélection
13. **UI Sélecteurs et Feedback** - Interfaces dynamiques

### Phase 5 : Fin de Partie (Tâches 14-15) ❌ NON COMMENCÉES
14. **Écran de Fin de Partie** - Récapitulatif et scores
15. **Système de Points Globaux** - Suivi entre manches

### Phase 6 : Production (Tâches 16-19) ❌ NON COMMENCÉES
16. **Animations et Polish** - Amélioration UX
17. **Mode Hors-ligne** - Support déconnexion
18. **Tests d'Intégration Complets**
19. **Déploiement Production**

## ✅ Ce qui a été implémenté

### Tâche 1 : Modélisation du Domaine
- ✅ `Card` : Entité carte avec value (-2 à 12) et isRevealed
- ✅ `PlayerGrid` : Grille 3x4 avec détection colonnes identiques
- ✅ `Player` : Joueur avec grille, cartes actions, score
- ✅ `GameState` : État global avec joueurs, deck, défausse
- ✅ `Room` : Salle multijoueur avec statuts
- ✅ `ActionCard` : Cartes actions avec types
- ✅ Tests unitaires complets (100% coverage)

### Tâche 2 : Logique de Distribution
- ✅ `GameInitializationUseCase` : Distribution initiale
- ✅ Création deck 150 cartes selon distribution
- ✅ Distribution 12 cartes/joueur
- ✅ Révélation 2 cartes initiales
- ✅ Tests unitaires complets

### Tâche 3 : Mécaniques de Pioche et Défausse
- ✅ `DrawCardUseCase` : Piocher du deck
- ✅ `DrawFromDiscardUseCase` : Piocher de la défausse
- ✅ `DiscardCardUseCase` : Défausser après échange
- ✅ Gestion du tour de jeu
- ✅ Tests unitaires complets

### Tâche 4 : Détection de Fin de Manche
- ✅ `EndRoundDetectionUseCase` : Détection 12 cartes révélées
- ✅ `CalculateScoresUseCase` : Calcul avec pénalité x2
- ✅ Gestion dernier tour
- ✅ Tests unitaires complets

### Tâche 5 : Synchronisation Temps Réel
- ✅ Configuration Supabase
- ✅ `RoomRepository` avec Realtime
- ✅ Modèles Room et RoomEvent
- ✅ Synchronisation GameState
- ✅ Tests d'intégration créés

### Tâche 6 : Écran d'Accueil et Navigation
- ✅ `HomeScreen` avec options Créer/Rejoindre
- ✅ `CreateRoomScreen` avec formulaire
- ✅ `JoinRoomScreen` avec code
- ✅ `LobbyScreen` d'attente
- ✅ Navigation go_router
- ✅ 9 fichiers de tests créés

### Tâche 7 : Interface de Jeu - Grille Personnelle
- ✅ `PlayerGridWidget` : Affichage grille 3x4
- ✅ `CardWidget` : Carte avec animations
- ✅ Détection colonnes identiques
- ✅ Animations reveal/hide
- ✅ 5 fichiers de tests créés

### Tâche 8 : Vue Spectateur Dynamique
- ✅ `OpponentsViewWidget` : Vue adversaires
- ✅ `OpponentGridWidget` : Grille miniature
- ✅ Indicateurs tour et score
- ✅ Vue responsive
- ✅ 4 fichiers de tests créés

### Tâche 9 : Zones de Pioche et Défausse
- ✅ `DeckState` : Gestion des piles
- ✅ `DrawPileWidget` : Pile de pioche
- ✅ `DiscardPileWidget` : Pile de défausse
- ✅ `CommonAreaWidget` : Zone commune
- ⚠️ PROBLÈME : Tests échouent (47/59 passent)

## 🚧 Problèmes actuels

### 1. Tests qui échouent (68 tests au total)
- **StateNotifierProvider obsolète** : Migration Riverpod 2.x incomplète
  - `currentRoomIdProvider` utilise StateNotifierProvider qui n'existe plus
  - Solution : Utiliser `NotifierProvider` ou `Provider`

- **Propriétés Card supprimées** : 
  - Tests utilisent `color` et `type` qui n'existent plus
  - `color` est maintenant calculée via extension
  - `type` (CardType) a été supprimé

- **MockGoRouter incorrect** :
  - Hérite de GoRouter au lieu de Mock
  - Signatures de méthodes incorrectes

- **Paramètres widget obsolètes** :
  - `DeckAndDiscardWidget` : `canDrawFromDeck` → `canDraw`
  - `TurnInfoWidget` : `roundNumber`, `turnCount`, `isEndRound` n'existent pas

- **Chemins d'import incorrects** :
  - `spectator_view_integration_test.dart` : mauvais chemin vers test_helpers

### 2. Architecture TDD violée
- Tests commentés au lieu d'être réparés
- Fichiers test_summary créés (maintenant supprimés)
- DragTarget causant des tests qui hang

### 3. État actuel des tests
- ✅ 234 tests passent
- ❌ 68 tests échouent
- Principaux échecs dans :
  - Tests d'intégration draw/discard
  - Tests GameScreen 
  - Tests spectator view
  - widget_test.dart (smoke test)

## 📝 Ce qui reste à faire

### Correction immédiate (Priorité HAUTE)
1. **Finaliser migration Riverpod 2.x**
   - Remplacer tous les StateNotifierProvider
   - Utiliser les nouveaux patterns Riverpod

2. **Corriger tous les tests échouants**
   - Adapter tests aux nouvelles APIs
   - Corriger imports et chemins
   - Mettre à jour les expectations

3. **Valider 100% des tests**
   - Aucun test commenté
   - Coverage minimum 80%
   - CI/CD au vert

### Suite du plan (Tâches 10-19)
**Tâche 10 : Infrastructure Cartes Actions**
- Créer `ActionCardRepository`
- Implémenter `UseActionCardUseCase`
- Gérer stock maximum 3 cartes
- Tests TDD complets

**Tâche 11 : Implémentation Demi-tour**
- Carte obligatoire (activation immédiate)
- Inverser direction du tour
- UI feedback animation
- Tests complets

**Tâche 12 : Implémentation Téléportation**
- Carte optionnelle (stockable)
- UI sélection 2 cartes
- Échange de positions
- Tests complets

**Tâche 13 : UI Sélecteurs et Feedback**
- Overlay de sélection
- Animations d'actions
- Feedback visuel temps réel
- Tests complets

**Tâches 14-19 : À détailler lors de l'implémentation**

## 🔧 Configuration technique actuelle

### Stack
- Flutter 3.x
- Riverpod 2.x (migration en cours)
- Freezed + json_serializable
- go_router
- Supabase (Realtime, Auth, Database)
- Sentry Flutter

### Architecture
- Clean Architecture stricte
- TDD obligatoire (RED-GREEN-REFACTOR)
- Feature-based organization
- Separation Domain/Data/Presentation

### Commandes essentielles
```bash
# Tests
flutter test

# Génération de code
flutter pub run build_runner build --delete-conflicting-outputs

# Analyse
flutter analyze

# Format
dart format .
```

## 🎯 Prochaines étapes recommandées

1. **Corriger tous les tests** (2-3h)
   - Migration Riverpod complète
   - Adaptation aux nouvelles APIs
   - Validation 100% tests verts

2. **Tâche 10 : Infrastructure Cartes Actions** (4-6h)
   - TDD strict dès le début
   - Architecture propre
   - Tests d'intégration

3. **Tâches 11-13 : Cartes Actions** (8-10h total)
   - Une carte à la fois
   - UI/UX soignée
   - Tests complets

4. **Review architecture** (2h)
   - Vérifier cohérence
   - Documenter décisions
   - Préparer phase finale

## 📌 Notes importantes

- **TDD OBLIGATOIRE** : Aucun code sans test préalable
- **Clean Architecture** : Respecter la séparation des couches
- **Pas de dette technique** : Corriger immédiatement les problèmes
- **Documentation** : Maintenir CLAUDE.md à jour
- **Git workflow** : PR obligatoires, CI/CD doit passer

---

*Document généré le 2025-07-22 pour reprendre le développement exactement où nous en sommes.*