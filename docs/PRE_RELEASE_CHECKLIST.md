# Checklist de Validation Pre-Release - Ojyx

> **Version :** 2.0  
> **Dernière mise à jour :** 28 juillet 2025  
> **Temps estimé :** 2-3 heures pour une validation complète

## 📋 Vue d'ensemble

Cette checklist garantit la qualité et la stabilité avant chaque release d'Ojyx. Chaque point doit être validé et coché avant la mise en production.

**Seuils critiques :**
- ❌ **Bloquant** : Release impossible
- ⚠️ **Majeur** : Correction recommandée  
- ℹ️ **Mineur** : Amélioration souhaitée

---

## 🚀 Phase 1 : Préparation

### Environnement et Outils

- [ ] **Environnement de test propre** ✅ *Bloquant*
  - [ ] Base de données test vide ou état connu
  - [ ] Variables d'environnement correctement configurées
  - [ ] Connexion stable au réseau
  - [ ] Appareils de test chargés (batterie > 50%)

- [ ] **Outils de monitoring activés** ✅ *Bloquant*
  - [ ] Sentry dashboard accessible
  - [ ] Supabase dashboard ouvert
  - [ ] Logs local en mode verbose
  - [ ] Capture d'écran/vidéo prête

- [ ] **Version candidate préparée** ✅ *Bloquant*
  - [ ] Code mergé sur branche release
  - [ ] Version number incrémentée dans `pubspec.yaml`
  - [ ] CHANGELOG.md mis à jour
  - [ ] Build APK release compilé sans erreur

---

## 🧪 Phase 2 : Tests Fonctionnels

### Tests de Base (Solo)

- [ ] **Lancement de l'application** ✅ *Bloquant*
  - [ ] Démarrage en moins de 3 secondes
  - [ ] Pas de crash au lancement
  - [ ] Écran d'accueil s'affiche correctement
  - [ ] Navigation fonctionnelle

- [ ] **Création de compte/Connexion** ✅ *Bloquant*
  - [ ] Connexion anonyme réussie
  - [ ] ID utilisateur généré et stocké
  - [ ] Supabase auth confirmé dans logs
  - [ ] Pas d'erreur dans Sentry

- [ ] **Navigation entre écrans** ⚠️ *Majeur*
  - [ ] Menu principal → Création room
  - [ ] Menu principal → Rejoindre room
  - [ ] Menu principal → Paramètres
  - [ ] Retour arrière fonctionne partout

### Tests Multijoueur (2 Joueurs Minimum)

- [ ] **Création et gestion de room** ✅ *Bloquant*
  - [ ] Créer une room publique
  - [ ] Code de room généré (6 caractères)
  - [ ] Room visible dans la liste
  - [ ] Paramètres modifiables par le créateur
  - [ ] **Test:** Créer room "TEST-RELEASE" avec 4 joueurs max

- [ ] **Rejoindre une room** ✅ *Bloquant*
  - [ ] Rejoindre par code room
  - [ ] Rejoindre via liste publique
  - [ ] Joueur 2 visible dans la lobby
  - [ ] Messages lobby fonctionnels
  - [ ] **Test:** 2ème appareil rejoint "TEST-RELEASE"

- [ ] **Démarrage de partie** ✅ *Bloquant*
  - [ ] Bouton "Démarrer" actif avec 2+ joueurs
  - [ ] Transition vers écran de jeu fluide
  - [ ] Grilles de cartes générées pour tous
  - [ ] Tour du premier joueur indiqué
  - [ ] **Test:** Démarrer partie avec 2 joueurs

### Tests de Gameplay Complet

- [ ] **Actions de base** ✅ *Bloquant*
  - [ ] Révéler une carte (animation fluide)
  - [ ] Carte révélée visible par tous les joueurs
  - [ ] Changement de tour automatique
  - [ ] Scores mis à jour en temps réel
  - [ ] **Test:** Chaque joueur révèle 2 cartes minimum

- [ ] **Cartes actions** ⚠️ *Majeur*
  - [ ] Piocher une carte action
  - [ ] Stock de cartes actions (max 3)
  - [ ] Jouer carte "Échange" avec animation
  - [ ] Jouer carte "Regard" (peek)
  - [ ] Jouer carte "Révélation" sur adversaire
  - [ ] Jouer carte "Demi-tour" (changement direction)
  - [ ] **Test:** Utiliser au moins 3 types de cartes actions

- [ ] **Validation des colonnes** ⚠️ *Majeur*
  - [ ] Révéler 3 cartes identiques dans une colonne
  - [ ] Colonne défaussée automatiquement (animation)
  - [ ] Score de la colonne = 0
  - [ ] Visible par tous les joueurs
  - [ ] **Test:** Forcer une validation de colonne

- [ ] **Fin de partie** ✅ *Bloquant*
  - [ ] Un joueur révèle sa 12ème carte
  - [ ] Dernier tour pour les autres joueurs
  - [ ] Calcul des scores finaux correct
  - [ ] Pénalité double si applicable
  - [ ] Écran de résultats affiché
  - [ ] Retour au menu principal possible
  - [ ] **Test:** Terminer une partie complète

### Tests Multi-appareils (4 Joueurs)

- [ ] **Synchronisation 4 joueurs** ⚠️ *Majeur*
  - [ ] 4 appareils dans la même room
  - [ ] Actions visibles par tous simultanément
  - [ ] Aucun décalage > 2 secondes
  - [ ] Pas de desynchronisation d'état
  - [ ] **Test:** Partie complète à 4 joueurs

- [ ] **Actions simultanées** ⚠️ *Majeur*
  - [ ] 2 joueurs révèlent en même temps
  - [ ] Ordre des actions respecté
  - [ ] Pas de conflit d'état
  - [ ] Résolution cohérente pour tous
  - [ ] **Test:** Actions rapides simultanées

---

## 🔧 Phase 3 : Tests Techniques

### Analyse Statique du Code

- [ ] **Flutter analyze** ✅ *Bloquant*
  ```bash
  flutter analyze
  # ✅ Aucune erreur critique
  # ⚠️ < 5 warnings non critiques
  # ℹ️ < 10 hints/infos
  ```

- [ ] **Tests unitaires** ⚠️ *Majeur*
  ```bash
  flutter test
  # ✅ Tous les tests passent
  # ⚠️ Coverage > 70% sur les parties critiques
  ```

- [ ] **Tests d'intégration** ⚠️ *Majeur*
  ```bash
  flutter test test/integration/run_multiplayer_tests.dart \
    --dart-define=SUPABASE_URL=$SUPABASE_URL \
    --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
  ```
  - [ ] Tests join/leave simultanés : ✅
  - [ ] Tests déconnexion/reconnexion : ✅
  - [ ] Tests charge 8 joueurs : ✅
  - [ ] Tests cohérence RLS : ✅

### Monitoring et Erreurs

- [ ] **Dashboard Sentry** ✅ *Bloquant*
  - [ ] Aucune erreur dans les 24 dernières heures
  - [ ] Alertes configurées et fonctionnelles
  - [ ] Taux d'erreur < 1% sur 7 jours
  - [ ] **Vérifier:** https://sentry.io/organizations/ojyx/

- [ ] **Base de données Supabase** ✅ *Bloquant*
  ```sql
  -- Performances RLS
  SELECT * FROM v_policy_performance_metrics 
  WHERE avg_execution_time_ms > 50;
  -- ✅ Résultat vide (toutes < 50ms)
  
  -- Violations RLS
  SELECT * FROM v_rls_violations_monitor 
  WHERE created_at > NOW() - INTERVAL '24 hours';
  -- ✅ Résultat vide (aucune violation)
  
  -- Cohérence des données
  SELECT * FROM validate_all_data_consistency();
  -- ✅ Tous les checks à 'passed'
  ```

- [ ] **Métriques de performance** ⚠️ *Majeur*
  - [ ] Latence moyenne < 200ms
  - [ ] P95 latence < 500ms
  - [ ] Taux de retry < 5%
  - [ ] Uptime Realtime > 99%

### Build et Déploiement

- [ ] **Build Release** ✅ *Bloquant*
  ```bash
  flutter build apk --release
  # ✅ Build réussi sans erreur
  # ✅ APK généré et fonctionnel
  # ✅ Taille APK < 50MB
  ```

- [ ] **Variables d'environnement** ✅ *Bloquant*
  - [ ] `SUPABASE_URL` configuré
  - [ ] `SUPABASE_ANON_KEY` configuré
  - [ ] `SENTRY_DSN` configuré
  - [ ] Pas de secrets dans le code source

- [ ] **Permissions Android** ⚠️ *Majeur*
  - [ ] INTERNET : ✅ (requis)
  - [ ] ACCESS_NETWORK_STATE : ✅ (optionnel)
  - [ ] Pas de permissions excessives

---

## 🚨 Phase 4 : Tests de Résistance

### Gestion des Déconnexions

- [ ] **Déconnexion réseau** ⚠️ *Majeur*
  - [ ] Activer mode avion pendant 30 secondes
  - [ ] Message "Connexion perdue" affiché
  - [ ] Désactiver mode avion
  - [ ] Reconnexion automatique < 10 secondes
  - [ ] État du jeu restauré correctement
  - [ ] **Test:** Déconnexion pendant révélation de carte

- [ ] **Fermeture d'application** ⚠️ *Majeur*
  - [ ] Fermer app (tâches récentes)
  - [ ] Rouvrir app < 2 minutes
  - [ ] Retour automatique à la partie
  - [ ] État synchronisé avec serveur
  - [ ] **Test:** Fermeture pendant partie active

- [ ] **Changement d'app** ℹ️ *Mineur*
  - [ ] Passer à une autre app 5 minutes
  - [ ] Revenir à Ojyx
  - [ ] Partie toujours active
  - [ ] Synchronisation rapide
  - [ ] **Test:** Interruption par appel téléphonique

### Tests de Charge

- [ ] **Latence réseau simulée** ⚠️ *Majeur*
  - [ ] Activer throttling réseau (3G)
  - [ ] Actions toujours applicables
  - [ ] Feedback utilisateur adapté
  - [ ] Pas de timeout < 30 secondes
  - [ ] **Test:** Partie complète en 3G

- [ ] **Multiples rooms simultanées** ℹ️ *Mineur*
  - [ ] Créer 3 rooms différentes
  - [ ] Parties simultanées actives
  - [ ] Pas d'interférence entre rooms
  - [ ] Performances stables
  - [ ] **Test:** 3 parties en parallèle

### Tests d'Edge Cases

- [ ] **Room pleine** ℹ️ *Mineur*
  - [ ] Créer room avec max 4 joueurs
  - [ ] 4 joueurs rejoignent
  - [ ] 5ème joueur ne peut pas rejoindre
  - [ ] Message d'erreur clair
  - [ ] **Test:** Tentative de rejoindre room pleine

- [ ] **Room inexistante** ℹ️ *Mineur*
  - [ ] Essayer code room "FAUX01"
  - [ ] Message "Room introuvable"
  - [ ] Retour au menu
  - [ ] Pas de crash application
  - [ ] **Test:** Code de room invalide

- [ ] **Créateur quitte** ⚠️ *Majeur*
  - [ ] Créateur quitte la room/partie
  - [ ] Partie continue pour les autres
  - [ ] Nouveau "host" désigné
  - [ ] Fonctionnalités préservées
  - [ ] **Test:** Créateur ferme son app

---

## 📊 Phase 5 : Métriques et Validation Finale

### Collecte des Métriques

- [ ] **Performances mesurées** ℹ️ *Mineur*
  ```
  Temps de démarrage: _____ ms (< 3000ms)
  Temps création room: _____ ms (< 2000ms)  
  Temps rejoindre room: _____ ms (< 2000ms)
  Latence action: _____ ms (< 1000ms)
  Temps reconnexion: _____ ms (< 5000ms)
  ```

- [ ] **Métriques réseau** ℹ️ *Mineur*
  ```
  Taux de retry: _____ % (< 5%)
  Taux d'erreur: _____ % (< 1%)
  Uptime session: _____ % (> 95%)
  ```

### Validation Business

- [ ] **Expérience utilisateur** ⚠️ *Majeur*
  - [ ] Partie complète 2 joueurs en < 10 minutes
  - [ ] Interface intuitive (validation externe)
  - [ ] Messages d'erreur compréhensibles
  - [ ] Pas de confusion sur les règles
  - [ ] **Test:** Faire jouer une personne externe

- [ ] **Règles du jeu** ✅ *Bloquant*
  - [ ] Calcul des scores correct
  - [ ] Validation des colonnes conforme
  - [ ] Cartes actions selon spécifications
  - [ ] Pénalités appliquées correctement
  - [ ] **Test:** Vérification manuelle des règles

### Documentation et Trace

- [ ] **Logs structurés** ℹ️ *Mineur*
  - [ ] Logs de session complète capturés
  - [ ] Format JSON cohérent
  - [ ] Pas d'informations sensibles loggées
  - [ ] Rotation automatique fonctionnelle

- [ ] **Screenshots/Vidéos** ℹ️ *Mineur*
  - [ ] Capture du gameplay principal
  - [ ] Démonstration des cartes actions
  - [ ] Preuve des tests de déconnexion
  - [ ] **Archive:** Sauvegarder pour documentation

---

## ✅ Phase 6 : Validation Finale et Release

### Pre-Release Final

- [ ] **Code freeze** ✅ *Bloquant*
  - [ ] Aucun commit après début des tests
  - [ ] Branche release figée
  - [ ] Tag de version créé
  - [ ] **Version:** v_____ (à documenter)

- [ ] **Team validation** ⚠️ *Majeur*
  - [ ] Test complet par 2ème personne
  - [ ] Validation PM/Product Owner
  - [ ] Approbation technique lead
  - [ ] **Signoff:** _____________ (signature)

### Déploiement

- [ ] **Environnement Production** ✅ *Bloquant*
  - [ ] Variables prod configurées
  - [ ] Base données prod backup
  - [ ] Rollback plan ready
  - [ ] Monitoring prod activé

- [ ] **Release Notes** ⚠️ *Majeur*
  - [ ] CHANGELOG.md finalisé
  - [ ] Notes utilisateur rédigées
  - [ ] Breaking changes documentés
  - [ ] **Review:** Notes relues et approuvées

### Post-Release Immédiat

- [ ] **Monitoring post-release** ✅ *Bloquant*
  - [ ] Dashboard Sentry surveillé 2h
  - [ ] Métriques Supabase stables
  - [ ] Aucune régression détectée
  - [ ] **Responsable:** _____________ (nom)

- [ ] **Rollback ready** ✅ *Bloquant*
  - [ ] Version précédente ready
  - [ ] Procédure rollback testée
  - [ ] Contact ops disponible
  - [ ] **Timeout rollback:** 1 heure max

---

## 📞 Contacts d'Urgence

### Équipe Technique
- **Développeur Principal:** Discord @dev-lead
- **DevOps/Infra:** Slack #ops-alerts  
- **QA/Test:** Email qa@ojyx.com

### Procédure d'Escalade
1. **0-15min:** Investigation équipe dev
2. **15-30min:** Escalade tech lead
3. **30-60min:** Decision rollback
4. **60min+:** Communication utilisateurs

---

## 📝 Résultats de Validation

**Date de validation :** ___________  
**Version testée :** v_____  
**Testeur principal :** ___________  
**Durée totale :** _____ heures  

### Résumé des Résultats

```
✅ Bloquants résolus : ___/___
⚠️ Majeurs résolus : ___/___  
ℹ️ Mineurs résolus : ___/___

🚀 RELEASE: GO / NO-GO (encercler)
```

### Notes Importantes
```
_________________________________________________
_________________________________________________
_________________________________________________
```

### Signature d'Approbation

**Développeur :** _______________  
**QA :** _______________  
**Product :** _______________  
**Date :** _______________

---

## 🔄 Amélioration Continue

Après chaque release, mettre à jour cette checklist avec :
- Nouveaux tests identifiés
- Seuils ajustés selon l'expérience
- Outils et processus améliorés
- Retours d'expérience utilisateurs

**Prochaine review checklist :** ___________