# Implémentation Deep Links - Ojyx

## Configuration Deep Links

### Schema URL
- **Schema**: `ojyx://`
- **Host**: `game.ojyx.com`
- **Exemples**:
  - `ojyx://game.ojyx.com/` - Page d'accueil
  - `ojyx://game.ojyx.com/join-room` - Rejoindre une partie
  - `ojyx://game.ojyx.com/room/ABC123` - Rejoindre salle spécifique
  - `https://game.ojyx.com/room/ABC123` - Lien web universel

### Configuration Android

#### AndroidManifest.xml
```xml
<!-- Dans <activity> -->
<!-- Deep Links -->
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <!-- Schema personnalisé -->
    <data android:scheme="ojyx"
          android:host="game.ojyx.com"/>
</intent-filter>

<!-- App Links (liens universels) -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <!-- Domaine web -->
    <data android:scheme="https"
          android:host="game.ojyx.com"/>
</intent-filter>
```

### Configuration iOS (Info.plist)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>ojyx</string>
        </array>
    </dict>
</array>
```

### Configuration go_router

go_router gère automatiquement les deep links grâce à sa configuration déclarative:

```dart
GoRouter(
  initialLocation: '/',
  // Les routes définies gèrent automatiquement les deep links
  routes: [
    GoRoute(path: '/', ...),
    GoRoute(path: '/join-room', ...),
    GoRoute(path: '/room/:roomId', ...),
  ],
)
```

### Test des Deep Links

#### Android
```bash
# Ouvrir l'app avec un deep link
adb shell am start -W -a android.intent.action.VIEW -d "ojyx://game.ojyx.com/room/ABC123" com.ojyx.game

# Lien web universel
adb shell am start -W -a android.intent.action.VIEW -d "https://game.ojyx.com/room/ABC123" com.ojyx.game
```

#### iOS Simulator
```bash
xcrun simctl openurl booted "ojyx://game.ojyx.com/room/ABC123"
```

### Gestion des Deep Links avec Auth

Les guards existants gèrent déjà la redirection pour l'authentification:

1. **Lien vers salle protégée**: `ojyx://game.ojyx.com/room/ABC123`
2. **Sans auth**: Redirige vers `/?redirect=/room/ABC123`
3. **Après auth**: Navigation automatique vers la salle

### Partage de Liens

```dart
// Générer un lien de partage
String generateShareLink(String roomId) {
  return 'https://game.ojyx.com/room/$roomId';
}

// Partager via share_plus
await Share.share(
  'Rejoins ma partie Ojyx! $shareLink',
  subject: 'Invitation Ojyx',
);
```

## Cas d'Usage

### 1. Invitation à une Partie
- Joueur A crée une salle → ID: `ABC123`
- Génère lien: `https://game.ojyx.com/room/ABC123`
- Envoie à Joueur B via WhatsApp/SMS
- Joueur B clique → App s'ouvre sur la salle

### 2. Rejoindre Rapidement
- QR Code contenant: `ojyx://game.ojyx.com/join-room`
- Scan → App s'ouvre sur l'écran "Rejoindre"

### 3. Marketing/Onboarding
- Lien dans email: `ojyx://game.ojyx.com/?promo=WELCOME20`
- Paramètres récupérés dans HomeScreen

## Sécurité

1. **Validation des paramètres**: Toujours valider roomId
2. **Auth obligatoire**: Guards protègent les routes sensibles
3. **Expiration des liens**: Implémenter TTL côté serveur
4. **Rate limiting**: Limiter les tentatives de join