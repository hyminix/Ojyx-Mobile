/// Test helpers and utilities for the Ojyx project
///
/// This file provides a single import point for all test utilities,
/// reducing boilerplate and improving consistency across test files.
///
/// Usage:
/// ```dart
/// import '../helpers/index.dart';
///
/// void main() {
///   testWidgets('should create game correctly', (tester) async {
///     final gameState = TestGameState()
///         .players([TestGamePlayer().name('Alice').build()])
///         .build();
///
///     expect(gameState, hasPlayerCount(1));
///   });
/// }
/// ```
library;

// Core test helpers
export 'test_helpers.dart' hide MockGoRouter;
export 'test_mocks.dart';

// Builder pattern for creating test entities
export 'test_builders.dart';

// Custom matchers for domain-specific assertions
export 'test_matchers.dart';

// Pre-built scenarios for common test situations
export 'test_scenarios.dart';

// Convenience re-exports from common packages
export 'package:flutter_test/flutter_test.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:mocktail/mocktail.dart';
