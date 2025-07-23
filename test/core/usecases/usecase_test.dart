import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/core/errors/failures.dart';

// Test implementations
class TestUseCase extends UseCase<String, TestParams> {
  @override
  Future<Either<Failure, String>> call(TestParams params) async {
    if (params.shouldFail) {
      return const Left(Failure.unknown(message: 'Test failure'));
    }
    return Right('Result: ${params.value}');
  }
}

class TestUseCaseNoParams extends UseCaseNoParams<int> {
  final bool shouldFail;
  
  TestUseCaseNoParams({this.shouldFail = false});
  
  @override
  Future<Either<Failure, int>> call() async {
    if (shouldFail) {
      return const Left(Failure.unknown(message: 'No params failure'));
    }
    return const Right(42);
  }
}

class TestParams {
  final String value;
  final bool shouldFail;
  
  TestParams({required this.value, this.shouldFail = false});
}

void main() {
  group('UseCase', () {
    late TestUseCase useCase;
    
    setUp(() {
      useCase = TestUseCase();
    });
    
    test('should return success result when params are valid', () async {
      // Arrange
      final params = TestParams(value: 'test');
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (value) => expect(value, equals('Result: test')),
      );
    });
    
    test('should return failure when params indicate failure', () async {
      // Arrange
      final params = TestParams(value: 'test', shouldFail: true);
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (value) => fail('Should not succeed'),
      );
    });
  });
  
  group('UseCaseNoParams', () {
    test('should return success result without params', () async {
      // Arrange
      final useCase = TestUseCaseNoParams();
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (value) => expect(value, equals(42)),
      );
    });
    
    test('should return failure when configured to fail', () async {
      // Arrange
      final useCase = TestUseCaseNoParams(shouldFail: true);
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('No params failure')),
        (value) => fail('Should not succeed'),
      );
    });
  });
  
  group('NoParams', () {
    test('should be constructable', () {
      // Act
      const noParams = NoParams();
      
      // Assert
      expect(noParams, isA<NoParams>());
    });
  });
}