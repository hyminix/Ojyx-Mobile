# Guide de Configuration des Webhooks

## Vue d'ensemble

Ce guide explique comment configurer les notifications Slack et Discord pour recevoir des alertes automatiques sur les échecs de build.

## Configuration Slack

### 1. Créer un Webhook Slack

1. Aller sur https://api.slack.com/apps
2. Cliquer sur "Create New App" > "From scratch"
3. Nommer l'app "Ojyx CI Notifications"
4. Sélectionner votre workspace
5. Dans "Features", aller dans "Incoming Webhooks"
6. Activer "Activate Incoming Webhooks"
7. Cliquer "Add New Webhook to Workspace"
8. Choisir le canal (ex: #ci-notifications)
9. Copier l'URL du webhook

### 2. Ajouter le Secret GitHub

```bash
# Via GitHub CLI
gh secret set SLACK_WEBHOOK_URL --body "YOUR_WEBHOOK_URL"

# Via UI
Settings > Secrets and variables > Actions > New repository secret
Name: SLACK_WEBHOOK_URL
Value: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

### 3. Format des Notifications Slack

Les notifications incluent :
- **Header** : Emoji + titre selon le type d'échec
- **Fields** : Type, étape échouée, branche, commit
- **Actions** : Bouton pour voir les logs
- **Couleur** : Rouge pour échecs, vert pour succès

## Configuration Discord

### 1. Créer un Webhook Discord

1. Ouvrir Discord et aller dans les paramètres du serveur
2. Aller dans "Intégrations" > "Webhooks"
3. Cliquer "Nouveau webhook"
4. Nommer le webhook "Ojyx CI"
5. Choisir le canal
6. Copier l'URL du webhook

### 2. Ajouter le Secret GitHub

```bash
# Via GitHub CLI
gh secret set DISCORD_WEBHOOK_URL --body "YOUR_WEBHOOK_URL"

# Via UI
Settings > Secrets and variables > Actions > New repository secret
Name: DISCORD_WEBHOOK_URL
Value: https://discord.com/api/webhooks/YOUR/WEBHOOK/URL
```

### 3. Format des Notifications Discord

Les embeds Discord incluent :
- **Titre** : Avec emoji d'état
- **Couleur** : Variable selon le type d'échec
- **Fields** : Informations de build inline
- **Footer** : Utilisateur déclencheur
- **Timestamp** : Heure de l'événement

## Types de Notifications

### 1. Notifications d'Échec (Toujours)

Déclenchées sur tout échec de build avec catégorisation :

| Type | Emoji Slack | Couleur Discord | Description |
|------|------------|-----------------|-------------|
| compilation | 🔨 | Rouge | Erreur de compilation Flutter/Android |
| tests | 🧪 | Orange | Tests unitaires/intégration échoués |
| linting | 📝 | Jaune | Erreurs d'analyse statique |
| codegen | 🏭 | Violet | Échec génération de code |
| unknown | ❌ | Rouge foncé | Autre type d'échec |

### 2. Notifications de Succès (Main uniquement)

- Envoyées uniquement pour les builds réussis sur `main`
- Format simplifié avec lien vers artifacts
- Idéal pour notifier les nouvelles releases

## Personnalisation

### 1. Modifier les Conditions

Dans `.github/workflows/notifications.yml` :

```yaml
# Pour notifier sur toutes les branches
if: github.event.workflow_run.conclusion == 'failure'

# Pour notifier seulement certaines branches
if: |
  github.event.workflow_run.conclusion == 'failure' &&
  (github.event.workflow_run.head_branch == 'main' || 
   github.event.workflow_run.head_branch == 'develop')
```

### 2. Ajouter des Canaux

```yaml
# Multiple Slack channels
- name: Send to QA channel
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_QA_WEBHOOK_URL }}
```

### 3. Enrichir les Messages

Ajouter des informations supplémentaires :
- Durée du build
- Nombre de tests échoués
- Lien vers le commit
- Mention d'utilisateurs

## Test des Webhooks

### 1. Test Manuel Slack

```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Test notification from Ojyx CI"}' \
  YOUR_SLACK_WEBHOOK_URL
```

### 2. Test Manuel Discord

```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"content": "Test notification from Ojyx CI"}' \
  YOUR_DISCORD_WEBHOOK_URL
```

### 3. Test via Workflow

Créer une PR avec une erreur intentionnelle :

```dart
// test/intentional_fail_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('intentional failure', () {
    expect(true, isFalse); // Will fail
  });
}
```

## Troubleshooting

### Webhook Non Reçu

**Vérifications** :
1. Secret correctement configuré
2. URL valide et non expirée
3. Permissions du canal/serveur
4. Logs du workflow notifications

### Format Incorrect

**Solutions** :
- Vérifier l'échappement JSON
- Tester avec payload minimal
- Consulter docs API Slack/Discord

### Notifications Dupliquées

**Causes possibles** :
- Multiple workflows déclenchés
- Re-runs manuels
- Configuration webhook dupliquée

## Sécurité

### 1. Rotation des Webhooks

Recommandé tous les 6 mois :
1. Créer nouveau webhook
2. Mettre à jour secret GitHub
3. Tester nouveau webhook
4. Supprimer ancien webhook

### 2. Limitations

- Ne pas exposer d'informations sensibles
- Limiter aux canaux appropriés
- Éviter les données personnelles

### 3. Audit

Vérifier régulièrement :
- Utilisation des webhooks
- Membres des canaux
- Logs de notifications

## Métriques et Monitoring

### 1. Dashboard Notifications

Créer un dashboard pour suivre :
- Nombre de notifications par jour
- Types d'échecs fréquents
- Temps de réponse aux échecs
- Taux de résolution

### 2. Alertes Avancées

Configurer des alertes pour :
- Échecs répétés (>3 sur même branche)
- Temps de build anormaux
- Patterns d'échecs

## Intégrations Futures

### Court Terme
- [ ] Support Microsoft Teams
- [ ] Notifications email
- [ ] Mentions automatiques

### Moyen Terme
- [ ] Dashboard web temps réel
- [ ] Intégration Jira/Linear
- [ ] Métriques Grafana

### Long Terme
- [ ] IA pour analyse d'échecs
- [ ] Suggestions de fixes
- [ ] Auto-retry intelligent