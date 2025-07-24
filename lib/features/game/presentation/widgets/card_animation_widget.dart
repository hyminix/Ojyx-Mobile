import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../domain/entities/card.dart' as game;

/// Widget that wraps a card to provide various animation effects
class CardAnimationWidget extends StatefulWidget {
  final game.Card card;
  final Widget child;
  final Duration animationDuration;
  final VoidCallback? onAnimationComplete;

  const CardAnimationWidget({
    super.key,
    required this.card,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 500),
    this.onAnimationComplete,
  });

  @override
  State<CardAnimationWidget> createState() => CardAnimationWidgetState();
}

class CardAnimationWidgetState extends State<CardAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _positionController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _positionAnimation;

  Offset? _targetPosition;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _positionController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _positionAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _positionController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _resetAnimations() {
    if (_isAnimating) {
      _fadeController.stop();
      _scaleController.stop();
      _rotationController.stop();
      _positionController.stop();
    }
    _isAnimating = false;
  }

  Future<void> _runAnimation(
    AnimationController controller,
    Animation<dynamic> animation,
    dynamic begin,
    dynamic end, {
    bool reverse = false,
  }) async {
    _resetAnimations();
    _isAnimating = true;

    animation = Tween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    await controller.forward();
    if (reverse) {
      await controller.reverse();
    }

    controller.reset();
    _isAnimating = false;
    widget.onAnimationComplete?.call();
  }

  /// Animate teleport effect (fade out and in)
  Future<void> animateTeleport() async {
    _resetAnimations();
    _isAnimating = true;

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    await _fadeController.forward();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.reset();
    await _fadeController.forward();

    _fadeController.reset();
    _isAnimating = false;
    widget.onAnimationComplete?.call();
  }

  /// Animate swap effect with another card position
  Future<void> animateSwapWith(Offset targetPosition) async {
    _resetAnimations();
    _isAnimating = true;
    _targetPosition = targetPosition;

    // Get current position
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final currentPosition = renderBox.localToGlobal(Offset.zero);
    final delta = targetPosition - currentPosition;

    _positionAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: Offset(delta.dx, delta.dy),
        ).animate(
          CurvedAnimation(parent: _positionController, curve: Curves.easeInOut),
        );

    await _positionController.forward();
    _positionController.reverse();

    _isAnimating = false;
    _targetPosition = null;
    widget.onAnimationComplete?.call();
  }

  /// Animate card reveal (flip animation)
  Future<void> animateReveal() async {
    _resetAnimations();
    _isAnimating = true;

    _rotationAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    await _rotationController.forward();
    _rotationController.reset();
    _isAnimating = false;
    widget.onAnimationComplete?.call();
  }

  /// Animate discard effect (scale down and fade)
  Future<void> animateDiscard() async {
    _resetAnimations();
    _isAnimating = true;

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeIn));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    await Future.wait([_scaleController.forward(), _fadeController.forward()]);

    _scaleController.reset();
    _fadeController.reset();
    _isAnimating = false;
    widget.onAnimationComplete?.call();
  }

  /// Animate bomb effect (explode outward)
  Future<void> animateBomb() async {
    _resetAnimations();
    _isAnimating = true;

    // Scale up quickly then down
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    await _scaleController.forward(from: 0.0);

    _scaleAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    await Future.wait([
      _scaleController.forward(from: 0.3),
      _fadeController.forward(from: 0.3),
    ]);

    _scaleController.reset();
    _fadeController.reset();
    _isAnimating = false;
    widget.onAnimationComplete?.call();
  }

  /// Animate peek effect (partial flip)
  Future<void> animatePeek() async {
    _resetAnimations();
    _isAnimating = true;

    // Rotate partially to show a glimpse
    _rotationAnimation =
        Tween<double>(
          begin: 0.0,
          end: math.pi / 4, // 45 degrees
        ).animate(
          CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
        );

    await _rotationController.forward();
    // Hold position briefly
    await _rotationController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 300),
    );
    await _rotationController.reverse();

    _isAnimating = false;
    widget.onAnimationComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _fadeController,
        _scaleController,
        _rotationController,
        _positionController,
      ]),
      builder: (context, child) {
        Widget result = widget.child;

        // Apply position animation
        if (_positionAnimation.value != Offset.zero) {
          result = Transform.translate(
            offset: _positionAnimation.value,
            child: result,
          );
        }

        // Apply rotation animation
        if (_rotationAnimation.value != 0.0) {
          result = Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(_rotationAnimation.value),
            child: result,
          );
        }

        // Apply scale animation
        if (_scaleAnimation.value != 1.0) {
          result = Transform.scale(scale: _scaleAnimation.value, child: result);
        }

        // Apply fade animation
        if (_fadeAnimation.value != 1.0) {
          result = FadeTransition(opacity: _fadeAnimation, child: result);
        }

        return result;
      },
    );
  }
}
