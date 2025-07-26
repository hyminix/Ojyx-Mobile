# Migration Script: CardSelectionProvider

## Steps to migrate from StateNotifier to modern Notifier syntax

### 1. Backup current provider
```bash
cp lib/features/game/presentation/providers/card_selection_provider.dart \
   lib/features/game/presentation/providers/card_selection_provider.backup.dart
```

### 2. Replace imports in consuming files
Replace:
```dart
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';
```

With:
```dart
import 'package:ojyx/features/game/presentation/providers/card_selection_provider_v2.dart';
```

### 3. Files to update:
- lib/features/game/presentation/widgets/player_grid_with_selection.dart
- lib/features/game/presentation/widgets/game_selection_overlay.dart
- lib/features/game/presentation/widgets/enhanced_player_grid.dart
- lib/features/game/presentation/screens/game_screen.dart

### 4. Delete old provider and rename new one
```bash
rm lib/features/game/presentation/providers/card_selection_provider.dart
mv lib/features/game/presentation/providers/card_selection_provider_v2.dart \
   lib/features/game/presentation/providers/card_selection_provider.dart
```

### 5. Update generated files
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Run tests to verify
```bash
flutter test test/providers/
```

## Benefits of migration:
- Better performance with code generation
- Type-safe provider references
- Auto-dispose by default (reduces memory leaks)
- Better IDE support and autocomplete
- Consistent with modern Riverpod best practices