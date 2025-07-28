# Inventaire des Policies RLS à Optimiser

## Date: 2025-07-28

## Résumé
- **18 policies** contenant auth.uid() non optimisé (pas 19 comme prévu)
- **5 tables** avec policies multiples à consolider
- **Total d'occurrences auth.uid()** : 45 à remplacer

## 1. Policies à Optimiser avec (SELECT auth.uid())

### Par Table

#### cards_in_play (1 policy)
- `Players in game can view cards` - SELECT - 2 occurrences

#### decks (1 policy)
- `Players in game can view decks` - SELECT - 2 occurrences

#### event_participations (1 policy)
- `Authenticated users can manage participations` - ALL - 2 occurrences

#### game_actions (2 policies)
- `Players in game can insert actions` - INSERT - 2 occurrences
- `Players in game can view actions` - SELECT - 2 occurrences

#### game_states (3 policies)
- `Players in room can create game states` - INSERT - 2 occurrences
- `Players in room can update game states` - UPDATE - 4 occurrences
- `Players in room can view game states` - SELECT - 2 occurrences

#### global_scores (2 policies)
- `Authenticated users can insert scores` - INSERT - 1 occurrence
- `Players can delete scores in their rooms` - DELETE - 2 occurrences

#### player_grids (1 policy)
- `Players in game can manage player grids` - ALL - 4 occurrences

#### players (1 policy)
- `update_players_policy` - UPDATE - 5 occurrences

#### room_events (2 policies)
- `Players in room can insert events` - INSERT - 2 occurrences
- `Players in room can view events` - SELECT - 2 occurrences

#### rooms (4 policies)
- `Authenticated users can create rooms` - INSERT - 1 occurrence
- `Room creator can delete room` - DELETE - 1 occurrence
- `Room participants can update room` - UPDATE - 4 occurrences
- `View waiting rooms or joined rooms` - SELECT - 2 occurrences

## 2. Policies Multiples à Consolider (5 cas)

### room_events
1. **INSERT** (2 policies):
   - `Anyone can create room events`
   - `Players in room can insert events`

2. **SELECT** (2 policies):
   - `Anyone can view room events`
   - `Players in room can view events`

### rooms
3. **INSERT** (2 policies):
   - `Anyone can create rooms`
   - `Authenticated users can create rooms`

4. **SELECT** (2 policies):
   - `Anyone can view rooms`
   - `View waiting rooms or joined rooms`

5. **UPDATE** (2 policies):
   - `Anyone can update rooms`
   - `Room participants can update room`

## 3. Priorité d'Optimisation

### Haute Priorité (Plus de 3 occurrences)
1. `players.update_players_policy` - 5 occurrences
2. `player_grids.Players in game can manage player grids` - 4 occurrences
3. `game_states.Players in room can update game states` - 4 occurrences
4. `rooms.Room participants can update room` - 4 occurrences

### Moyenne Priorité (2-3 occurrences)
- Toutes les autres policies listées

### Basse Priorité (1 occurrence)
- `global_scores.Authenticated users can insert scores`
- `rooms.Authenticated users can create rooms`
- `rooms.Room creator can delete room`

## 4. Estimation d'Impact

- **Requêtes impactées** : Toutes les opérations CRUD sur les 10 tables
- **Gain potentiel** : 10-30% de réduction du temps d'exécution des requêtes RLS
- **Risque** : Faible si tests appropriés sont effectués

## 5. Prochaines Étapes

1. Créer des benchmarks avant optimisation
2. Développer le script de remplacement automatique
3. Tester sur environnement de développement
4. Consolider les policies multiples
5. Déployer progressivement avec monitoring