import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/create_room_screen.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/join_room_screen.dart';
import 'package:ojyx/features/multiplayer/presentation/screens/room_lobby_screen.dart';

void main() {
  group('Multiplayer Screens', () {
    test('CreateRoomScreen should exist', () {
      expect(CreateRoomScreen, isNotNull);
    });

    test('JoinRoomScreen should exist', () {
      expect(JoinRoomScreen, isNotNull);
    });

    test('RoomLobbyScreen should exist', () {
      expect(RoomLobbyScreen, isNotNull);
    });
  });
}