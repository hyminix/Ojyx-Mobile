# **📋 Description Complète du Projet Ojyx \- Product Owner Perspective**

## **🎯 Vision Produit**

**Ojyx** est un jeu de cartes multijoueur, inspiré du Skyjo, conçu pour offrir une expérience de jeu **native et optimisée pour l'écosystème mobile Android**, avec une future extension prévue pour iOS. Le projet vise à créer un écosystème de jeu social où les joueurs peuvent s'affronter dans des parties rapides et stratégiques, enrichies par un système innovant de cartes actions et une interface pensée pour le tactile.

## **🎮 Description du Jeu**

### **Concept Principal**

Ojyx est un jeu de cartes stratégique où 2 à 8 joueurs s'affrontent pour obtenir le score le plus bas possible. Chaque joueur gère une grille de 12 cartes (3x4) et doit optimiser ses choix pour minimiser ses points tout en perturbant les stratégies adverses.

### **Règles du Jeu Détaillées**

#### **Setup Initial**

- Chaque joueur reçoit 12 cartes face cachée disposées en grille 3x4.
- **Pioche Initiale** : La pioche commune est constituée de 150 cartes réparties comme suit, avec des couleurs distinctes par plage de valeurs pour une reconnaissance visuelle rapide :
  - **5 cartes** de valeur **\-2** (Bleu foncé)
  - **10 cartes** de valeur **\-1** (Bleu foncé)
  - **15 cartes** de valeur **0** (Bleu clair)
  - **10 cartes** de chaque valeur de **1 à 4** (Vert)
  - **10 cartes** de chaque valeur de **5 à 8** (Jaune)
  - **10 cartes** de chaque valeur de **9 à 12** (Rouge)
- Chaque joueur révèle 2 de ses cartes volontairement au début de la partie.
- Une défausse est créée en retournant la première carte de la pioche.

#### **Structure des Tours**

Le jeu se déroule principalement au **tour par tour**, mais intègre des phases de jeu variées pour dynamiser les parties :

- **Phase Simultanée** : Au tout début de la partie, tous les joueurs révèlent leurs deux premières cartes en même temps.
- **Phase de Réaction** : Certaines cartes actions peuvent être jouées en dehors de son propre tour, en réaction à une action d'un adversaire, créant des interruptions stratégiques.

#### **Déroulement d'un Tour Classique**

1. **Phase de Pioche** : Le joueur actif choisit l'une des trois options suivantes :
   - Piocher la première carte (face cachée) de la pioche.
   - Prendre la première carte (face visible) de la défausse.
   - Piocher une **Carte Action** (face cachée) dans la pioche dédiée.
2. **Phase d'Action** :
   - **Si pioche (carte numérique)** : Le joueur peut soit échanger cette carte avec n'importe quelle carte (visible ou cachée) de sa grille, soit la défausser. S'il la défausse, il doit alors révéler une carte face caché de sa grille.
   - **Si défausse** : Le joueur doit obligatoirement échanger cette carte avec l'une des cartes (visible ou caché) de sa grille.
   - **Si pioche (carte action)** : Le joueur applique les règles spécifiques aux cartes actions (voir section dédiée).
3. **Fin de Tour** :
   - Le tour passe au joueur suivant, sauf si une carte action termine le tour prématurément.
   - **Vérification des colonnes** : Si un joueur a une colonne de 3 cartes identiques révélées, cette colonne est immédiatement défaussée et vaut 0 point.

#### **Conditions de Fin**

- Un joueur révèle la dernière de ses 12 cartes. Cela déclenche le dernier tour pour tous les autres joueurs.
- La partie se termine une fois que chaque joueur a terminé ce dernier tour.
- **Révélation finale** : Toutes les cartes encore face cachée sur les grilles de tous les joueurs sont automatiquement retournées.
- **Calcul des scores** : La somme des valeurs de toutes les cartes de chaque joueur est calculée. Si le joueur qui a initié la fin de manche n'a pas le score le plus bas (ou un score égal au plus bas), son score pour cette manche est doublé.
- Le joueur avec le moins de points gagne la manche.
- **Fin du jeu (Système de Vote)** : Le jeu n'a pas de fin prédéfinie par un score.
  - **Vote de fin de manche** : À la fin de chaque manche, un vote est proposé à tous les joueurs restants pour continuer ou quitter la partie.
  - **Départ d'un joueur** : Si un joueur quitte, son score est figé. Il peut consulter le tableau des scores à cet instant.
  - **Continuation** : Les joueurs qui votent pour continuer enchaînent une nouvelle manche.
  - **Fin définitive** : La partie se termine lorsque l'hôte y met fin ou lorsqu'il reste moins de 2 joueurs. Un tableau des scores final est alors montré à tous les participants.

### **Système de Cartes Actions (Innovation Majeure)**

Le jeu intègre un système d'au moins 21 cartes actions qui ajoutent une dimension stratégique. Ce système s'appuie sur une **pioche et une défausse de cartes actions communes** à tous les joueurs. Au lieu de lister chaque carte, cette section définit leurs principes fondamentaux pour guider la conception du gameplay et de l'interface.

#### **Principes et Propriétés des Cartes Actions**

- **Activation** : Les cartes actions possèdent différentes conditions d'activation :
  - Certaines **doivent être jouées automatiquement et immédiatement** dès leur pioche (ex: "Demi-tour").
  - D'autres sont **optionnelles** et peuvent être jouées immédiatement ou stockées.
- **Ciblage** : Les effets des cartes sont variés et peuvent cibler différents éléments du jeu :
  - **Cibles de Jeu** : La pioche, la défausse.
  - **Cibles de Joueur(s)** :
    - Le joueur lui-même (auto-ciblage).
    - Un ou plusieurs joueurs adverses (nécessite une sélection manuelle par le lanceur).
    - Tous les joueurs simultanément (effet de zone).
  - **Cibles de Cartes Spécifiques** :
    - Uniquement les cartes visibles.
    - Uniquement les cartes cachées.
    - Les cartes d'une couleur ou d'une valeur spécifique.

#### **Implications sur l'Interface et le Gameplay (UI/UX)**

La diversité des cartes actions impose la création d'une interface utilisateur (UI) dynamique et intuitive pour gérer les interactions complexes :

- **Sélecteur de Cible (Joueur)** : Lorsqu'une carte cible un ou plusieurs adversaires, l'interface doit permettre au joueur de les sélectionner facilement (par exemple, en touchant leur avatar ou leur zone de jeu).
- **Sélecteur de Cible (Carte)** : Pour les actions nécessitant de choisir une carte (sur sa propre grille ou celle d'un adversaire), les cartes éligibles doivent être mises en surbrillance, et le joueur doit pouvoir les sélectionner par un simple contact.
- **Vues contextuelles** : Des actions comme "Recyclage" ou "Fouille" nécessitent l'affichage d'une vue modale (pop-up) présentant une liste de cartes (partielle ou complète de la défausse) parmi lesquelles le joueur doit faire un choix.
- **Fenêtres de Validation** : Pour les actions ayant un impact majeur ou irréversible, une étape de confirmation ("Voulez-vous vraiment jouer cette carte ?") est nécessaire pour éviter les erreurs.
- **Feedback Visuel Clair** : Des animations et des effets visuels sont essentiels pour que tous les joueurs comprennent l'action en cours : une carte qui vole d'une grille à l'autre, un effet de zone qui se propage, une carte qui se retourne, etc.

## **🎨 Fonctionnalités Produit**

### **1\. Expérience Multijoueur Temps Réel**

- **Synchronisation instantanée** : Tous les mouvements sont reflétés en temps réel.
- **Gestion des déconnexions** : Reconnexion automatique sans perte de progression.
- **Vue Spectateur Dynamique** : Focalisation automatique sur le joueur actif pour suivre la partie en temps réel, avec possibilité de revenir à sa propre vue.
- **Lobbies publics/privés** : Création de salles personnalisées avec codes d'accès.

### **2\. Interface et Expérience Utilisateur (Mobile First)**

- **Conception Native Android** : L'interface est entièrement pensée et optimisée pour les écrans tactiles et les interactions mobiles (gestes, taps, swipes).
- **Gestion de l'affichage multi-joueurs** : Pour pallier le manque de place sur mobile (jusqu'à 8 joueurs), l'interface bascule par défaut sur une vue "spectateur" du joueur dont c'est le tour. Cette vue affiche le jeu et les actions du joueur actif, en respectant les règles de visibilité (ses cartes actions restent cachées). Le joueur peut à tout moment revenir à la vue de son propre jeu via un bouton dédié, et rebasculer sur la vue du joueur actif.
- **Lisibilité Maximale** : Des polices claires, des contrastes élevés et des éléments visuels bien espacés pour un confort de jeu optimal sur smartphone.
- **Gestion des Cartes Actions :**
  - Un emplacement d'interface dédié pour chaque joueur afin de visualiser et gérer son stock de 3 cartes actions.
  - Possibilité de consulter l'effet d'une carte stockée via un appui long ou un clic pour afficher une description.
  - Un bouton pour jouer une carte action depuis son stock. Ce bouton est actif par défaut pendant le tour du joueur. Il doit également s'activer et être mis en évidence (par ex. avec une animation ou une couleur) en dehors du tour lorsqu'une carte en stock peut être jouée en réaction à une action adverse.
  - Un pop-up de sélection clair pour forcer la défausse d'une carte lorsque le stock de 3 est dépassé.
- **Accessibilité** : Prise en charge des fonctionnalités d'accessibilité natives d'Android.

### **3\. Système de Progression**

- **Statistiques détaillées** : Historique des parties, scores moyens, victoires.

### **4\. Outils Sociaux**

- **Chat en jeu** : Communication entre joueurs pendant la partie.
- **Système d'amis** : Invitations directes et parties privées.

### **5\. Monitoring et Qualité**

- **Détection automatique des bugs** : Intégration Sentry pour suivi temps réel.
- **Logs détaillés** : Système de logging par joueur pour debug.
- **Panel administrateur** : Interface de gestion pour l'hôte de partie.

## **🛠️ Cadre Technique et Processus de Développement**

Cette section définit le cadre technique et le workflow de collaboration à imposer à l'IA pour garantir la qualité, la maintenabilité et la prévention des régressions.

### **1\. Stack Technologique**

- **Architecture : Clean Architecture** : Application obligatoire. Le code doit être rigoureusement séparé en couches (Présentation, Domaine, Données) avec une structure de dossiers claire (features/nom_feature/presentation|domain|data).
- **Gestion d'état et DI : Riverpod** : Obligatoire pour la gestion d'état et l'injection de dépendances. Une convention de nommage stricte pour les providers (ex: gameRepositoryProvider) doit être respectée.
- **Modèles de Données : Freezed \+ json_serializable** : Utilisation obligatoire pour tous les modèles de données et les états (states) pour garantir leur immuabilité et leur robustesse.
- **Routing : go_router** : Toute la navigation doit être déclarative et centralisée dans un unique fichier de configuration.
- **Backend : Supabase** : Utilisé comme Backend-as-a-Service pour la base de données (PostgreSQL), l'authentification (mode anonyme), le temps réel (WebSockets) et le stockage d'assets.
- **Error Tracking : Sentry Flutter** : Pour la remontée automatique des erreurs et crashs en production.

### **2\. Processus de Développement et Workflow (Non-négociable)**

- **Stratégie de Branches** : La branche main est protégée. Chaque nouvelle tâche ou fonctionnalité doit être développée dans une branche dédiée (ex: feat/add-teleport-card-logic).
- **Flux de Pull Request (PR)** : Tout code doit être intégré à main via une Pull Request. La PR ne peut être fusionnée que si :
  1. La CI/CD (voir ci-dessous) est au vert.
  2. Une revue de code manuelle a été effectuée.
- **CI/CD (Intégration Continue)** : Un workflow GitHub Actions est configuré pour bloquer toute PR ne respectant pas les standards. Il exécute automatiquement :
  - La vérification du formatage (dart format).
  - L'analyse statique du code (flutter analyze).
  - L'exécution de tous les tests (flutter test).
- **Approche "Test-First"** : Pour toute nouvelle fonctionnalité, l'IA doit d'abord écrire les tests qui la valident, puis écrire le code pour que les tests passent.
- **Gestion des Versions** : Le projet suit le Versionnage Sémantique (MAJOR.MINOR.PATCH).
- **Gestion des Secrets** : Les clés d'API (Supabase, Sentry) sont gérées via les Secrets GitHub pour la CI/CD et un fichier .env (ignoré par git) en local. Elles ne doivent jamais être écrites en dur dans le code.

### **3\. Documentation et Qualité du Code**

- **Mémoire de Projet (**PROJECT_RULES.md**)** : Un fichier à la racine du projet contient les règles d'architecture. Son contenu doit être inclus au début de chaque prompt complexe pour maintenir le contexte.
- **Linting (**flutter_lints**)** : Un ensemble de règles strictes est activé pour garantir la cohérence du code.
- **Génération de Code (**build_runner**)** : Utilisé pour freezed, json_serializable, etc.

## **🚀 Feuille de Route Initiale (MVP)**

L'objectif est de développer un Produit Minimum Viable (MVP) fonctionnel et robuste. Cette feuille de route est le seul périmètre à communiquer à l'IA pour l'initialisation du projet.

- **Objectif 1 : Fondation du Projet**
  - Mise en place de la structure du projet en suivant la Clean Architecture et le cadre de développement défini ci-dessus.
  - Configuration du dépôt Git, de la CI/CD et des règles de branches.
- **Objectif 2 : Gameplay de Base**
  - Implémentation de la logique de jeu principale (distribution, pioche, défausse, fin de manche).
  - Mise en place du multijoueur en temps réel avec Supabase pour synchroniser l'état du jeu.
- **Objectif 3 : Interface Utilisateur**
  - Création de l'interface de jeu pour Android, incluant la grille personnelle, les pioches, et la vue spectateur dynamique.
- **Objectif 4 : Cartes Actions**
  - Intégration du système de cartes actions, avec un set initial de 4 cartes pour valider la mécanique.
