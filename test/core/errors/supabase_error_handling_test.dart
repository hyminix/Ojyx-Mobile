import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/errors/supabase_error_handling.dart';

void main() {
  group('SupabaseErrorHandling', () {
    group('PostgrestException extensions', () {
      test('should return user-friendly message for common error codes', () {
        final testCases = [
          ('23505', 'Cette donnée existe déjà'),
          ('23503', 'Référence invalide'),
          ('42501', 'Permission refusée'),
          ('PGRST301', 'Aucune donnée trouvée'),
          ('42P01', 'Table non trouvée'),
          ('42703', 'Colonne non trouvée'),
          ('22P02', 'Format de données invalide'),
          ('23502', 'Donnée requise manquante'),
          ('23514', 'Contrainte de validation échouée'),
          ('40001', 'Conflit de transaction, veuillez réessayer'),
          ('40P01', 'Deadlock détecté, veuillez réessayer'),
          ('53300', 'Trop de connexions simultanées'),
          ('57014', 'Requête annulée (timeout)'),
        ];

        for (final (code, expectedMessage) in testCases) {
          final exception = PostgrestException(
            message: 'Technical error message',
            code: code,
          );

          expect(exception.userMessage, equals(expectedMessage));
        }
      });

      test('should return default message for unknown error codes', () {
        final exception = const PostgrestException(
          message: 'Unknown error occurred',
          code: 'UNKNOWN',
        );

        expect(
          exception.userMessage,
          equals('Une erreur est survenue: Unknown error occurred'),
        );
      });

      test('should identify retriable errors correctly', () {
        final retriableErrors = ['40001', '40P01', '53300', '57014'];
        final nonRetriableErrors = ['23505', '42501', 'PGRST301'];

        for (final code in retriableErrors) {
          final exception = PostgrestException(message: '', code: code);
          expect(
            exception.isRetriable,
            isTrue,
            reason: 'Code $code should be retriable',
          );
        }

        for (final code in nonRetriableErrors) {
          final exception = PostgrestException(message: '', code: code);
          expect(
            exception.isRetriable,
            isFalse,
            reason: 'Code $code should not be retriable',
          );
        }
      });

      test('should identify permission errors', () {
        final permissionError = const PostgrestException(
          message: '',
          code: '42501',
        );
        final otherError = const PostgrestException(message: '', code: '23505');

        expect(permissionError.isPermissionError, isTrue);
        expect(otherError.isPermissionError, isFalse);
      });

      test('should identify not found errors', () {
        final notFoundErrors = ['PGRST301', '42P01'];

        for (final code in notFoundErrors) {
          final exception = PostgrestException(message: '', code: code);
          expect(exception.isNotFoundError, isTrue);
        }

        final otherError = const PostgrestException(message: '', code: '23505');
        expect(otherError.isNotFoundError, isFalse);
      });
    });

    group('AuthException extensions', () {
      test('should return user-friendly messages for common auth errors', () {
        final testCases = [
          ('Invalid login credentials', 'Identifiants invalides'),
          ('Email not confirmed', 'Email non confirmé'),
          ('User already registered', 'Utilisateur déjà enregistré'),
          (
            'Password should be at least 6 characters',
            'Le mot de passe doit contenir au moins 6 caractères',
          ),
          ('Invalid email', 'Email invalide'),
          ('User not found', 'Utilisateur non trouvé'),
          (
            'Invalid refresh token',
            'Session expirée, veuillez vous reconnecter',
          ),
          ('Network request failed', 'Erreur de connexion réseau'),
        ];

        for (final (message, expectedUserMessage) in testCases) {
          final exception = AuthException(message);
          expect(exception.userMessage, equals(expectedUserMessage));
        }
      });

      test('should handle status code errors', () {
        final statusCodes = {
          '400': 'Requête invalide',
          '401': 'Non autorisé',
          '403': 'Accès refusé',
          '404': 'Ressource non trouvée',
          '429': 'Trop de tentatives, veuillez réessayer plus tard',
          '500': 'Erreur serveur, veuillez réessayer',
        };

        for (final entry in statusCodes.entries) {
          final exception = AuthException('Error', statusCode: entry.key);
          expect(exception.userMessage, equals(entry.value));
        }
      });

      test('should identify retriable auth errors', () {
        final retriableErrors = [
          const AuthException('', statusCode: '429'),
          const AuthException('', statusCode: '500'),
          const AuthException('Network request failed'),
        ];

        for (final error in retriableErrors) {
          expect(error.isRetriable, isTrue);
        }

        final nonRetriableError = const AuthException('', statusCode: '401');
        expect(nonRetriableError.isRetriable, isFalse);
      });

      test('should identify errors requiring reauth', () {
        final reauthErrors = [
          const AuthException('Invalid refresh token'),
          const AuthException('', statusCode: '401'),
        ];

        for (final error in reauthErrors) {
          expect(error.requiresReauth, isTrue);
        }

        final otherError = const AuthException('Network error');
        expect(otherError.requiresReauth, isFalse);
      });
    });

    group('StorageException extensions', () {
      test('should return user-friendly messages for storage errors', () {
        final testCases = [
          ('The resource already exists', 'Ce fichier existe déjà'),
          ('Invalid file size', 'Taille de fichier invalide'),
          ('Invalid mime type', 'Type de fichier non autorisé'),
          ('Object not found', 'Fichier non trouvé'),
          ('Bucket not found', 'Espace de stockage non trouvé'),
        ];

        for (final (message, expectedUserMessage) in testCases) {
          final exception = StorageException(message);
          expect(exception.userMessage, equals(expectedUserMessage));
        }
      });

      test('should handle storage status codes', () {
        final statusCodes = {
          '413': 'Fichier trop volumineux',
          '507': 'Espace de stockage insuffisant',
        };

        for (final entry in statusCodes.entries) {
          final exception = StorageException('Error', statusCode: entry.key);
          expect(exception.userMessage, equals(entry.value));
        }
      });
    });

    group('AppException', () {
      test('should create from PostgrestException', () {
        final postgrestException = const PostgrestException(
          message: 'Duplicate key',
          code: '23505',
        );

        final appException = AppException.fromPostgrest(postgrestException);

        expect(appException.message, equals('Cette donnée existe déjà'));
        expect(appException.code, equals('23505'));
        expect(appException.isRetriable, isFalse);
        expect(appException.originalException, equals(postgrestException));
      });

      test('should create from AuthException', () {
        final authException = const AuthException(
          'Some error',
          statusCode: '500',
        );

        final appException = AppException.fromAuth(authException);

        expect(
          appException.message,
          equals('Erreur serveur, veuillez réessayer'),
        );
        expect(appException.code, equals('500'));
        expect(appException.isRetriable, isTrue);
        expect(appException.originalException, equals(authException));
      });

      test('should create from StorageException', () {
        final storageException = const StorageException(
          'Object not found',
          statusCode: '404',
        );

        final appException = AppException.fromStorage(storageException);

        expect(appException.message, equals('Fichier non trouvé'));
        expect(appException.code, equals('404'));
        expect(appException.isRetriable, isFalse);
        expect(appException.originalException, equals(storageException));
      });

      test('should have proper toString representation', () {
        final exception = const AppException(
          message: 'Test error',
          code: 'TEST_CODE',
        );

        expect(
          exception.toString(),
          equals('AppException: Test error (code: TEST_CODE)'),
        );
      });
    });
  });
}
