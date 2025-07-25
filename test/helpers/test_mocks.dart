import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/create_room_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/join_room_use_case.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';

// Mock classes for testing
class MockGoRouter extends Mock implements GoRouter {
  @override
  void go(String location, {Object? extra}) {
    // Do nothing - just for testing
  }
}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockRoomRepository extends Mock implements RoomRepository {}

class MockCreateRoomUseCase extends Mock implements CreateRoomUseCase {}

class MockJoinRoomUseCase extends Mock implements JoinRoomUseCase {}

// Helper function to create test providers
List<Override> createTestProviders({
  CreateRoomUseCase? createRoomUseCase,
  JoinRoomUseCase? joinRoomUseCase,
  String? currentUserId,
  String? currentRoomId,
}) {
  return [
    if (createRoomUseCase != null)
      createRoomUseCaseProvider.overrideWithValue(createRoomUseCase),
    if (joinRoomUseCase != null)
      joinRoomUseCaseProvider.overrideWithValue(joinRoomUseCase),
    if (currentUserId != null)
      currentUserIdProvider.overrideWithValue(currentUserId),
    if (currentRoomId != null)
      currentRoomIdProvider.overrideWithValue(currentRoomId),
  ];
}

// Fake implementations for test data
class FakeRoom extends Fake implements Room {
  @override
  final String id = 'test-room-id';

  @override
  final String hostId = 'test-host-id';

  @override
  final int maxPlayers = 4;

  @override
  final List<String> playerIds = ['test-host-id'];

  @override
  final RoomStatus status = RoomStatus.waiting;

  @override
  final String? gameStateJson;

  @override
  final DateTime createdAt = DateTime.now();

  @override
  final DateTime updatedAt = DateTime.now();

  FakeRoom({this.gameStateJson});
}

// Setup functions for common test scenarios
void setupCreateRoomSuccess(MockCreateRoomUseCase mockUseCase, {Room? room}) {
  when(
    () => mockUseCase.call(
      creatorId: any(named: 'creatorId'),
      maxPlayers: any(named: 'maxPlayers'),
    ),
  ).thenAnswer((_) async => room ?? FakeRoom());
}

void setupCreateRoomFailure(
  MockCreateRoomUseCase mockUseCase, {
  Exception? exception,
}) {
  when(
    () => mockUseCase.call(
      creatorId: any(named: 'creatorId'),
      maxPlayers: any(named: 'maxPlayers'),
    ),
  ).thenThrow(exception ?? Exception('Failed to create room'));
}

void setupJoinRoomSuccess(MockJoinRoomUseCase mockUseCase, {Room? room}) {
  when(
    () => mockUseCase.call(
      roomId: any(named: 'roomId'),
      playerId: any(named: 'playerId'),
    ),
  ).thenAnswer((_) async => room ?? FakeRoom());
}

void setupJoinRoomFailure(
  MockJoinRoomUseCase mockUseCase, {
  Exception? exception,
}) {
  when(
    () => mockUseCase.call(
      roomId: any(named: 'roomId'),
      playerId: any(named: 'playerId'),
    ),
  ).thenThrow(exception ?? Exception('Failed to join room'));
}
