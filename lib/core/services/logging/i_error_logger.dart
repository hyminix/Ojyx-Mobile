import 'package:flutter/foundation.dart';

/// Log levels for the error logger
enum LogLevel {
  debug('DEBUG', 90),
  info('INFO', 37),    // cyan
  warning('WARN', 33), // yellow
  error('ERROR', 31);  // red

  final String label;
  final int colorCode;

  const LogLevel(this.label, this.colorCode);

  /// Get ANSI color code for console output
  String get ansiColor => '\x1B[${colorCode}m';
  
  /// Reset ANSI color
  static const String ansiReset = '\x1B[0m';
}

/// Log entry structure
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String category;
  final String message;
  final Map<String, dynamic>? data;
  final StackTrace? stackTrace;
  final String? sessionId;
  final Duration? duration;

  LogEntry({
    DateTime? timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.data,
    this.stackTrace,
    this.sessionId,
    this.duration,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert to structured map
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'level': level.label,
      'category': category,
      'message': message,
      if (data != null && data!.isNotEmpty) 'data': data,
      if (sessionId != null) 'session_id': sessionId,
      if (duration != null) 'duration_ms': duration!.inMilliseconds,
      if (stackTrace != null && kDebugMode) 'stack_trace': stackTrace.toString(),
    };
  }

  /// Format for console output
  String toConsoleString({bool useColors = true}) {
    final buffer = StringBuffer();
    
    // Timestamp
    if (useColors) {
      buffer.write('\x1B[34m'); // blue
    }
    buffer.write('[${timestamp.toIso8601String()}]');
    if (useColors) {
      buffer.write(LogLevel.ansiReset);
    }
    
    // Level
    buffer.write(' ');
    if (useColors) {
      buffer.write(level.ansiColor);
    }
    buffer.write('[${level.label}]');
    if (useColors) {
      buffer.write(LogLevel.ansiReset);
    }
    
    // Category
    buffer.write(' ');
    if (useColors) {
      buffer.write('\x1B[36m'); // cyan
    }
    buffer.write('[$category]');
    if (useColors) {
      buffer.write(LogLevel.ansiReset);
    }
    
    // Message
    buffer.write(' $message');
    
    // Data
    if (data != null && data!.isNotEmpty) {
      buffer.write(' | ');
      data!.forEach((key, value) {
        buffer.write('$key=$value ');
      });
    }
    
    // Duration
    if (duration != null) {
      buffer.write(' | ');
      if (useColors) {
        buffer.write('\x1B[32m'); // green
      }
      buffer.write('duration=${duration!.inMilliseconds}ms');
      if (useColors) {
        buffer.write(LogLevel.ansiReset);
      }
    }
    
    return buffer.toString();
  }
}

/// Interface for error logger implementations
abstract class IErrorLogger {
  /// Log a debug message
  void logDebug(
    String message, {
    required String category,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  });

  /// Log an info message
  void logInfo(
    String message, {
    required String category,
    Map<String, dynamic>? data,
  });

  /// Log a warning
  void logWarning(
    String message, {
    required String category,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  });

  /// Log an error
  void logError(
    String message, {
    required String category,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
    Duration? duration,
  });

  /// Log a structured entry
  void log(LogEntry entry);

  /// Flush any buffered logs
  Future<void> flush();

  /// Set whether to use colors in output
  void setUseColors(bool useColors);

  /// Set a callback for when logs are written
  void setOnLogCallback(void Function(LogEntry entry)? callback);
}