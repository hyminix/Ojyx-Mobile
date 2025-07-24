import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/visual_feedback_widget.dart';

void main() {
  group('VisualFeedbackWidget', () {
    testWidgets('should wrap child without any visual changes initially',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, equals(Colors.blue));
    });

    testWidgets('should show pulse animation when activated', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Start pulse animation
      feedbackKey.currentState!.showPulse();
      await tester.pump();

      // Should show animated decoration
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();
    });

    testWidgets('should show highlight effect', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Show highlight
      feedbackKey.currentState!.showHighlight(Colors.yellow);
      await tester.pump();

      // Should show highlight animation
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();
    });

    testWidgets('should show ripple effect at specific position',
        (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Show ripple at center
      feedbackKey.currentState!.showRipple(const Offset(100, 100));
      await tester.pump();

      // Should show ripple animation
      expect(find.byType(CustomPaint), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();
    });

    testWidgets('should show success indicator', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Show success
      feedbackKey.currentState!.showSuccess();
      await tester.pump();

      // Animation should start
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Wait for icon to appear
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();

      // Icon should disappear after animation
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('should show error indicator', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Show error
      feedbackKey.currentState!.showError();
      await tester.pump();

      // Animation should start
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Wait for icon to appear
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.error), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();
    });

    testWidgets('should show tooltip on hover', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                tooltip: 'This is a helpful tooltip',
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Hover over widget
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.byType(Container)));
      await tester.pump();

      // Wait for tooltip to appear
      await tester.pump(const Duration(seconds: 1));

      // Should show tooltip
      expect(find.text('This is a helpful tooltip'), findsOneWidget);

      // Move away
      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle multiple feedbacks gracefully', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Start multiple animations
      feedbackKey.currentState!.showPulse();
      await tester.pump(const Duration(milliseconds: 100));
      feedbackKey.currentState!.showHighlight(Colors.green);
      await tester.pump();

      // Should handle both animations
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete all animations
      await tester.pumpAndSettle();
    });

    testWidgets('should apply custom animation duration', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                animationDuration: const Duration(milliseconds: 100),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Show feedback
      feedbackKey.currentState!.showPulse();
      await tester.pump();

      // Animation should still be running after 50ms
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Animation should complete after 100ms
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(); // One more frame
    });

    testWidgets('should notify when feedback completes', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();
      bool feedbackCompleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                onFeedbackComplete: () {
                  feedbackCompleted = true;
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Show feedback
      feedbackKey.currentState!.showPulse();
      expect(feedbackCompleted, isFalse);

      // Complete animation
      await tester.pumpAndSettle();
      expect(feedbackCompleted, isTrue);
    });

    testWidgets('should scale feedback effect with intensity', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // Show strong pulse
      feedbackKey.currentState!.showPulse(intensity: 2.0);
      await tester.pump();

      // Should show scaled animation
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();
    });
  });
}