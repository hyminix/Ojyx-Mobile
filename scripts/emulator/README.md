# Émulateur Android Optimisé pour Ojyx

## Vue d'ensemble

Ces scripts configurent et gèrent un émulateur Android hautement optimisé pour le développement Flutter/Ojyx avec :
- Démarrage rapide via snapshots
- Accélération matérielle maximale
- Configuration Pixel 6 avec Android 14 (API 34)
- Animations désactivées pour performance optimale

## Prérequis

1. **Variables d'environnement**
   ```bash
   export ANDROID_HOME=/path/to/android/sdk
   export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools
   ```

2. **Accélération matérielle**
   - **Windows** : Hyper-V ou Intel HAXM
   - **Linux** : KVM activé (`kvm-ok` pour vérifier)
   - **macOS** : Intel HAXM installé

## Scripts Disponibles

### 1. `create-emulator.sh`
Crée l'AVD optimisé pour Ojyx.

```bash
./create-emulator.sh
```

**Configuration créée** :
- Nom : `Ojyx_Dev_Pixel_6`
- Device : Pixel 6
- Android : 14 (API 34)
- RAM : 4GB
- CPU : 4 cores
- GPU : Host (accélération matérielle)

### 2. `start-emulator.sh`
Lance l'émulateur avec les optimisations.

```bash
./start-emulator.sh
```

**Optimisations appliquées** :
- Pas d'animation de boot
- Pas de son (performance)
- GPU host mode
- Snapshot loading
- Animations système désactivées

### 3. `save-snapshot.sh`
Sauvegarde l'état actuel pour démarrage rapide.

```bash
./save-snapshot.sh ojyx_clean      # État propre
./save-snapshot.sh ojyx_logged_in  # Avec app installée
```

### 4. `quick-restart.sh`
Redémarre rapidement l'émulateur.

```bash
./quick-restart.sh
```

## Workflow Recommandé

### Installation Initiale

1. **Créer l'émulateur**
   ```bash
   cd scripts/emulator
   chmod +x *.sh
   ./create-emulator.sh
   ```

2. **Premier démarrage**
   ```bash
   ./start-emulator.sh
   # Attendre le boot complet (plus lent la première fois)
   ```

3. **Créer snapshot de base**
   ```bash
   ./save-snapshot.sh ojyx_clean
   ```

4. **Installer l'app et créer snapshot**
   ```bash
   cd ../..
   flutter run
   # Une fois l'app installée et configurée
   ./scripts/emulator/save-snapshot.sh ojyx_ready
   ```

### Utilisation Quotidienne

```bash
# Démarrage rapide avec snapshot
./scripts/emulator/start-emulator.sh

# Dans VS Code, F5 pour lancer l'app
# Hot reload automatique à chaque sauvegarde
```

## Performance

### Temps de Démarrage
- Premier boot : ~30-60 secondes
- Avec snapshot : ~5-10 secondes
- Hot reload : <1 seconde

### Optimisations Actives
- ✅ Hardware GPU acceleration
- ✅ 4GB RAM alloué
- ✅ 4 CPU cores
- ✅ Quick boot snapshots
- ✅ Animations désactivées
- ✅ Audio désactivé
- ✅ Caméras désactivées

## Troubleshooting

### "KVM is required but not available"
```bash
# Linux : Activer KVM
sudo modprobe kvm-intel  # ou kvm-amd
# Vérifier
kvm-ok
```

### "HAXM is not installed"
```bash
# Windows/macOS : Installer HAXM
$ANDROID_HOME/extras/intel/Hardware_Accelerated_Execution_Manager/silent_install.sh
```

### Émulateur lent
1. Vérifier l'accélération : `emulator -accel-check`
2. Augmenter RAM si possible
3. Fermer autres applications
4. Utiliser snapshot au lieu de cold boot

### "Emulator process terminated"
- Vérifier l'espace disque (besoin de ~10GB)
- Essayer de recréer l'AVD
- Vérifier les logs : `$HOME/.android/avd/Ojyx_Dev_Pixel_6.avd/`

## Tips Avancés

### Profiler Network
```bash
# Simuler connexion lente
adb shell settings put global airplane_mode_on 1
sleep 2
adb shell settings put global airplane_mode_on 0
```

### Multi-Instance
```bash
# Lancer plusieurs émulateurs
emulator -avd Ojyx_Dev_Pixel_6 -port 5554 &
emulator -avd Ojyx_Dev_Pixel_6_2 -port 5556 &
```

### Performance Monitoring
```bash
# CPU/Memory usage
adb shell top -m 10

# FPS counter
adb shell settings put global debug.hwui.show_fps_counter 1
```

## Intégration VS Code

Les launch configurations utilisent automatiquement l'émulateur s'il est démarré.
Sinon, VS Code propose de le lancer.

**Raccourcis** :
- `F5` : Lance l'app en debug
- `Ctrl+Shift+P` → "Flutter: Select Device" pour choisir l'émulateur

## Maintenance

### Nettoyer les snapshots
```bash
adb emu avd snapshot delete [snapshot_name]
```

### Reset complet
```bash
# Supprimer et recréer
avdmanager delete avd -n Ojyx_Dev_Pixel_6
./create-emulator.sh
```

### Mise à jour system image
```bash
sdkmanager --update
sdkmanager "system-images;android-34;google_apis_playstore;x86_64"
```