import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_errors.freezed.dart';
part 'custom_errors.g.dart';

/// Base interface for all application errors
abstract class AppError implements Exception {
  String toUserMessage();
}

/// Network-related errors (timeouts, connection issues)
@freezed
class NetworkError with _$NetworkError implements AppError {
  const NetworkError._();
  
  const factory NetworkError({
    required String code,
    required String message,
    String? details,
    required String operation,
    required DateTime timestamp,
    int? statusCode,
    Duration? timeout,
  }) = _NetworkError;

  factory NetworkError.fromException(
    Exception exception, {
    required String operation,
  }) {
    return NetworkError(
      code: 'NETWORK_ERROR',
      message: exception.toString(),
      operation: operation,
      timestamp: DateTime.now(),
    );
  }

  factory NetworkError.timeout({
    required String operation,
    required Duration timeout,
  }) {
    return NetworkError(
      code: 'TIMEOUT',
      message: 'Operation timed out after ${timeout.inSeconds} seconds',
      operation: operation,
      timestamp: DateTime.now(),
      timeout: timeout,
    );
  }

  @override
  String toUserMessage() {
    switch (code) {
      case 'TIMEOUT':
        return 'La connexion a pris trop de temps. Veuillez réessayer.';
      case 'NO_INTERNET':
        return 'Aucune connexion internet détectée.';
      default:
        return 'Erreur de connexion. Veuillez vérifier votre réseau.';
    }
  }

  factory NetworkError.fromJson(Map<String, dynamic> json) =>
      _$NetworkErrorFromJson(json);
}

/// Authentication-related errors
@freezed
class AuthError with _$AuthError implements AppError {
  const AuthError._();
  
  const factory AuthError({
    required String code,
    required String message,
    String? details,
    required String operation,
    required DateTime timestamp,
    String? userId,
  }) = _AuthError;

  factory AuthError.fromSupabaseAuth(
    dynamic exception, {
    required String operation,
  }) {
    final message = exception.toString();
    String code = 'AUTH_ERROR';
    
    if (message.contains('Invalid login')) {
      code = 'INVALID_CREDENTIALS';
    } else if (message.contains('User not found')) {
      code = 'USER_NOT_FOUND';
    } else if (message.contains('Email not confirmed')) {
      code = 'EMAIL_NOT_CONFIRMED';
    }
    
    return AuthError(
      code: code,
      message: message,
      operation: operation,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toUserMessage() {
    switch (code) {
      case 'INVALID_CREDENTIALS':
        return 'Identifiants incorrects.';
      case 'USER_NOT_FOUND':
        return 'Utilisateur introuvable.';
      case 'EMAIL_NOT_CONFIRMED':
        return 'Veuillez confirmer votre email.';
      case 'SESSION_EXPIRED':
        return 'Votre session a expiré. Veuillez vous reconnecter.';
      default:
        return 'Erreur d\'authentification.';
    }
  }

  factory AuthError.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorFromJson(json);
}

/// Database-related errors (PostgreSQL, Supabase)
@freezed
class DatabaseError with _$DatabaseError implements AppError {
  const DatabaseError._();
  
  const factory DatabaseError({
    required String code,
    required String message,
    String? details,
    required String operation,
    required DateTime timestamp,
    String? table,
    String? constraint,
    Map<String, dynamic>? queryParams,
  }) = _DatabaseError;

  factory DatabaseError.fromPostgrest(
    dynamic exception, {
    required String operation,
    String? table,
  }) {
    String code = 'DATABASE_ERROR';
    String message = exception.toString();
    String? constraint;
    
    // Parse PostgrestException
    if (exception.toString().contains('duplicate key')) {
      code = 'DUPLICATE_KEY';
      // Extract constraint name if possible
      final constraintMatch = RegExp(r'constraint "([^"]+)"').firstMatch(message);
      constraint = constraintMatch?.group(1);
    } else if (exception.toString().contains('foreign key')) {
      code = 'FOREIGN_KEY_VIOLATION';
    } else if (exception.toString().contains('not found')) {
      code = 'NOT_FOUND';
    } else if (exception.toString().contains('permission denied')) {
      code = 'PERMISSION_DENIED';
    }
    
    return DatabaseError(
      code: code,
      message: message,
      operation: operation,
      timestamp: DateTime.now(),
      table: table,
      constraint: constraint,
    );
  }

  @override
  String toUserMessage() {
    switch (code) {
      case 'DUPLICATE_KEY':
        return 'Cette donnée existe déjà.';
      case 'FOREIGN_KEY_VIOLATION':
        return 'Référence invalide.';
      case 'NOT_FOUND':
        return 'Donnée introuvable.';
      case 'PERMISSION_DENIED':
        return 'Vous n\'avez pas les permissions nécessaires.';
      default:
        return 'Erreur de base de données.';
    }
  }

  factory DatabaseError.fromJson(Map<String, dynamic> json) =>
      _$DatabaseErrorFromJson(json);
}

/// Storage-related errors
@freezed
class StorageError with _$StorageError implements AppError {
  const StorageError._();
  
  const factory StorageError({
    required String code,
    required String message,
    String? details,
    required String operation,
    required DateTime timestamp,
    String? bucket,
    String? path,
    int? sizeLimit,
  }) = _StorageError;

  factory StorageError.fromSupabaseStorage(
    dynamic exception, {
    required String operation,
    String? bucket,
    String? path,
  }) {
    String code = 'STORAGE_ERROR';
    final message = exception.toString();
    
    if (message.contains('size limit')) {
      code = 'SIZE_LIMIT_EXCEEDED';
    } else if (message.contains('not found')) {
      code = 'FILE_NOT_FOUND';
    } else if (message.contains('permission')) {
      code = 'PERMISSION_DENIED';
    }
    
    return StorageError(
      code: code,
      message: message,
      operation: operation,
      timestamp: DateTime.now(),
      bucket: bucket,
      path: path,
    );
  }

  @override
  String toUserMessage() {
    switch (code) {
      case 'SIZE_LIMIT_EXCEEDED':
        return 'Le fichier est trop volumineux.';
      case 'FILE_NOT_FOUND':
        return 'Fichier introuvable.';
      case 'PERMISSION_DENIED':
        return 'Accès au fichier refusé.';
      default:
        return 'Erreur de stockage.';
    }
  }

  factory StorageError.fromJson(Map<String, dynamic> json) =>
      _$StorageErrorFromJson(json);
}