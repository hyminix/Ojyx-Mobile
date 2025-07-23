import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/utils/extensions.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('CardValueExtensions', () {
    group('cardColor', () {
      test('should return darkBlue for negative values', () {
        expect((-2).cardColor, equals(CardValueColor.darkBlue));
        expect((-1).cardColor, equals(CardValueColor.darkBlue));
      });

      test('should return lightBlue for zero', () {
        expect(0.cardColor, equals(CardValueColor.lightBlue));
      });

      test('should return green for values 1-4', () {
        expect(1.cardColor, equals(CardValueColor.green));
        expect(2.cardColor, equals(CardValueColor.green));
        expect(3.cardColor, equals(CardValueColor.green));
        expect(4.cardColor, equals(CardValueColor.green));
      });

      test('should return yellow for values 5-8', () {
        expect(5.cardColor, equals(CardValueColor.yellow));
        expect(6.cardColor, equals(CardValueColor.yellow));
        expect(7.cardColor, equals(CardValueColor.yellow));
        expect(8.cardColor, equals(CardValueColor.yellow));
      });

      test('should return red for values 9 and above', () {
        expect(9.cardColor, equals(CardValueColor.red));
        expect(10.cardColor, equals(CardValueColor.red));
        expect(11.cardColor, equals(CardValueColor.red));
        expect(12.cardColor, equals(CardValueColor.red));
      });
    });

    group('displayColor', () {
      test('should return correct colors for each category', () {
        expect((-2).displayColor, equals(const Color(0xFF1565C0))); // Dark blue
        expect(0.displayColor, equals(const Color(0xFF42A5F5))); // Light blue
        expect(2.displayColor, equals(const Color(0xFF66BB6A))); // Green
        expect(6.displayColor, equals(const Color(0xFFFFCA28))); // Yellow
        expect(10.displayColor, equals(const Color(0xFFEF5350))); // Red
      });

      test('should cover all card value ranges', () {
        // Test edge cases
        expect(kMinCardValue.displayColor, isA<Color>());
        expect(kMaxCardValue.displayColor, isA<Color>());
        
        // Test all values have a color
        for (int value = kMinCardValue; value <= kMaxCardValue; value++) {
          expect(value.displayColor, isA<Color>());
        }
      });
    });
  });

  group('ListExtensions', () {
    group('shuffled', () {
      test('should return a new shuffled list', () {
        // Arrange
        final original = [1, 2, 3, 4, 5];
        
        // Act
        final shuffled = original.shuffled();
        
        // Assert
        expect(shuffled.length, equals(original.length));
        expect(shuffled, containsAll(original));
        expect(identical(shuffled, original), isFalse); // Different instance
      });

      test('should not modify original list', () {
        // Arrange
        final original = [1, 2, 3, 4, 5];
        final copy = List<int>.from(original);
        
        // Act
        original.shuffled();
        
        // Assert
        expect(original, equals(copy));
      });

      test('should handle empty list', () {
        // Arrange
        final empty = <int>[];
        
        // Act
        final shuffled = empty.shuffled();
        
        // Assert
        expect(shuffled, isEmpty);
      });
    });

    group('chunked', () {
      test('should split list into chunks of specified size', () {
        // Arrange
        final list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        
        // Act
        final chunks = list.chunked(3);
        
        // Assert
        expect(chunks.length, equals(3));
        expect(chunks[0], equals([1, 2, 3]));
        expect(chunks[1], equals([4, 5, 6]));
        expect(chunks[2], equals([7, 8, 9]));
      });

      test('should handle incomplete last chunk', () {
        // Arrange
        final list = [1, 2, 3, 4, 5];
        
        // Act
        final chunks = list.chunked(2);
        
        // Assert
        expect(chunks.length, equals(3));
        expect(chunks[0], equals([1, 2]));
        expect(chunks[1], equals([3, 4]));
        expect(chunks[2], equals([5]));
      });

      test('should handle chunk size larger than list', () {
        // Arrange
        final list = [1, 2, 3];
        
        // Act
        final chunks = list.chunked(5);
        
        // Assert
        expect(chunks.length, equals(1));
        expect(chunks[0], equals([1, 2, 3]));
      });

      test('should handle empty list', () {
        // Arrange
        final empty = <int>[];
        
        // Act
        final chunks = empty.chunked(3);
        
        // Assert
        expect(chunks, isEmpty);
      });

      test('should handle chunk size of 1', () {
        // Arrange
        final list = [1, 2, 3];
        
        // Act
        final chunks = list.chunked(1);
        
        // Assert
        expect(chunks.length, equals(3));
        expect(chunks[0], equals([1]));
        expect(chunks[1], equals([2]));
        expect(chunks[2], equals([3]));
      });
    });
  });
}