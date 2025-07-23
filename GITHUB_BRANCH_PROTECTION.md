# Configuration de la Protection des Branches GitHub

## Protection de la Branche `main`

Pour configurer la protection de la branche `main` sur GitHub :

### 1. Accéder aux Paramètres
1. Aller sur le repository GitHub
2. Cliquer sur **Settings** (Paramètres)
3. Dans le menu latéral, cliquer sur **Branches**

### 2. Ajouter une Règle de Protection
1. Cliquer sur **Add rule** (Ajouter une règle)
2. Dans **Branch name pattern**, entrer : `main`

### 3. Configurer les Protections

#### Checks Requis
- ✅ **Require status checks to pass before merging**
  - ✅ **Require branches to be up to date before merging**
  - Sélectionner les checks suivants :
    - `Test and Analyze`
    - `Build APK`

#### Pull Request Reviews
- ✅ **Require a pull request before merging**
  - ✅ **Require approvals** : 1
  - ✅ **Dismiss stale pull request approvals when new commits are pushed**
  - ✅ **Require review from CODEOWNERS** (si applicable)

#### Restrictions Supplémentaires
- ✅ **Require conversation resolution before merging**
- ✅ **Require signed commits** (optionnel mais recommandé)
- ✅ **Include administrators** (pour s'assurer que même les admins suivent les règles)

#### Options de Merge
- ✅ **Allow merge commits**
- ✅ **Allow squash merging**
- ❌ **Allow rebase merging** (pour garder un historique linéaire)

### 4. Sauvegarder
Cliquer sur **Create** ou **Save changes**

## Workflow de Développement

### Pour les Développeurs
1. Créer une branche depuis `main` : `git checkout -b feat/nouvelle-fonctionnalite`
2. Développer et commiter les changements
3. Pousser la branche : `git push origin feat/nouvelle-fonctionnalite`
4. Créer une Pull Request vers `main`
5. Attendre que :
   - La CI/CD passe (tests, analyse, build)
   - Un reviewer approuve les changements
6. Merger la PR

### Pour les Reviewers
1. Vérifier que :
   - Le code respecte les standards du projet
   - Les tests sont présents et pertinents
   - La documentation est à jour si nécessaire
   - Les conventions de nommage sont respectées
2. Laisser des commentaires constructifs
3. Approuver ou demander des changements

## Commandes Git Utiles

```bash
# Créer une nouvelle branche
git checkout -b feat/description

# Voir l'état des fichiers
git status

# Ajouter tous les fichiers modifiés
git add .

# Commiter avec un message descriptif
git commit -m "feat: ajouter la fonctionnalité X"

# Pousser la branche
git push origin feat/description

# Mettre à jour sa branche avec les derniers changements de main
git checkout main
git pull origin main
git checkout feat/description
git merge main
```

## Messages de Commit

Format recommandé : `type(scope): description`

Types :
- `feat` : Nouvelle fonctionnalité
- `fix` : Correction de bug
- `docs` : Documentation
- `style` : Formatage, missing semi-colons, etc.
- `refactor` : Refactoring du code
- `test` : Ajout ou modification de tests
- `chore` : Maintenance, configuration, etc.

Exemples :
- `feat(game): implémenter la logique de pioche`
- `fix(ui): corriger l'affichage des cartes sur mobile`
- `docs(readme): ajouter les instructions d'installation`