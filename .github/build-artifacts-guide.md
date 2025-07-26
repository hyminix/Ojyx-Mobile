# Guide des Artifacts de Build

## Vue d'ensemble

Ce guide documente le système d'artifacts et de rapports de build implémenté dans le workflow CI/CD.

## Architecture des Artifacts

### 1. Structure des Artifacts

Chaque build génère un artifact compressé contenant :

```
ojyx-{build-type}-v{version}-{run-number}.tar.gz
├── {build-type}/
│   ├── app-{build-type}.apk      # APK principal
│   ├── app-{build-type}.apk.sha256  # Checksum SHA256
│   ├── app-{build-type}.apk.md5    # Checksum MD5
│   ├── build-metadata.json         # Métadonnées détaillées
│   └── README.md                   # Instructions d'installation
```

### 2. Métadonnées de Build

Le fichier `build-metadata.json` contient :

```json
{
  "build_type": "release",
  "build_time_seconds": 180,
  "apk_size_mb": 45.2,
  "version_name": "1.0.0",
  "version_code": "1",
  "flutter_version": "3.32.6",
  "incremental_build": false,
  "warnings_count": 0,
  "sha256": "a1b2c3d4...",
  "commit_sha": "abc123...",
  "build_date": "2025-07-26T20:00:00Z"
}
```

### 3. Rapports de Build

Deux types de rapports sont générés :

#### Job Summary (Interface GitHub)
- Tableau des métriques de build
- Informations d'environnement
- Indicateurs de performance
- Liens de téléchargement

#### PR Comment (Commentaire automatique)
- Résumé compact des métriques
- Comparaison avec build précédent
- Liens directs vers artifacts
- Indicateurs visuels (emojis)

## Nomenclature des Artifacts

### Format Standard
```
ojyx-{build-type}-v{version}-{run-number}
```

**Exemples** :
- `ojyx-debug-v1.0.0-123`
- `ojyx-release-v1.2.3-456`

### Rétention
- **APKs** : 30 jours
- **Rapports** : 7 jours
- **Logs** : 7 jours

## Compression et Optimisation

### 1. Stratégie de Compression

- **Méthode** : tar.gz avec compression maximale
- **Réduction moyenne** : 15-20% de la taille APK
- **Impact CI** : +5s de temps de build

### 2. Optimisation des Uploads

```yaml
compression-level: 0  # Désactivé car pré-compressé
```

### 3. Gestion de l'Espace

- Limite GitHub : 500 MB par artifact
- Limite totale : 50 GB par repo
- Nettoyage auto après expiration

## Téléchargement et Utilisation

### 1. Via Interface GitHub

1. Aller dans l'onglet Actions
2. Sélectionner le workflow run
3. Scroller jusqu'à "Artifacts"
4. Cliquer sur l'artifact désiré

### 2. Via GitHub CLI

```bash
# Lister les artifacts
gh run download <run-id> -n ojyx-release-v1.0.0-123

# Télécharger spécifique
gh run download <run-id> -n ojyx-release-v1.0.0-123 -D ./downloads
```

### 3. Via API REST

```bash
# Obtenir la liste
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/OWNER/REPO/actions/artifacts

# Télécharger
curl -L -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/OWNER/REPO/actions/artifacts/<id>/zip \
  -o artifact.zip
```

## Checksums et Vérification

### 1. Vérifier SHA256

```bash
# Linux/Mac
sha256sum -c app-release.apk.sha256

# Windows
CertUtil -hashfile app-release.apk SHA256
```

### 2. Vérifier MD5

```bash
# Linux/Mac
md5sum -c app-release.apk.md5

# Windows
CertUtil -hashfile app-release.apk MD5
```

## Analyse des APKs

### 1. Extraction d'Informations

```bash
# Version et permissions
aapt dump badging app-release.apk

# Taille par composant
aapt dump --values resources app-release.apk | grep -E "size|type"
```

### 2. Comparaison de Tailles

Le workflow calcule automatiquement :
- Taille absolue en MB
- Comparaison avec build précédent
- Tendance (↑ ou ↓)

## Intégration Continue

### 1. Notifications PR

Chaque PR reçoit automatiquement :
- Commentaire avec métriques
- Liens vers artifacts
- Indicateurs de performance

### 2. Badges de Status

```markdown
![Build Status](https://github.com/OWNER/REPO/workflows/WSL%20Android%20Build/badge.svg)
```

### 3. Rapports Détaillés

Accessibles via :
- Job Summary GitHub
- Artifacts téléchargeables
- Logs de workflow

## Troubleshooting

### Artifact Non Disponible

**Causes** :
- Build échoué
- Période de rétention expirée
- Permissions insuffisantes

**Solutions** :
- Vérifier les logs de build
- Re-runner le workflow
- Ajuster retention-days

### Téléchargement Lent

**Optimisations** :
- Utiliser GitHub CLI (plus rapide)
- Télécharger via Actions UI
- Configurer un mirror local

### Checksums Invalides

**Vérifications** :
1. Re-télécharger l'artifact
2. Vérifier l'intégrité du téléchargement
3. Comparer avec build-metadata.json

## Best Practices

### 1. Pour les Développeurs

- **Toujours** vérifier les checksums
- **Utiliser** les artifacts de PR pour tests
- **Nettoyer** les vieux artifacts locaux

### 2. Pour les QA

- **Télécharger** depuis l'UI GitHub
- **Documenter** la version testée
- **Rapporter** avec le build number

### 3. Pour les Releases

- **Archiver** les artifacts de release
- **Signer** les APKs avant distribution
- **Conserver** les métadonnées

## Métriques et Monitoring

### 1. Métriques Collectées

- Temps de build par type
- Taille des APKs dans le temps
- Taux de succès des builds
- Utilisation du cache

### 2. Dashboards

Disponibles dans :
- GitHub Insights
- Job summaries
- Rapports hebdomadaires

### 3. Alertes

Configurées pour :
- APK > 100 MB
- Build time > 10 min
- Échecs répétés

## Évolution Future

### Court Terme
- [ ] Signatures APK automatiques
- [ ] Upload vers Play Store Console
- [ ] Analyse de taille détaillée

### Moyen Terme
- [ ] Distribution beta automatique
- [ ] Tests automatisés sur devices
- [ ] Rapports de performance runtime

### Long Terme
- [ ] CDN pour artifacts
- [ ] Analytics d'utilisation
- [ ] A/B testing automatisé