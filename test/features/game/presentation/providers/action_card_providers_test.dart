import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_providers.dart';
import 'package:ojyx/features/game/domain/repositories/action_card_repository.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/game/presentation/providers/repository_providers.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';

class MockActionCardRepository extends Mock implements ActionCardRepository {}
class MockGameStateRepository extends Mock implements GameStateRepository {}
class MockUseActionCardUseCase extends Mock implements UseActionCardUseCase {}

class FakeUseActionCardParams extends Fake implements UseActionCardParams {}

void main() {
  late ProviderContainer container;
  late MockActionCardRepository mockRepository;
  late MockGameStateRepository mockGameStateRepository;
  late MockUseActionCardUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(FakeUseActionCardParams());
  });

  setUp(() {
    mockRepository = MockActionCardRepository();
    mockGameStateRepository = MockGameStateRepository();
    mockUseCase = MockUseActionCardUseCase();
    container = ProviderContainer(
      overrides: [
        actionCardRepositoryProvider.overrideWithValue(mockRepository),
        gameStateRepositoryProvider.overrideWithValue(mockGameStateRepository),
        useActionCardUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('actionCardRepositoryProvider', () {
    test('should provide action card repository', () {
      // Act
      final repository = container.read(actionCardRepositoryProvider);

      // Assert
      expect(repository, equals(mockRepository));
    });
  });

  group('useActionCardUseCaseProvider', () {
    test('should provide use action card use case', () {
      // Act
      final useCase = container.read(useActionCardUseCaseProvider);

      // Assert
      expect(useCase, equals(mockUseCase));
    });
  });

  group('actionCardNotifierProvider', () {
    test('should use action card successfully', () async {
      // Arrange
      const gameStateId = 'game123';
      const playerId = 'player1';
      const actionCardType = ActionCardType.skip;
      final expectedResult = <String, dynamic>{'success': true};

      when(() => mockUseCase(any())).thenAnswer(
        (_) async => Right(expectedResult),
      );

      final notifier = container.read(actionCardNotifierProvider.notifier);

      // Act
      final result = await notifier.useActionCard(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null,
      );

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) => expect(data, equals(expectedResult)),
      );
    });

    test('should handle failure when using action card', () async {
      // Arrange
      const gameStateId = 'game123';
      const playerId = 'player1';
      const actionCardType = ActionCardType.skip;
      final failure = Failure.server(message: 'Test error');

      when(() => mockUseCase(any())).thenAnswer(
        (_) async => Left(failure),
      );

      final notifier = container.read(actionCardNotifierProvider.notifier);

      // Act
      final result = await notifier.useActionCard(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null,
      );

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, equals(failure)),
        (data) => fail('Should not return success'),
      );
    });
  });
}