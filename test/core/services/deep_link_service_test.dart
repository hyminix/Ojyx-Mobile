import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/services/deep_link_service.dart';

void main() {
  group('DeepLinkService', () {
    group('generateRoomLink', () {
      test('should generate web link by default', () {
        const roomId = 'ABC123';
        final link = DeepLinkService.generateRoomLink(roomId);

        expect(link, equals('https://game.ojyx.com/room/ABC123'));
      });

      test('should generate app scheme link when requested', () {
        const roomId = 'ABC123';
        final link = DeepLinkService.generateRoomLink(
          roomId,
          useWebLink: false,
        );

        expect(link, equals('ojyx://game.ojyx.com/room/ABC123'));
      });

      test('should encode special characters in room ID', () {
        const roomId = 'room with spaces';
        final link = DeepLinkService.generateRoomLink(roomId);

        expect(link, equals('https://game.ojyx.com/room/room%20with%20spaces'));
      });
    });

    group('generateJoinLink', () {
      test('should generate web join link', () {
        final link = DeepLinkService.generateJoinLink();
        expect(link, equals('https://game.ojyx.com/join-room'));
      });

      test('should generate app scheme join link', () {
        final link = DeepLinkService.generateJoinLink(useWebLink: false);
        expect(link, equals('ojyx://game.ojyx.com/join-room'));
      });
    });

    group('generateCustomLink', () {
      test('should generate link with query parameters', () {
        final link = DeepLinkService.generateCustomLink(
          '/',
          queryParams: {'promo': 'WELCOME20', 'ref': 'email'},
        );

        expect(link, contains('https://game.ojyx.com/?'));
        expect(link, contains('promo=WELCOME20'));
        expect(link, contains('ref=email'));
      });

      test('should generate link without query parameters', () {
        final link = DeepLinkService.generateCustomLink('/about');
        expect(link, equals('https://game.ojyx.com/about'));
      });
    });

    group('parseDeepLink', () {
      test('should parse valid app scheme link', () {
        const url = 'ojyx://game.ojyx.com/room/ABC123';
        final info = DeepLinkService.parseDeepLink(url);

        expect(info, isNotNull);
        expect(info!.path, equals('/room/ABC123'));
        expect(info.roomId, equals('ABC123'));
        expect(info.isRoomLink, isTrue);
      });

      test('should parse valid web link', () {
        const url = 'https://game.ojyx.com/room/XYZ789?ref=share';
        final info = DeepLinkService.parseDeepLink(url);

        expect(info, isNotNull);
        expect(info!.roomId, equals('XYZ789'));
        expect(info.queryParams['ref'], equals('share'));
      });

      test('should parse join room link', () {
        const url = 'https://game.ojyx.com/join-room';
        final info = DeepLinkService.parseDeepLink(url);

        expect(info, isNotNull);
        expect(info!.isJoinRoomLink, isTrue);
        expect(info.isRoomLink, isFalse);
      });

      test('should return null for invalid links', () {
        expect(DeepLinkService.parseDeepLink('https://google.com'), isNull);
        expect(DeepLinkService.parseDeepLink('random://link'), isNull);
        expect(DeepLinkService.parseDeepLink('not a url'), isNull);
      });

      test('should handle encoded room IDs', () {
        const url = 'https://game.ojyx.com/room/room%20with%20spaces';
        final info = DeepLinkService.parseDeepLink(url);

        expect(info, isNotNull);
        // URI automatically decodes the path segments
        expect(info!.roomId, equals('room with spaces'));
      });
    });

    group('generateShareMessage', () {
      test('should generate share message with room name', () {
        final message = DeepLinkService.generateShareMessage(
          'ABC123',
          roomName: 'Partie de Bob',
        );

        expect(message, contains('Rejoins ma partie Partie de Bob!'));
        expect(message, contains('https://game.ojyx.com/room/ABC123'));
        expect(message, contains('code: ABC123'));
      });

      test('should generate share message without room name', () {
        final message = DeepLinkService.generateShareMessage('XYZ789');

        expect(message, contains('Rejoins ma partie Ojyx!'));
        expect(message, contains('https://game.ojyx.com/room/XYZ789'));
      });
    });

    group('generateQRCodeData', () {
      test('should use app scheme for QR codes', () {
        final data = DeepLinkService.generateQRCodeData('ROOM123');
        expect(data, equals('ojyx://game.ojyx.com/room/ROOM123'));
      });
    });

    group('DeepLinkInfo', () {
      test('should extract room ID from valid path', () {
        const info = DeepLinkInfo(
          path: '/room/TEST123',
          queryParams: {},
          pathSegments: ['room', 'TEST123'],
        );

        expect(info.roomId, equals('TEST123'));
        expect(info.isRoomLink, isTrue);
      });

      test('should return null for non-room paths', () {
        const info = DeepLinkInfo(
          path: '/join-room',
          queryParams: {},
          pathSegments: ['join-room'],
        );

        expect(info.roomId, isNull);
        expect(info.isRoomLink, isFalse);
      });
    });
  });
}
