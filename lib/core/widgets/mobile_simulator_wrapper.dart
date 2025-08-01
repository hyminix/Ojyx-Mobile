import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Wrapper pour simuler un Google Pixel 9 sur écran desktop
/// Dimensions: 580x1300 pixels pour tenir dans un écran 5120x1440
class MobileSimulatorWrapper extends StatelessWidget {
  final Widget child;
  final double deviceWidth = 580;
  final double deviceHeight = 1300;
  final bool showControls;
  final VoidCallback? onRotate;
  final VoidCallback? onHome;
  final VoidCallback? onBack;

  const MobileSimulatorWrapper({
    super.key,
    required this.child,
    this.showControls = false,
    this.onRotate,
    this.onHome,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculer le scale pour tenir dans l'écran
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // Calculer le ratio optimal en gardant les proportions
        // 90% pour laisser des marges visuelles
        final scaleX = screenWidth / deviceWidth;
        final scaleY = screenHeight / deviceHeight;
        final scale = math.min(scaleX * 0.9, scaleY * 0.9);

        final content = Container(
          color: const Color(0xFF1a1a1a), // Fond sombre style émulateur
          child: Center(
            child: Container(
              width: deviceWidth,
              height: deviceHeight,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: const Color(0xFF2a2a2a),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(37),
                child: Column(
                  children: [
                    const SimulatedStatusBar(),
                    Expanded(
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        if (showControls) {
          return Stack(
            children: [
              content,
              SimulatorControls(
                onRotate: onRotate,
                onHome: onHome,
                onBack: onBack,
              ),
            ],
          );
        }

        return content;
      },
    );
  }
}

/// Barre de status simulée pour renforcer l'effet mobile
class SimulatedStatusBar extends StatelessWidget {
  const SimulatedStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: const [
              Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 14, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

/// Contrôles optionnels pour la simulation
class SimulatorControls extends StatelessWidget {
  final VoidCallback? onRotate;
  final VoidCallback? onHome;
  final VoidCallback? onBack;

  const SimulatorControls({
    super.key,
    this.onRotate,
    this.onHome,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onRotate != null)
              IconButton(
                icon: const Icon(Icons.screen_rotation, color: Colors.white),
                onPressed: onRotate,
                tooltip: 'Rotation',
              ),
            if (onHome != null)
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: onHome,
                tooltip: 'Home',
              ),
            if (onBack != null)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack,
                tooltip: 'Back',
              ),
          ],
        ),
      ),
    );
  }
}