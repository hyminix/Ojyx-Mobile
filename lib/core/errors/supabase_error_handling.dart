import 'package:supabase_flutter/supabase_flutter.dart';

/// Extension pour améliorer la gestion d'erreurs Supabase
extension SupabaseErrorHandling on PostgrestException {
  /// Retourne un message user-friendly basé sur le code d'erreur
  String get userMessage {
    switch (code) {
      case '23505':
        return 'Cette donnée existe déjà';
      case '23503':
        return 'Référence invalide';
      case '42501':
        return 'Permission refusée';
      case 'PGRST301':
        return 'Aucune donnée trouvée';
      case '42P01':
        return 'Table non trouvée';
      case '42703':
        return 'Colonne non trouvée';
      case '22P02':
        return 'Format de données invalide';
      case '23502':
        return 'Donnée requise manquante';
      case '23514':
        return 'Contrainte de validation échouée';
      case '40001':
        return 'Conflit de transaction, veuillez réessayer';
      case '40P01':
        return 'Deadlock détecté, veuillez réessayer';
      case '53300':
        return 'Trop de connexions simultanées';
      case '57014':
        return 'Requête annulée (timeout)';
      default:
        return 'Une erreur est survenue: $message';
    }
  }

  /// Indique si l'erreur est temporaire et peut être réessayée
  bool get isRetriable {
    return const ['40001', '40P01', '53300', '57014'].contains(code);
  }

  /// Indique si l'erreur est liée aux permissions
  bool get isPermissionError {
    return code == '42501';
  }

  /// Indique si l'erreur est liée à des données manquantes
  bool get isNotFoundError {
    return code == 'PGRST301' || code == '42P01';
  }
}

/// Extension pour la gestion d'erreurs d'authentification
extension AuthErrorHandling on AuthException {
  /// Retourne un message user-friendly pour les erreurs d'auth
  String get userMessage {
    // Check common error messages
    if (message.contains('Invalid login credentials')) {
      return 'Identifiants invalides';
    }
    if (message.contains('Email not confirmed')) {
      return 'Email non confirmé';
    }
    if (message.contains('User already registered')) {
      return 'Utilisateur déjà enregistré';
    }
    if (message.contains('Password should be at least')) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (message.contains('Invalid email')) {
      return 'Email invalide';
    }
    if (message.contains('User not found')) {
      return 'Utilisateur non trouvé';
    }
    if (message.contains('Invalid refresh token')) {
      return 'Session expirée, veuillez vous reconnecter';
    }
    if (message.contains('Network request failed')) {
      return 'Erreur de connexion réseau';
    }
    if (statusCode == '400') {
      return 'Requête invalide';
    }
    if (statusCode == '401') {
      return 'Non autorisé';
    }
    if (statusCode == '403') {
      return 'Accès refusé';
    }
    if (statusCode == '404') {
      return 'Ressource non trouvée';
    }
    if (statusCode == '429') {
      return 'Trop de tentatives, veuillez réessayer plus tard';
    }
    if (statusCode == '500') {
      return 'Erreur serveur, veuillez réessayer';
    }

    return 'Erreur d\'authentification: $message';
  }

  /// Indique si l'erreur est temporaire
  bool get isRetriable {
    return statusCode == '429' ||
        statusCode == '500' ||
        message.contains('Network request failed');
  }

  /// Indique si l'utilisateur doit se reconnecter
  bool get requiresReauth {
    return message.contains('Invalid refresh token') || statusCode == '401';
  }
}

/// Extension pour la gestion d'erreurs de Storage
extension StorageErrorHandling on StorageException {
  /// Retourne un message user-friendly pour les erreurs de storage
  String get userMessage {
    if (message.contains('The resource already exists')) {
      return 'Ce fichier existe déjà';
    }
    if (message.contains('Invalid file size')) {
      return 'Taille de fichier invalide';
    }
    if (message.contains('Invalid mime type')) {
      return 'Type de fichier non autorisé';
    }
    if (message.contains('Object not found')) {
      return 'Fichier non trouvé';
    }
    if (message.contains('Bucket not found')) {
      return 'Espace de stockage non trouvé';
    }
    if (statusCode == '413') {
      return 'Fichier trop volumineux';
    }
    if (statusCode == '507') {
      return 'Espace de stockage insuffisant';
    }

    return 'Erreur de stockage: $message';
  }
}

/// Classe d'exception personnalisée pour l'application
class AppException implements Exception {
  final String message;
  final String? code;
  final bool isRetriable;
  final dynamic originalException;

  const AppException({
    required this.message,
    this.code,
    this.isRetriable = false,
    this.originalException,
  });

  /// Crée une AppException depuis une PostgrestException
  factory AppException.fromPostgrest(PostgrestException e) {
    return AppException(
      message: e.userMessage,
      code: e.code,
      isRetriable: e.isRetriable,
      originalException: e,
    );
  }

  /// Crée une AppException depuis une AuthException
  factory AppException.fromAuth(AuthException e) {
    return AppException(
      message: e.userMessage,
      code: e.statusCode,
      isRetriable: e.isRetriable,
      originalException: e,
    );
  }

  /// Crée une AppException depuis une StorageException
  factory AppException.fromStorage(StorageException e) {
    return AppException(
      message: e.userMessage,
      code: e.statusCode,
      isRetriable: false,
      originalException: e,
    );
  }

  @override
  String toString() => 'AppException: $message (code: $code)';
}
