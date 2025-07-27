import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'i_error_logger.dart';

/// Console implementation of the error logger with buffering
class ConsoleLogger implements IErrorLogger {
  static const int _bufferSize = 50;
  static const Duration _flushInterval = Duration(seconds: 1);
  
  final Queue<LogEntry> _buffer = Queue<LogEntry>();
  Timer? _flushTimer;
  bool _useColors = true;
  void Function(LogEntry entry)? _onLogCallback;
  
  // Session ID for correlating logs
  final String sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  
  // Rate limiting
  final Map<String, int> _categoryCounters = {};
  final Map<String, DateTime> _categoryLastLog = {};
  static const int _maxLogsPerMinute = 100;
  
  ConsoleLogger({bool useColors = true}) : _useColors = useColors {
    _startFlushTimer();
  }

  void _startFlushTimer() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(_flushInterval, (_) {
      if (_buffer.isNotEmpty) {
        flush();
      }
    });
  }

  @override
  void logDebug(
    String message, {
    required String category,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return; // Only log debug in debug mode
    
    log(LogEntry(
      level: LogLevel.debug,
      category: category,
      message: message,
      data: data,
      stackTrace: stackTrace,
      sessionId: sessionId,
    ));
  }

  @override
  void logInfo(
    String message, {
    required String category,
    Map<String, dynamic>? data,
  }) {
    log(LogEntry(
      level: LogLevel.info,
      category: category,
      message: message,
      data: data,
      sessionId: sessionId,
    ));
  }

  @override
  void logWarning(
    String message, {
    required String category,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  }) {
    log(LogEntry(
      level: LogLevel.warning,
      category: category,
      message: message,
      data: data,
      stackTrace: stackTrace,
      sessionId: sessionId,
    ));
  }

  @override
  void logError(
    String message, {
    required String category,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
    Duration? duration,
  }) {
    log(LogEntry(
      level: LogLevel.error,
      category: category,
      message: message,
      data: data,
      stackTrace: stackTrace,
      sessionId: sessionId,
      duration: duration,
    ));
  }

  @override
  void log(LogEntry entry) {
    // Rate limiting check
    if (!_shouldLog(entry.category)) {
      // Add a rate limit warning for the first rejection per category
      final key = 'rate_limit_warning_${entry.category}';
      if (!_categoryCounters.containsKey(key)) {
        _categoryCounters[key] = 1;
        final warningEntry = LogEntry(
          level: LogLevel.warning,
          category: 'logger',
          message: 'Rate limit exceeded for category: ${entry.category}',
          sessionId: sessionId,
        );
        _buffer.add(warningEntry);
        _onLogCallback?.call(warningEntry);
      }
      return;
    }
    
    // Add to buffer
    _buffer.add(entry);
    
    // Call callback if set
    _onLogCallback?.call(entry);
    
    // Flush if buffer is full or if it's an error
    if (_buffer.length >= _bufferSize || entry.level == LogLevel.error) {
      flush();
    }
  }

  bool _shouldLog(String category) {
    final now = DateTime.now();
    final lastLog = _categoryLastLog[category];
    
    // Reset counter if more than a minute has passed
    if (lastLog == null || now.difference(lastLog).inMinutes >= 1) {
      _categoryCounters[category] = 0;
      _categoryLastLog[category] = now;
    }
    
    final count = _categoryCounters[category] ?? 0;
    if (count >= _maxLogsPerMinute) {
      return false;
    }
    
    _categoryCounters[category] = count + 1;
    return true;
  }

  @override
  Future<void> flush() async {
    if (_buffer.isEmpty) return;
    
    // Copy buffer and clear
    final entries = List<LogEntry>.from(_buffer);
    _buffer.clear();
    
    // Output to console
    for (final entry in entries) {
      _outputToConsole(entry);
    }
  }

  void _outputToConsole(LogEntry entry) {
    final output = entry.toConsoleString(useColors: _useColors);
    
    // Use debugPrint for better Flutter integration
    debugPrint(output);
    
    // Print stack trace if present and in debug mode
    if (entry.stackTrace != null && kDebugMode && entry.level == LogLevel.error) {
      debugPrint('Stack trace:');
      debugPrint(entry.stackTrace.toString());
    }
  }

  @override
  void setUseColors(bool useColors) {
    _useColors = useColors;
  }

  @override
  void setOnLogCallback(void Function(LogEntry entry)? callback) {
    _onLogCallback = callback;
  }

  /// Dispose of resources
  void dispose() {
    flush();
    _flushTimer?.cancel();
  }
}

/// Singleton instance for easy access
class ErrorLogger {
  static ConsoleLogger? _instance;
  
  static ConsoleLogger get instance {
    _instance ??= ConsoleLogger();
    return _instance!;
  }
  
  /// Initialize with custom settings
  static void initialize({
    bool useColors = true,
    void Function(LogEntry entry)? onLogCallback,
  }) {
    _instance?.dispose();
    _instance = ConsoleLogger(useColors: useColors);
    _instance!.setOnLogCallback(onLogCallback);
  }
  
  /// Convenience methods
  static void debug(String message, {required String category, Map<String, dynamic>? data}) {
    instance.logDebug(message, category: category, data: data);
  }
  
  static void info(String message, {required String category, Map<String, dynamic>? data}) {
    instance.logInfo(message, category: category, data: data);
  }
  
  static void warning(String message, {required String category, Map<String, dynamic>? data}) {
    instance.logWarning(message, category: category, data: data);
  }
  
  static void error(
    String message, {
    required String category,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
    Duration? duration,
  }) {
    instance.logError(
      message,
      category: category,
      data: data,
      stackTrace: stackTrace,
      duration: duration,
    );
  }
  
  /// Log Supabase-specific error
  static void supabaseError({
    required String operation,
    required String errorMessage,
    String? errorCode,
    int? retryCount,
    Duration? duration,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) {
    final data = <String, dynamic>{
      'operation': operation,
      if (errorCode != null) 'error_code': errorCode,
      if (retryCount != null) 'retry_count': retryCount,
      ...?additionalData,
    };
    
    instance.logError(
      errorMessage,
      category: 'supabase',
      data: data,
      stackTrace: stackTrace,
      duration: duration,
    );
  }
}