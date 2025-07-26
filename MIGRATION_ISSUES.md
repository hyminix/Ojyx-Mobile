# Migration Issues - Ojyx Project

## Dependency Conflicts

### Status: ✅ No Conflicts Found

After running `flutter pub get --verbose`, no dependency conflicts were detected. All packages resolved successfully with the following versions:

- flutter_riverpod: ^2.6.1
- riverpod_annotation: ^2.3.5
- freezed_annotation: ^3.1.0
- json_annotation: ^4.9.0
- go_router: ^16.0.0
- supabase_flutter: ^2.9.1
- sentry_flutter: ^9.5.0
- And all other dependencies...

## Compilation Errors

### Current Issues (from flutter analyze)

1. **Supabase Configuration Errors**
   - Missing required parameter 'persistSessionKey' in FlutterAuthClientOptions
   - Undefined named parameters: 'heartbeatInterval', 'headers'
   - These are due to API changes in supabase_flutter v2.9.1

2. **Deprecated Imports and APIs**
   - Multiple deprecated Riverpod ref types (will be removed in 3.0)
   - Deprecated Sentry 'setExtra' method
   - Deprecated '.stream' on providers

3. **Router Navigation Errors**
   - Undefined getter 'refreshListenable' on GoRouter
   - String to Uri conversion errors in tests
   - RouterRefreshNotifier not found in tests

4. **Test-specific Errors**
   - Undefined classes: CardSelectionNotifier, GameAnimationNotifier
   - These were removed during provider migration

## Resolution Strategy

### Phase 1: Fix Critical Compilation Errors
1. Update Supabase configuration to match v2.9.1 API
2. Remove deprecated router features
3. Fix missing test classes

### Phase 2: Update Deprecated APIs
1. Replace deprecated Riverpod ref types
2. Update Sentry API usage
3. Fix provider stream usage

### Phase 3: Clean Up Tests
1. Update router tests for new API
2. Fix provider test references
3. Remove unnecessary null checks

## Notes

- No dependency_overrides needed as all packages resolved successfully
- Main issues are API changes, not version conflicts
- Most errors are straightforward to fix with proper API updates