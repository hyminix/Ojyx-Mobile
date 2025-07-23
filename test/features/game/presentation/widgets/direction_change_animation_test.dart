import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/direction_change_animation.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';

void main() {
  group('DirectionChangeAnimation', () {
    testWidgets('should display rotation animation when direction changes',
        (tester) async {
      // Arrange
      var animationCompleted = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () => animationCompleted = true,
            ),
          ),
        ),
      );

      // Assert - Widget should be visible initially
      expect(find.byType(DirectionChangeAnimation), findsOneWidget);
      expect(find.byIcon(Icons.u_turn_left), findsOneWidget);

      // Wait for animation to complete with longer timeout
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Animation should have completed
      expect(animationCompleted, isTrue);
    });

    testWidgets('should show clockwise arrow for forward direction',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.u_turn_left), findsOneWidget);
      
      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should show counter-clockwise arrow for backward direction',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.backward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.u_turn_right), findsOneWidget);
      
      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should display text indicating direction change',
        (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Changement de direction !'), findsOneWidget);
      
      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should animate scale and rotation', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Initial pump
      await tester.pump();

      // Pump to trigger animation start
      await tester.pump(const Duration(milliseconds: 200));

      // Should have transform widgets during animation
      expect(find.byType(Transform), findsWidgets);
      expect(find.byType(ScaleTransition), findsWidgets);

      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should fade in and out', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Initial state - should have fade transition
      await tester.pump();
      expect(find.byType(FadeTransition), findsOneWidget);

      // Animation should be running
      await tester.pump(const Duration(milliseconds: 100));
      final fadeTransition = tester.widget<FadeTransition>(
        find.byType(FadeTransition).first,
      );
      expect(fadeTransition.opacity.value, greaterThanOrEqualTo(0));
      expect(fadeTransition.opacity.value, lessThanOrEqualTo(1));

      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should center the animation on screen', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Center), findsWidgets);
      expect(
        find.ancestor(
          of: find.byIcon(Icons.u_turn_left),
          matching: find.byType(Center),
        ),
        findsWidgets,
      );
      
      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should have appropriate styling', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Assert - Check container decoration
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DirectionChangeAnimation),
          matching: find.byType(Container),
        ).first,
      );
      
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
      expect(decoration.color, isNotNull);
      
      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should call onAnimationComplete only once', (tester) async {
      // Arrange
      var callCount = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () => callCount++,
            ),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert
      expect(callCount, equals(1));
      
      // Dispose properly
      await tester.pumpWidget(Container());
    });

    testWidgets('should be properly sized', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionChangeAnimation(
              direction: PlayDirection.forward,
              onAnimationComplete: () {},
            ),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(DirectionChangeAnimation),
          matching: find.byType(SizedBox),
        ).first,
      );
      
      expect(sizedBox.width, equals(200));
      expect(sizedBox.height, equals(200));
      
      // Dispose properly
      await tester.pumpWidget(Container());
    });
  });
}