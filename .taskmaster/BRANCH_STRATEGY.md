# Stratégie de Gestion des Branches pour Ojyx

## Problème Identifié
Il y a eu une confusion entre plusieurs branches avec des PRD différents :
- PRD de "Finalisation" (refactoring architecture)
- PRD de "Mise à Niveau Technique" (update dépendances)

## Stratégie pour Éviter ce Problème

### 1. Une Branche = Un PRD
- JAMAIS changer de PRD sur une branche existante
- Si nouveau PRD → nouvelle branche

### 2. Convention de Nommage Stricte
- `feat/refactoring-architecture` - pour le PRD de finalisation
- `feat/update-dependencies` - pour le PRD de mise à niveau
- `feat/continue-refactoring-work` - branche actuelle de travail

### 3. Protection des Fichiers Task Master
Avant de changer de branche :
```bash
# Sauvegarder l'état actuel
git add .taskmaster/tasks/tasks.json
git commit -m "chore: save current taskmaster state"
```

### 4. Vérification Avant Switch
```bash
# Toujours vérifier le PRD actuel
head -5 scripts/PRD.txt
grep -m1 '"title"' .taskmaster/tasks/tasks.json
```

### 5. État Actuel (2025-07-26)
- Branche : `feat/continue-refactoring-work`
- PRD : "Plan de Développement Ojyx - PRD de Finalisation"
- Focus : Refactoring architecture (GamePlayer/LobbyPlayer)
- Tâche en cours : ID 1 - Refactoring des entités Player

## Commandes de Récupération en Cas de Problème
```bash
# Voir l'historique du tasks.json
git log --all --oneline -- .taskmaster/tasks/tasks.json

# Récupérer une version spécifique
git show COMMIT:.taskmaster/tasks/tasks.json > tasks_backup.json

# Créer une branche propre
git switch -c feat/nouvelle-branche
```

## IMPORTANT
- Ne JAMAIS merger une branche avec un PRD différent sans discussion
- Toujours commiter les changements Task Master avant de changer de branche
- En cas de doute, créer une nouvelle branche plutôt que modifier l'existante