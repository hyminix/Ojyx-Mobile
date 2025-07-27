import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/services/logging/console_logger.dart';
import 'package:ojyx/core/services/logging/i_error_logger.dart';

void main() {
  group('ConsoleLogger', () {
    late ConsoleLogger logger;
    late List<LogEntry> capturedLogs;

    setUp(() {
      capturedLogs = [];
      logger = ConsoleLogger(useColors: false); // Disable colors for testing
      logger.setOnLogCallback((entry) {
        capturedLogs.add(entry);
      });
    });

    tearDown(() {
      logger.dispose();
    });

    test('should log different levels correctly', () async {
      logger.logDebug('Debug message', category: 'test');
      logger.logInfo('Info message', category: 'test');
      logger.logWarning('Warning message', category: 'test');
      logger.logError('Error message', category: 'test');

      await logger.flush();

      // Debug logs only appear in debug mode
      expect(capturedLogs.length, greaterThanOrEqualTo(3));
      
      final infoLog = capturedLogs.firstWhere((e) => e.level == LogLevel.info);
      expect(infoLog.message, equals('Info message'));
      expect(infoLog.category, equals('test'));
      
      final warningLog = capturedLogs.firstWhere((e) => e.level == LogLevel.warning);
      expect(warningLog.message, equals('Warning message'));
      
      final errorLog = capturedLogs.firstWhere((e) => e.level == LogLevel.error);
      expect(errorLog.message, equals('Error message'));
    });

    test('should include data in logs', () async {
      logger.logInfo(
        'User logged in',
        category: 'auth',
        data: {
          'user_id': '123',
          'method': 'email',
        },
      );

      await logger.flush();

      expect(capturedLogs.length, equals(1));
      expect(capturedLogs.first.data, isNotNull);
      expect(capturedLogs.first.data!['user_id'], equals('123'));
      expect(capturedLogs.first.data!['method'], equals('email'));
    });

    test('should include duration in error logs', () async {
      final duration = Duration(milliseconds: 250);
      
      logger.logError(
        'Database query failed',
        category: 'database',
        duration: duration,
      );

      await logger.flush();

      expect(capturedLogs.length, equals(1));
      expect(capturedLogs.first.duration, equals(duration));
    });

    test('should enforce rate limiting', () async {
      // Log many messages quickly
      for (int i = 0; i < 150; i++) {
        logger.logInfo('Message $i', category: 'spam');
      }

      await logger.flush();

      // Should be limited to around 100 messages + 1 warning
      expect(capturedLogs.length, lessThanOrEqualTo(101));
      
      // Should have logged exactly 100 messages plus one or more rate limit warnings
      final regularLogs = capturedLogs.where((log) => log.category == 'spam').length;
      final rateLimitWarnings = capturedLogs.where((log) => 
        log.category == 'logger' && 
        log.message.contains('Rate limit exceeded')
      ).length;
      
      expect(regularLogs, equals(100)); // Rate limit is 100 per minute
      expect(rateLimitWarnings, greaterThan(0)); // Should have at least one warning
    });

    test('should format log entries correctly', () {
      final entry = LogEntry(
        level: LogLevel.error,
        category: 'test',
        message: 'Test error',
        data: {'code': 'ERR_001'},
        duration: Duration(milliseconds: 150),
      );

      final formatted = entry.toConsoleString(useColors: false);
      
      expect(formatted, contains('[ERROR]'));
      expect(formatted, contains('[test]'));
      expect(formatted, contains('Test error'));
      expect(formatted, contains('code=ERR_001'));
      expect(formatted, contains('duration=150ms'));
    });

    test('should generate consistent session IDs', () async {
      logger.logInfo('Message 1', category: 'test');
      logger.logInfo('Message 2', category: 'test');

      await logger.flush();

      expect(capturedLogs.length, equals(2));
      expect(capturedLogs[0].sessionId, equals(capturedLogs[1].sessionId));
    });

    test('should auto-flush on errors', () async {
      logger.logError('Critical error', category: 'system');
      
      // Don't call flush manually - should auto-flush
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(capturedLogs.length, equals(1));
      expect(capturedLogs.first.level, equals(LogLevel.error));
    });

    test('should convert log entry to map', () {
      final entry = LogEntry(
        level: LogLevel.info,
        category: 'test',
        message: 'Test message',
        data: {'key': 'value'},
        sessionId: 'test-session',
      );

      final map = entry.toMap();
      
      expect(map['level'], equals('INFO'));
      expect(map['category'], equals('test'));
      expect(map['message'], equals('Test message'));
      expect(map['data'], equals({'key': 'value'}));
      expect(map['session_id'], equals('test-session'));
    });
  });

  group('ErrorLogger static methods', () {
    setUp(() {
      ErrorLogger.initialize(useColors: false);
    });

    test('should provide convenient static methods', () {
      final logs = <LogEntry>[];
      ErrorLogger.instance.setOnLogCallback((entry) => logs.add(entry));

      ErrorLogger.info('Info message', category: 'static');
      ErrorLogger.warning('Warning message', category: 'static');
      ErrorLogger.error('Error message', category: 'static');
      
      ErrorLogger.instance.flush();

      expect(logs.length, greaterThanOrEqualTo(3));
    });

    test('should log Supabase errors with proper formatting', () {
      final logs = <LogEntry>[];
      ErrorLogger.instance.setOnLogCallback((entry) => logs.add(entry));

      ErrorLogger.supabaseError(
        operation: 'insert_user',
        errorMessage: 'Duplicate key violation',
        errorCode: '23505',
        retryCount: 3,
        duration: Duration(milliseconds: 450),
        additionalData: {'table': 'users'},
      );
      
      ErrorLogger.instance.flush();

      expect(logs.length, equals(1));
      final log = logs.first;
      
      expect(log.category, equals('supabase'));
      expect(log.message, equals('Duplicate key violation'));
      expect(log.duration, equals(Duration(milliseconds: 450)));
      expect(log.data!['operation'], equals('insert_user'));
      expect(log.data!['error_code'], equals('23505'));
      expect(log.data!['retry_count'], equals(3));
      expect(log.data!['table'], equals('users'));
    });
  });
}