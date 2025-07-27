import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/logging/console_logger.dart';
import '../services/logging/i_error_logger.dart';

part 'logger_provider.g.dart';

/// Provider for the error logger instance
@riverpod
IErrorLogger errorLogger(ErrorLoggerRef ref) {
  final logger = ConsoleLogger();
  
  // Dispose when provider is disposed
  ref.onDispose(() {
    if (logger is ConsoleLogger) {
      logger.dispose();
    }
  });
  
  return logger;
}

/// Provider for logger configuration
@riverpod
class LoggerConfig extends _$LoggerConfig {
  @override
  LoggerConfigState build() {
    return const LoggerConfigState(
      useColors: true,
      maxLogsPerMinute: 100,
      bufferSize: 50,
    );
  }
  
  void setUseColors(bool useColors) {
    state = state.copyWith(useColors: useColors);
    
    // Update the logger instance
    final logger = ref.read(errorLoggerProvider);
    logger.setUseColors(useColors);
  }
  
  void setMaxLogsPerMinute(int maxLogs) {
    state = state.copyWith(maxLogsPerMinute: maxLogs);
  }
  
  void setBufferSize(int bufferSize) {
    state = state.copyWith(bufferSize: bufferSize);
  }
}

/// State for logger configuration
class LoggerConfigState {
  final bool useColors;
  final int maxLogsPerMinute;
  final int bufferSize;
  
  const LoggerConfigState({
    required this.useColors,
    required this.maxLogsPerMinute,
    required this.bufferSize,
  });
  
  LoggerConfigState copyWith({
    bool? useColors,
    int? maxLogsPerMinute,
    int? bufferSize,
  }) {
    return LoggerConfigState(
      useColors: useColors ?? this.useColors,
      maxLogsPerMinute: maxLogsPerMinute ?? this.maxLogsPerMinute,
      bufferSize: bufferSize ?? this.bufferSize,
    );
  }
}