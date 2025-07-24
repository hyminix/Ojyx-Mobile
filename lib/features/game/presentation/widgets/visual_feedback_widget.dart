import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget that provides various visual feedback effects
/// Can be wrapped around any widget to add interactive feedback
class VisualFeedbackWidget extends StatefulWidget {
  final Widget child;
  final String? tooltip;
  final Duration animationDuration;
  final VoidCallback? onFeedbackComplete;

  const VisualFeedbackWidget({
    super.key,
    required this.child,
    this.tooltip,
    this.animationDuration = const Duration(milliseconds: 500),
    this.onFeedbackComplete,
  });

  @override
  State<VisualFeedbackWidget> createState() => VisualFeedbackWidgetState();
}

class VisualFeedbackWidgetState extends State<VisualFeedbackWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _highlightController;
  late AnimationController _rippleController;
  late AnimationController _shakeController;
  late AnimationController _iconController;

  late Animation<double> _pulseAnimation;
  late Animation<Color?> _highlightAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _iconAnimation;

  Color _highlightColor = Colors.transparent;
  Offset? _ripplePosition;
  IconData? _feedbackIcon;
  Color? _feedbackIconColor;
  double _pulseIntensity = 1.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _highlightController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _highlightAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.transparent,
    ).animate(CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _highlightController.dispose();
    _rippleController.dispose();
    _shakeController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  /// Show a pulse effect
  void showPulse({double intensity = 1.0}) {
    _pulseIntensity = intensity;
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0 + (0.1 * intensity),
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.forward().then((_) {
      _pulseController.reverse().then((_) {
        widget.onFeedbackComplete?.call();
      });
    });
  }

  /// Show a highlight effect
  void showHighlight(Color color) {
    _highlightColor = color;
    _highlightAnimation = ColorTween(
      begin: Colors.transparent,
      end: color.withOpacity(0.3),
    ).animate(CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeInOut,
    ));

    _highlightController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _highlightController.reverse().then((_) {
          widget.onFeedbackComplete?.call();
        });
      });
    });
  }

  /// Show a ripple effect at a specific position
  void showRipple(Offset position) {
    _ripplePosition = position;
    _rippleController.forward().then((_) {
      _rippleController.reset();
      _ripplePosition = null;
      widget.onFeedbackComplete?.call();
    });
  }

  /// Show a success indicator
  void showSuccess() {
    _feedbackIcon = Icons.check_circle;
    _feedbackIconColor = Colors.green;
    _iconController.forward().then((_) async {
      // Use animateTo instead of Future.delayed for test compatibility
      await _iconController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 500),
      );
      await _iconController.reverse();
      _feedbackIcon = null;
      _feedbackIconColor = null;
      widget.onFeedbackComplete?.call();
    });
  }

  /// Show an error indicator with shake
  void showError() {
    _feedbackIcon = Icons.error;
    _feedbackIconColor = Colors.red;
    
    Future.wait([
      _iconController.forward(),
      _shakeController.forward().then((_) => _shakeController.reverse()),
    ]).then((_) async {
      // Use animateTo instead of Future.delayed for test compatibility
      await _iconController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 500),
      );
      await _iconController.reverse();
      _feedbackIcon = null;
      _feedbackIconColor = null;
      widget.onFeedbackComplete?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    // Wrap with tooltip if provided
    if (widget.tooltip != null) {
      result = Tooltip(
        message: widget.tooltip!,
        child: result,
      );
    }

    // Apply animations
    result = AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _highlightController,
        _rippleController,
        _shakeController,
        _iconController,
      ]),
      builder: (context, child) {
        Widget animatedChild = child!;

        // Apply pulse effect
        if (_pulseAnimation.value != 1.0) {
          animatedChild = Transform.scale(
            scale: _pulseAnimation.value,
            child: animatedChild,
          );
        }

        // Apply shake effect
        if (_shakeAnimation.value != 0.0) {
          animatedChild = Transform.translate(
            offset: Offset(_shakeAnimation.value * math.sin(_shakeController.value * math.pi * 4), 0),
            child: animatedChild,
          );
        }

        // Apply highlight effect
        if (_highlightAnimation.value != Colors.transparent) {
          animatedChild = Stack(
            children: [
              animatedChild,
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _highlightAnimation.value,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Apply ripple effect
        if (_ripplePosition != null && _rippleController.isAnimating) {
          animatedChild = Stack(
            children: [
              animatedChild,
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _RipplePainter(
                      position: _ripplePosition!,
                      radius: _rippleAnimation.value * 100,
                      opacity: 1.0 - _rippleAnimation.value,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Add feedback icon overlay
        if (_feedbackIcon != null && _iconAnimation.value > 0) {
          animatedChild = Stack(
            children: [
              animatedChild,
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Transform.scale(
                      scale: _iconAnimation.value,
                      child: Opacity(
                        opacity: _iconAnimation.value,
                        child: Icon(
                          _feedbackIcon,
                          size: 48,
                          color: _feedbackIconColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return animatedChild;
      },
      child: result,
    );

    return result;
  }
}

class _RipplePainter extends CustomPainter {
  final Offset position;
  final double radius;
  final double opacity;

  _RipplePainter({
    required this.position,
    required this.radius,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity * 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, paint);

    // Draw ripple border
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white.withOpacity(opacity);

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.radius != radius ||
        oldDelegate.opacity != opacity;
  }
}