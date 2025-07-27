import 'dart:io';

void main(List<String> args) {
  print('🔄 Starting TDD migration for domain tests...\n');

  final testFiles = [
    'test/features/end_game/domain/entities/end_game_state_test.dart',
    'test/features/game/domain/entities/action_card_test.dart',
    'test/features/game/domain/entities/card_position_test.dart',
    'test/features/game/domain/entities/card_test.dart',
    'test/features/game/domain/entities/deck_state_test.dart',
    'test/features/game/domain/entities/game_player_test.dart',
    'test/features/game/domain/entities/game_state_test.dart',
    'test/features/game/domain/entities/player_grid_test.dart',
    'test/features/game/domain/entities/player_state_test.dart',
    'test/features/game/domain/use_cases/calculate_scores_test.dart',
    'test/features/game/domain/use_cases/check_end_round_test.dart',
    'test/features/game/domain/use_cases/distribute_cards_test.dart',
    'test/features/game/domain/use_cases/draw_action_card_use_case_test.dart',
    'test/features/game/domain/use_cases/draw_card_test.dart',
    'test/features/game/domain/use_cases/game_initialization_use_case_test.dart',
    'test/features/game/domain/use_cases/process_last_round_test.dart',
    'test/features/game/domain/use_cases/reveal_initial_cards_test.dart',
    'test/features/game/domain/use_cases/start_game_test.dart',
    'test/features/game/domain/use_cases/use_action_card_use_case_test.dart',
    'test/features/global_scores/domain/entities/global_score_test.dart',
    'test/features/global_scores/domain/repositories/global_score_repository_test.dart',
    'test/features/global_scores/domain/use_cases/get_player_stats_test.dart',
    'test/features/global_scores/domain/use_cases/get_top_players_test.dart',
    'test/features/global_scores/domain/use_cases/save_global_score_test.dart',
    'test/features/multiplayer/domain/entities/room_event_test.dart',
    'test/features/multiplayer/domain/entities/room_test.dart',
    'test/features/multiplayer/domain/use_cases/create_room_use_case_test.dart',
    'test/features/multiplayer/domain/use_cases/join_room_use_case_test.dart',
    'test/features/multiplayer/domain/use_cases/sync_game_state_use_case_test.dart',
    'test/features/game/domain/use_cases/discard_card_test.dart',
    'test/features/game/domain/use_cases/end_turn_test.dart',
  ];

  // Skip already migrated files
  final alreadyMigrated = [
    'test/features/game/domain/entities/card_test.dart',
    'test/features/game/domain/use_cases/calculate_scores_test.dart',
  ];

  int migratedCount = 0;
  int skippedCount = 0;
  int errorCount = 0;

  for (final filePath in testFiles) {
    if (alreadyMigrated.contains(filePath)) {
      print('✅ Already migrated: $filePath');
      skippedCount++;
      continue;
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      print('❌ File not found: $filePath');
      errorCount++;
      continue;
    }

    try {
      print('📝 Migrating: $filePath');
      final content = file.readAsStringSync();
      final migrated = _migrateTestFile(content, filePath);
      
      // Create backup
      final backupPath = filePath.replaceAll('.dart', '_backup.dart');
      File(backupPath).writeAsStringSync(content);
      
      // Write migrated content
      file.writeAsStringSync(migrated);
      
      print('✅ Migrated: $filePath');
      migratedCount++;
    } catch (e) {
      print('❌ Error migrating $filePath: $e');
      errorCount++;
    }
  }

  print('\n📊 Migration Summary:');
  print('   ✅ Migrated: $migratedCount files');
  print('   ⏭️  Skipped: $skippedCount files');
  print('   ❌ Errors: $errorCount files');
}

String _migrateTestFile(String content, String filePath) {
  var migrated = content;

  // Add imports for test helpers
  if (!migrated.contains('test_data_builders.dart')) {
    final relativeImportPath = _calculateRelativeImportPath(filePath);
    final importStatement = "import '$relativeImportPath/helpers/test_data_builders.dart';\n";
    final customMatchersImport = "import '$relativeImportPath/helpers/custom_matchers.dart';\n";
    
    // Find the last import statement
    final importRegex = RegExp(r'''^import\s+['"].*['"];''', multiLine: true);
    final matches = importRegex.allMatches(migrated).toList();
    
    if (matches.isNotEmpty) {
      final lastImport = matches.last;
      migrated = migrated.substring(0, lastImport.end) +
          '\n' + importStatement + customMatchersImport +
          migrated.substring(lastImport.end);
    }
  }

  // Convert test names to should_when pattern
  migrated = _convertTestNames(migrated);

  // Add Arrange/Act/Assert comments
  migrated = _addArrangeActAssertComments(migrated);

  // Extract constants
  migrated = _extractConstants(migrated);

  // Replace direct constructors with builders where applicable
  migrated = _replaceWithBuilders(migrated);

  // Improve assertions
  migrated = _improveAssertions(migrated);

  // Group related tests
  migrated = _groupRelatedTests(migrated);

  return migrated;
}

String _calculateRelativeImportPath(String filePath) {
  final depth = filePath.split('/').length - 2; // -1 for 'test' and -1 for filename
  return List.filled(depth, '..').join('/');
}

String _convertTestNames(String content) {
  // Convert test names to should_when pattern
  final testRegex = RegExp(
    r'''test\s*\(\s*['"]([^'"]+)['"]\\s*,''',
    multiLine: true,
  );

  return content.replaceAllMapped(testRegex, (match) {
    final originalName = match.group(1)!;
    final convertedName = _convertToShouldWhenPattern(originalName);
    return "test('$convertedName',";
  });
}

String _convertToShouldWhenPattern(String testName) {
  // Simple heuristic conversion
  testName = testName.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), ' ');
  
  // Common patterns
  if (testName.contains('return') || testName.contains('calculate') || testName.contains('create')) {
    final parts = testName.split(' ');
    final verb = parts.firstWhere((p) => ['return', 'calculate', 'create', 'generate', 'validate'].contains(p), orElse: () => 'work');
    return 'should_${verb}_${parts.where((p) => p != verb).join('_')}'.replaceAll(RegExp(r'_+'), '_').trim();
  }
  
  if (testName.startsWith('should ')) {
    return testName.replaceAll(' ', '_');
  }
  
  return 'should_${testName.replaceAll(' ', '_')}';
}

String _addArrangeActAssertComments(String content) {
  // Add comments for test structure - this is a simplified version
  final testBodyRegex = RegExp(
    r"test\s*\([^)]+\)\s*\{([^}]+)\}",
    multiLine: true,
    dotAll: true,
  );

  return content.replaceAllMapped(testBodyRegex, (match) {
    final body = match.group(1)!;
    
    // Check if comments already exist
    if (body.contains('// Arrange') || body.contains('// Act') || body.contains('// Assert')) {
      return match.group(0)!;
    }
    
    // Try to identify sections
    final lines = body.split('\n');
    final structuredBody = StringBuffer();
    bool hasArrange = false;
    bool hasAct = false;
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      
      // Skip empty lines at the beginning
      if (!hasArrange && trimmedLine.isEmpty) continue;
      
      // Arrange section (variable declarations, setup)
      if (!hasArrange && (trimmedLine.startsWith('final') || 
          trimmedLine.startsWith('const') || 
          trimmedLine.startsWith('var') ||
          trimmedLine.contains('Builder()'))) {
        structuredBody.writeln('        // Arrange');
        hasArrange = true;
      }
      
      // Act section (method calls, operations)
      if (hasArrange && !hasAct && (trimmedLine.contains('await') || 
          trimmedLine.contains('=') && !trimmedLine.startsWith('final') && !trimmedLine.startsWith('const') ||
          trimmedLine.contains('(') && !trimmedLine.startsWith('expect'))) {
        structuredBody.writeln('\n        // Act');
        hasAct = true;
      }
      
      // Assert section (expect statements)
      if ((hasArrange || hasAct) && trimmedLine.startsWith('expect')) {
        if (!structuredBody.toString().contains('// Assert')) {
          structuredBody.writeln('\n        // Assert');
        }
      }
      
      structuredBody.writeln(line);
    }
    
    return 'test${match.group(0)!.substring(4, match.group(0)!.indexOf('{'))} {${structuredBody.toString()}}';
  });
}

String _extractConstants(String content) {
  // Extract magic numbers to constants
  final numberRegex = RegExp(r'\b(\d+)\b');
  final constants = <int, String>{};
  
  // Common game constants
  constants[12] = 'MAX_CARDS_IN_GRID';
  constants[8] = 'MAX_PLAYERS';
  constants[5] = 'DEFAULT_MAX_ROUNDS';
  constants[3] = 'MAX_ACTION_CARDS';
  constants[-2] = 'MINIMUM_CARD_VALUE';
  constants[13] = 'MAXIMUM_CARD_VALUE';
  
  var result = content;
  
  // Add constants at the beginning of test groups
  final groupRegex = RegExp(r"group\s*\([^{]+\{\s*");
  result = result.replaceAllMapped(groupRegex, (match) {
    final constantsBlock = StringBuffer();
    constantsBlock.writeln('${match.group(0)}');
    constantsBlock.writeln('    // Test constants for clarity');
    
    // Add relevant constants based on what's used in the file
    for (final entry in constants.entries) {
      if (content.contains(entry.key.toString())) {
        constantsBlock.writeln('    const int ${entry.value} = ${entry.key};');
      }
    }
    constantsBlock.writeln();
    
    return constantsBlock.toString();
  });
  
  return result;
}

String _replaceWithBuilders(String content) {
  // Replace direct constructors with builders
  final replacements = {
    r'Card\(value:\s*(\d+)\)': (Match m) => 'CardBuilder().withValue(${m.group(1)}).build()',
    r'Card\(value:\s*(\d+),\s*isRevealed:\s*(true|false)\)': (Match m) => 
        'CardBuilder().withValue(${m.group(1)}).${m.group(2) == "true" ? "revealed()" : "hidden()"}.build()',
    r'GamePlayer\(id:\s*[\'"]([^\'\"]+)[\'"],\s*name:\s*[\'"]([^\'\"]+)[\'"]': (Match m) =>
        'GamePlayerBuilder().withId(\'${m.group(1)}\').withName(\'${m.group(2)}\')',
  };
  
  var result = content;
  for (final entry in replacements.entries) {
    result = result.replaceAllMapped(RegExp(entry.key), entry.value);
  }
  
  return result;
}

String _improveAssertions(String content) {
  // Add reason to expect statements that don't have one
  final expectRegex = RegExp(
    r'expect\s*\(\s*([^,]+),\s*([^,)]+)\s*\);',
    multiLine: true,
  );
  
  return content.replaceAllMapped(expectRegex, (match) {
    final actual = match.group(1)!.trim();
    final matcher = match.group(2)!.trim();
    
    // Generate a reason based on the assertion
    String reason = '';
    if (actual.contains('score')) {
      reason = 'Score calculation should be accurate';
    } else if (actual.contains('isRevealed')) {
      reason = 'Card revelation state should be correct';
    } else if (actual.contains('value')) {
      reason = 'Value should match expected result';
    } else if (actual.contains('player')) {
      reason = 'Player state should be properly updated';
    } else {
      reason = 'Result should match expected value';
    }
    
    return 'expect(\n          $actual,\n          $matcher,\n          reason: \'$reason\',\n        );';
  });
}

String _groupRelatedTests(String content) {
  // This is a complex operation that would require parsing the test structure
  // For now, we'll just ensure tests are properly indented
  return content;
}