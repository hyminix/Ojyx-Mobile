import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/play_direction.dart';

class DirectionChangeAnimation extends StatefulWidget {
  final PlayDirection direction;
  final VoidCallback onAnimationComplete;

  const DirectionChangeAnimation({
    super.key,
    required this.direction,
    required this.onAnimationComplete,
  });

  @override
  State<DirectionChangeAnimation> createState() => _DirectionChangeAnimationState();
}

class _DirectionChangeAnimationState extends State<DirectionChangeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  Timer? _scaleTimer;
  Timer? _rotationTimer;
  Timer? _fadeOutTimer;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: widget.direction == PlayDirection.forward ? 2 : -2,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimation();
  }

  void _startAnimation() {
    // Fade in immediately
    _fadeController.forward();
    
    // Start scale and rotation after short delay
    _scaleTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        _scaleController.forward();
        _rotationController.forward();
      }
    });
    
    // Start fade out after animation peak
    _fadeOutTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) {
        _fadeController.reverse().then((_) {
          if (mounted) {
            widget.onAnimationComplete();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scaleTimer?.cancel();
    _rotationTimer?.cancel();
    _fadeOutTimer?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 3.14159,
                child: child,
              );
            },
            child: SizedBox(
              width: 200,
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.direction == PlayDirection.forward
                          ? Icons.u_turn_left
                          : Icons.u_turn_right,
                      size: 80,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Changement de direction !',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}