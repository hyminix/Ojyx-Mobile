# Architecture de Synchronisation Multijoueur - Ojyx

## Vue d'ensemble

Le système multijoueur d'Ojyx utilise une architecture hybride combinant l'état optimiste local avec la synchronisation temps réel via Supabase. Cette approche garantit une expérience utilisateur fluide tout en maintenant la cohérence des données entre tous les joueurs.

### Composants principaux

```mermaid
graph TB
    Client[Client Flutter] --> OSS[OptimisticStateSystem]
    OSS --> GSS[GameSyncService]
    GSS --> RRS[RoomRealtimeService]
    RRS --> SP[Supabase Postgres]
    RRS --> SRT[Supabase Realtime]
    SP --> RLS[RLS Policies]
    Client --> EMM[ErrorMonitor]
    EMM --> Sentry[Sentry]
    
    subgraph "État Local"
        OSS --> LocalState[État Optimiste]
        LocalState --> ActionQueue[Queue d'Actions]
    end
    
    subgraph "Backend Supabase"
        SP --> Tables[Tables BDD]
        SRT --> Channels[Canaux RT]
        RLS --> Validation[Validation RLS]
    end
```

## Architecture Technique

### 1. Couche Client (Flutter)

```mermaid
graph LR
    UI[Interface Utilisateur] --> Provider[Riverpod Provider]
    Provider --> Notifier[StateNotifier]
    Notifier --> OptState[OptimisticState<T>]
    OptState --> LocalValue[Valeur Locale]
    OptState --> ServerValue[Valeur Serveur]
    OptState --> SyncStatus[Statut Sync]
```

### 2. Couche Synchronisation

```mermaid
graph TD
    Action[Action Utilisateur] --> Validate{Validation Locale}
    Validate -->|Valide| Apply[Appliquer Optimiste]
    Validate -->|Invalide| Reject[Rejeter Action]
    Apply --> Queue[Ajouter à Queue]
    Queue --> Send[Envoyer à Serveur]
    Send --> Success{Succès?}
    Success -->|Oui| Confirm[Confirmer État]
    Success -->|Non| Retry[Retry avec Backoff]
    Retry --> MaxRetry{Max Retry?}
    MaxRetry -->|Non| Send
    MaxRetry -->|Oui| Rollback[Rollback État]
```

## Flux de Données Détaillés

### 1. Action Locale → État Optimiste

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant UI as Interface
    participant ON as OptimisticNotifier
    participant OS as OptimisticState
    participant GS as GameSyncService
    
    U->>UI: Révéler carte (row: 1, col: 2)
    UI->>ON: applyOptimisticAction(RevealCardAction)
    ON->>OS: canApply()?
    OS-->>ON: true
    ON->>OS: apply() → nouvel état
    ON->>UI: État mis à jour (optimiste)
    UI->>U: Carte révélée immédiatement
    ON->>GS: sendEvent(RevealCardEvent)
    
    Note over ON,GS: État optimiste affiché<br/>pendant synchronisation
```

### 2. Broadcast Supabase Realtime

```mermaid
sequenceDiagram
    participant GS as GameSyncService
    participant RRS as RoomRealtimeService
    participant SRT as Supabase Realtime
    participant PG as PostgreSQL
    participant C2 as Client 2
    
    GS->>RRS: sendGameAction(reveal_card)
    RRS->>PG: INSERT INTO game_actions
    PG->>PG: Valider RLS policies
    PG-->>RRS: Action enregistrée
    RRS->>SRT: Broadcast via channel
    SRT->>C2: Event reçu
    C2->>C2: Appliquer changement
    
    Note over PG: Validation serveur<br/>obligatoire
```

### 3. Validation Serveur & Cohérence

```mermaid
sequenceDiagram
    participant C1 as Client 1 (Acteur)
    participant PG as PostgreSQL
    participant RLS as RLS Policies
    participant C2 as Client 2 (Observer)
    
    C1->>PG: INSERT game_action
    PG->>RLS: Vérifier permissions
    
    alt Action Autorisée
        RLS-->>PG: ✅ Autoriser
        PG->>PG: Écrire en base
        PG->>C1: Confirmation
        PG->>C2: Broadcast changement
        C2->>C2: Synchroniser état
    else Action Interdite
        RLS-->>PG: ❌ Refuser
        PG->>C1: Erreur RLS
        C1->>C1: Rollback optimiste
    end
```

### 4. Synchronisation Multi-Clients

```mermaid
graph TD
    subgraph "Client A"
        StateA[État Local A]
        QueueA[Queue Actions A]
    end
    
    subgraph "Client B"  
        StateB[État Local B]
        QueueB[Queue Actions B]
    end
    
    subgraph "Serveur Supabase"
        Database[(Base de Données)]
        Realtime[Realtime Engine]
    end
    
    StateA --> QueueA
    QueueA --> Database
    Database --> Realtime
    Realtime --> StateB
    
    StateB --> QueueB  
    QueueB --> Database
    Realtime --> StateA
    
    Database --> RLSCheck{RLS Validation}
    RLSCheck -->|✅| Realtime
    RLSCheck -->|❌| Reject[Rejeter & Notifier]
```

## Points de Synchronisation Critiques

### 1. Révélation de Cartes

**Timing critique** : L'ordre de révélation doit être respecté pour éviter les avantages inéquitables.

```mermaid
sequenceDiagram
    participant P1 as Joueur 1
    participant P2 as Joueur 2
    participant Server as Serveur
    
    Note over P1,Server: Tour de Joueur 1
    P1->>Server: Révéler carte (2,3)
    Server->>Server: Valider tour + position
    Server->>P1: ✅ Confirmé
    Server->>P2: Broadcast: Carte révélée
    
    Note over P1,Server: Changement de tour
    Server->>Server: current_player_index++
    Server->>P1: Broadcast: Tour de P2
    Server->>P2: Broadcast: À votre tour
```

**Points de contrôle** :
- ✅ Vérifier que c'est le tour du joueur
- ✅ Valider que la carte n'est pas déjà révélée
- ✅ Contrôler la position (0-2, 0-3)
- ✅ Mettre à jour le tour après l'action

### 2. Actions de Cartes

**Complexité** : Les cartes actions peuvent affecter plusieurs joueurs simultanément.

```mermaid
flowchart TD
    ActionCard[Carte Action Jouée] --> ValidateStock{Stock ≤ 3?}
    ValidateStock -->|Non| Discard[Défausser excès]
    ValidateStock -->|Oui| CheckType{Type carte?}
    
    CheckType -->|Swap| ValidateTargets{Cibles valides?}
    CheckType -->|Peek| ValidateTarget{Cible valide?}
    CheckType -->|Reveal| ValidateOpponent{Adversaire valide?}
    CheckType -->|TurnDirection| DirectApply[Appliquer direct]
    
    ValidateTargets -->|Oui| ApplySwap[Échanger cartes]
    ValidateTarget -->|Oui| ApplyPeek[Révéler temporaire]
    ValidateOpponent -->|Oui| ApplyReveal[Révéler permanent]
    DirectApply --> BroadcastAll[Broadcast à tous]
    
    ApplySwap --> BroadcastAll
    ApplyPeek --> BroadcastAll
    ApplyReveal --> BroadcastAll
    
    BroadcastAll --> UpdateGameState[Mettre à jour état]
```

### 3. Validation de Colonnes

**Règle métier** : 3 cartes identiques révélées = colonne défaussée (0 points).

```mermaid
sequenceDiagram
    participant Player as Joueur
    participant Game as GameState
    participant Validator as ColumnValidator
    participant All as Tous Joueurs
    
    Player->>Game: Révéler carte
    Game->>Validator: checkColumn(playerId, col)
    Validator->>Validator: Compter cartes révélées
    
    alt 3 cartes identiques
        Validator->>Game: ✅ Colonne complète
        Game->>Game: Défausser colonne
        Game->>All: Broadcast: Colonne défaussée
        Game->>Game: Recalculer scores
    else Pas encore complète
        Validator->>Game: ℹ️ Continuer
    end
```

### 4. Fin de Manche

**Déclenchement** : Quand un joueur révèle sa 12ème carte.

```mermaid
flowchart TD
    RevealCard[Révéler 12ème carte] --> TriggerEnd[Déclencher fin manche]
    TriggerEnd --> LastTurn[Dernier tour pour autres]
    LastTurn --> CalculateScores[Calculer scores finaux]
    CalculateScores --> CheckPenalty{Initiateur = plus bas?}
    
    CheckPenalty -->|Oui| NormalEnd[Fin normale]
    CheckPenalty -->|Non| DoublePenalty[Score × 2 pour initiateur]
    
    NormalEnd --> BroadcastResults[Broadcast résultats]
    DoublePenalty --> BroadcastResults
    BroadcastResults --> UpdateGlobalScores[MAJ scores globaux]
```

## Mécanismes de Récupération

### 1. Rollback Automatique

```mermaid
stateDiagram-v2
    [*] --> Optimistic: Action locale
    Optimistic --> Syncing: Envoi serveur
    Syncing --> Confirmed: Succès serveur
    Syncing --> Retrying: Échec temporaire
    Retrying --> Syncing: Retry
    Retrying --> RollbackState: Max retry atteint
    RollbackState --> ServerValue: Restaurer état serveur
    Confirmed --> [*]
    ServerValue --> [*]
```

### 2. Gestion des Déconnexions

```mermaid
sequenceDiagram
    participant Client as Client
    participant Monitor as ConnectionMonitor  
    participant Server as Serveur
    participant Storage as LocalStorage
    
    Client->>Monitor: Perte connexion détectée
    Monitor->>Storage: Sauvegarder actions en attente
    Monitor->>Client: Mode offline activé
    
    loop Tentatives reconnexion
        Monitor->>Server: Ping connexion
        Server-->>Monitor: Timeout/Succès
    end
    
    Monitor->>Server: ✅ Reconnexion réussie
    Monitor->>Storage: Charger actions en attente
    Storage->>Client: Restaurer queue
    Client->>Server: Resynchroniser état
```

### 3. Résolution de Conflits

```mermaid
graph TD
    Conflict[Conflit détecté] --> CompareVersions{Comparer versions}
    CompareVersions -->|Local > Serveur| KeepLocal[Garder local]
    CompareVersions -->|Serveur > Local| UseServer[Utiliser serveur]  
    CompareVersions -->|Égales| CompareTimestamp{Comparer timestamps}
    
    CompareTimestamp -->|Local plus récent| KeepLocal
    CompareTimestamp -->|Serveur plus récent| UseServer
    CompareTimestamp -->|Même timestamp| ServerWins[Serveur gagne]
    
    KeepLocal --> NotifyConflict[Notifier conflit résolu]
    UseServer --> NotifyConflict  
    ServerWins --> NotifyConflict
    NotifyConflict --> ContinueGame[Continuer partie]
```

## Monitoring et Observabilité

### 1. Métriques Clés

```mermaid
graph LR
    subgraph "Métriques Performance"
        SyncLatency[Latence Sync]
        RetryRate[Taux Retry]
        RollbackRate[Taux Rollback]
    end
    
    subgraph "Métriques Fiabilité"
        ConnectionUptime[Uptime Connexion]
        SyncSuccessRate[Taux Succès Sync]
        DataConsistency[Cohérence Données]
    end
    
    subgraph "Métriques Business"
        ActiveSessions[Sessions Actives]
        GamesCompleted[Parties Terminées]
        PlayerRetention[Rétention Joueurs]
    end
```

### 2. Points de Télémétrie

- **Synchronisation** : Temps de round-trip, échecs, retries
- **État Optimiste** : Nombre d'actions en attente, rollbacks
- **Realtime** : Latence messages, déconnexions, reconnexions
- **Base de Données** : Temps requêtes RLS, violations, performances
- **Expérience Utilisateur** : Temps de réponse UI, erreurs visibles

## Configuration des Environnements

### Développement
- **Sentry** : Mode debug, capture 100% des erreurs
- **Supabase** : Instance de développement, logs verbeux
- **Monitoring** : Dashboards locaux, alertes désactivées

### Staging  
- **Sentry** : Mode release, échantillonnage 50%
- **Supabase** : Instance de test, monitoring activé
- **Load Testing** : Tests de charge automatisés

### Production
- **Sentry** : Mode release optimisé, échantillonnage 10%
- **Supabase** : Instance production, alertes configurées
- **Monitoring** : Dashboards temps réel, escalades automatiques

## Références Techniques

- **GameSyncService** : `lib/features/multiplayer/data/services/game_sync_service.dart`
- **OptimisticState** : `lib/features/game/presentation/providers/optimistic_game_state_notifier.dart`
- **RLS Policies** : `supabase/migrations/` - Politiques de sécurité
- **Error Monitoring** : `lib/core/monitoring/multiplayer_error_monitor.dart`
- **Tests Intégration** : `test/integration/multiplayer/` - Suite de tests complète