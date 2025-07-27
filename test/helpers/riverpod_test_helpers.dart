import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Extension pour accéder facilement au container dans les widget tests
extension ProviderContainerExtension on WidgetTester {
  /// Récupère le ProviderContainer du ProviderScope le plus proche
  ProviderContainer container() {
    final element = this.element(find.byType(ProviderScope));
    final container = ProviderScope.containerOf(element);
    return container;
  }
}

/// Crée un ProviderContainer pour les tests unitaires
///
/// Utilisation:
/// ```dart
/// test('mon test', () {
///   final container = createTestContainer();
///   // Utiliser le container
/// });
/// ```
ProviderContainer createTestContainer({
  List<Override> overrides = const [],
  ProviderContainer? parent,
}) {
  final container = ProviderContainer(overrides: overrides, parent: parent);

  // S'assurer que le container est disposé après le test
  addTearDown(container.dispose);

  return container;
}

/// Wrapper pour les widget tests avec Riverpod
///
/// Utilisation:
/// ```dart
/// testWidgets('mon test', (tester) async {
///   await tester.pumpRiverpodApp(
///     child: MonWidget(),
///     overrides: [
///       monProvider.overrideWithValue(valeur),
///     ],
///   );
/// });
/// ```
extension RiverpodTestingExtension on WidgetTester {
  Future<void> pumpRiverpodApp({
    required Widget child,
    List<Override> overrides = const [],
    List<NavigatorObserver> navigatorObservers = const [],
    ThemeData? theme,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          home: child,
          theme: theme ?? ThemeData.light(),
          navigatorObservers: navigatorObservers,
        ),
      ),
    );
  }
}

/// Mock de base pour les StateNotifier
class MockStateNotifier<T> extends Mock implements StateNotifier<T> {
  MockStateNotifier(T initialState) : _state = initialState;

  T _state;

  @override
  T get state => _state;

  @override
  set state(T value) {
    _state = value;
  }

  @override
  bool get mounted => true;

  @override
  bool get hasListeners => true;
}

/// Mock de base pour les Notifier
class MockNotifier<T> extends Mock implements Notifier<T> {
  MockNotifier(T initialState) : _state = initialState;

  T _state;

  @override
  T get state => _state;

  @override
  set state(T value) {
    _state = value;
  }
}

/// Mock de base pour les AsyncNotifier
class MockAsyncNotifier<T> extends Mock implements AsyncNotifier<T> {
  MockAsyncNotifier(AsyncValue<T> initialState) : _state = initialState;

  AsyncValue<T> _state;

  @override
  AsyncValue<T> get state => _state;

  @override
  set state(AsyncValue<T> value) {
    _state = value;
  }

  @override
  Future<T> build() async => _state.value!;
}

/// Helper pour tester les AsyncValue
extension AsyncValueTestExtension<T> on AsyncValue<T> {
  /// Vérifie si c'est un état de chargement
  bool get isLoading => this is AsyncLoading<T>;

  /// Vérifie si c'est un état d'erreur
  bool get isError => this is AsyncError<T>;

  /// Vérifie si c'est un état avec données
  bool get hasValue =>
      this is AsyncData<T> && (this as AsyncData<T>).value != null;

  /// Récupère la valeur ou null
  T? get valueOrNull {
    if (this is AsyncData<T>) {
      return (this as AsyncData<T>).value;
    }
    return null;
  }

  /// Récupère l'erreur ou null
  Object? get errorOrNull {
    if (this is AsyncError<T>) {
      return (this as AsyncError<T>).error;
    }
    return null;
  }
}

/// Helper pour observer les changements de state
class StateListener<T> {
  final List<T> states = [];

  void call(T? previous, T next) {
    states.add(next);
  }

  void clear() {
    states.clear();
  }
}

/// Créé un listener pour capturer les changements d'état
StateListener<T> createStateListener<T>() => StateListener<T>();

/// Helper pour tester les providers avec timeout
Future<T> expectLater<T>(
  Future<T> Function() callback, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  return await callback().timeout(
    timeout,
    onTimeout: () => throw TimeoutException('Test timeout after $timeout'),
  );
}
