import 'dart:io';
import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/providers/supabase_provider_v2.dart';
import 'package:ojyx/core/errors/supabase_error_handling.dart';
import 'package:ojyx/core/utils/resilient_supabase_service.dart';

part 'avatar_storage_service.g.dart';

/// Service moderne pour gérer le stockage d'avatars avec Supabase Storage v2
@riverpod
class AvatarStorageService extends _$AvatarStorageService {
  static const String _bucketName = 'avatars';
  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  @override
  FutureOr<void> build() {
    // Service initialization if needed
  }

  /// Upload un avatar avec gestion d'erreurs et options avancées
  Future<String> uploadAvatar(File file) async {
    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw const AppException(
        message: 'Vous devez être connecté pour uploader un avatar',
        code: 'NOT_AUTHENTICATED',
      );
    }

    // Valider le fichier
    await _validateFile(file);

    try {
      // Lire le fichier
      final bytes = await file.readAsBytes();
      final fileExt = file.path.split('.').last.toLowerCase();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = '$userId/$fileName';

      // Upload avec retry et options
      await ResilientSupabaseService.resilientExecute(
        () => client.storage
            .from(_bucketName)
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(
                contentType: _getContentType(fileExt),
                cacheControl: '3600', // Cache 1 heure
                upsert: true, // Remplace si existe
              ),
            ),
        maxAttempts: 3,
        timeout: const Duration(seconds: 60), // Timeout plus long pour upload
      );

      // Retourner l'URL publique
      return client.storage.from(_bucketName).getPublicUrl(filePath);
    } on StorageException catch (e) {
      throw AppException.fromStorage(e);
    } catch (e) {
      throw AppException(
        message: 'Erreur lors de l\'upload de l\'avatar',
        originalException: e,
      );
    }
  }

  /// Upload un avatar depuis des bytes (ex: depuis la caméra)
  Future<String> uploadAvatarBytes(
    Uint8List bytes, {
    required String extension,
  }) async {
    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw const AppException(
        message: 'Vous devez être connecté pour uploader un avatar',
        code: 'NOT_AUTHENTICATED',
      );
    }

    // Valider l'extension
    if (!_allowedExtensions.contains(extension.toLowerCase())) {
      throw AppException(
        message:
            'Format de fichier non supporté. Utilisez: ${_allowedExtensions.join(', ')}',
        code: 'INVALID_FILE_TYPE',
      );
    }

    // Valider la taille
    if (bytes.length > _maxFileSizeBytes) {
      throw const AppException(
        message: 'Le fichier est trop volumineux (max 5MB)',
        code: 'FILE_TOO_LARGE',
      );
    }

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final filePath = '$userId/$fileName';

      await ResilientSupabaseService.resilientExecute(
        () => client.storage
            .from(_bucketName)
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(
                contentType: _getContentType(extension),
                cacheControl: '3600',
                upsert: true,
              ),
            ),
      );

      return client.storage.from(_bucketName).getPublicUrl(filePath);
    } on StorageException catch (e) {
      throw AppException.fromStorage(e);
    }
  }

  /// Supprime l'avatar actuel de l'utilisateur
  Future<void> deleteCurrentAvatar() async {
    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw const AppException(
        message: 'Vous devez être connecté',
        code: 'NOT_AUTHENTICATED',
      );
    }

    try {
      // Lister tous les fichiers de l'utilisateur
      final files = await client.storage.from(_bucketName).list(path: userId);

      if (files.isEmpty) return;

      // Supprimer tous les avatars de l'utilisateur
      final filePaths = files.map((file) => '$userId/${file.name}').toList();

      await ResilientSupabaseService.withRetry(
        () => client.storage.from(_bucketName).remove(filePaths),
      );
    } on StorageException catch (e) {
      throw AppException.fromStorage(e);
    }
  }

  /// Récupère l'URL de l'avatar d'un utilisateur
  Future<String?> getAvatarUrl(String userId) async {
    final client = ref.read(supabaseClientProvider);

    try {
      // Lister les fichiers du user
      final files = await client.storage.from(_bucketName).list(path: userId);

      if (files.isEmpty) return null;

      // Prendre le plus récent
      files.sort((a, b) {
        final aUpdated = a.updatedAt;
        final bUpdated = b.updatedAt;
        if (aUpdated == null || bUpdated == null) return 0;
        return bUpdated.compareTo(aUpdated);
      });
      final latestFile = files.first;

      return client.storage
          .from(_bucketName)
          .getPublicUrl('$userId/${latestFile.name}');
    } on StorageException catch (e) {
      // Si pas d'avatar, retourner null plutôt qu'une erreur
      if (e.statusCode == '404' || e.message.contains('not found')) {
        return null;
      }
      throw AppException.fromStorage(e);
    }
  }

  /// Valide un fichier avant upload
  Future<void> _validateFile(File file) async {
    // Vérifier l'existence
    if (!await file.exists()) {
      throw const AppException(
        message: 'Le fichier n\'existe pas',
        code: 'FILE_NOT_FOUND',
      );
    }

    // Vérifier la taille
    final fileSize = await file.length();
    if (fileSize > _maxFileSizeBytes) {
      throw const AppException(
        message: 'Le fichier est trop volumineux (max 5MB)',
        code: 'FILE_TOO_LARGE',
      );
    }

    // Vérifier l'extension
    final fileExt = file.path.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(fileExt)) {
      throw AppException(
        message:
            'Format de fichier non supporté. Utilisez: ${_allowedExtensions.join(', ')}',
        code: 'INVALID_FILE_TYPE',
      );
    }
  }

  /// Retourne le content type basé sur l'extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  /// Génère une URL d'avatar avec transformation (resize, etc.)
  String transformAvatarUrl(
    String url, {
    int? width,
    int? height,
    int quality = 80,
  }) {
    // Supabase Storage supporte les transformations d'images
    final params = <String, String>{};

    if (width != null) params['width'] = width.toString();
    if (height != null) params['height'] = height.toString();
    params['quality'] = quality.toString();

    if (params.isEmpty) return url;

    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    return '$url?$queryString';
  }
}
