import 'package:flutter/material.dart';

/// Service for handling deep links and generating share URLs
class DeepLinkService {
  DeepLinkService._();

  /// Base URL for web links
  static const String _webBaseUrl = 'https://game.ojyx.com';

  /// App scheme for deep links
  static const String _appScheme = 'ojyx://game.ojyx.com';

  /// Generate a shareable link to join a room
  static String generateRoomLink(String roomId, {bool useWebLink = true}) {
    final escapedRoomId = Uri.encodeComponent(roomId);
    return useWebLink
        ? '$_webBaseUrl/room/$escapedRoomId'
        : '$_appScheme/room/$escapedRoomId';
  }

  /// Generate a link to the join room screen
  static String generateJoinLink({bool useWebLink = true}) {
    return useWebLink ? '$_webBaseUrl/join-room' : '$_appScheme/join-room';
  }

  /// Generate a link with custom parameters
  static String generateCustomLink(
    String path, {
    Map<String, String>? queryParams,
    bool useWebLink = true,
  }) {
    final baseUrl = useWebLink ? _webBaseUrl : _appScheme;
    final uri = Uri.parse('$baseUrl$path');

    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }

    return uri.toString();
  }

  /// Parse deep link and extract route information
  static DeepLinkInfo? parseDeepLink(String url) {
    try {
      final uri = Uri.parse(url);

      // Check if it's our deep link
      final isAppLink = uri.scheme == 'ojyx' && uri.host == 'game.ojyx.com';
      final isWebLink = uri.scheme == 'https' && uri.host == 'game.ojyx.com';

      if (!isAppLink && !isWebLink) {
        return null;
      }

      return DeepLinkInfo(
        path: uri.path,
        queryParams: uri.queryParameters,
        pathSegments: uri.pathSegments,
      );
    } catch (e) {
      debugPrint('Error parsing deep link: $e');
      return null;
    }
  }

  /// Generate share message for a room
  static String generateShareMessage(String roomId, {String? roomName}) {
    final link = generateRoomLink(roomId);
    final name = roomName ?? 'Ojyx';
    return 'Rejoins ma partie $name!\n\n'
        'Clique sur ce lien pour me rejoindre:\n'
        '$link\n\n'
        'Ou entre le code: $roomId';
  }

  /// Generate QR code data for a room
  static String generateQRCodeData(String roomId) {
    // Use app scheme for QR codes for faster opening
    return generateRoomLink(roomId, useWebLink: false);
  }
}

/// Information extracted from a deep link
class DeepLinkInfo {
  final String path;
  final Map<String, String> queryParams;
  final List<String> pathSegments;

  const DeepLinkInfo({
    required this.path,
    required this.queryParams,
    required this.pathSegments,
  });

  /// Get room ID from path if present
  String? get roomId {
    if (pathSegments.length >= 2 && pathSegments[0] == 'room') {
      return pathSegments[1];
    }
    return null;
  }

  /// Check if this is a room link
  bool get isRoomLink => roomId != null;

  /// Check if this is a join room link
  bool get isJoinRoomLink => path == '/join-room';
}
