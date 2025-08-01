import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mobile_simulator_wrapper.dart';

/// Widget responsive qui adapte l'affichage selon la plateforme et la taille d'écran
/// - Web sur grand écran: affiche le simulator complet
/// - Web sur écran moyen: conteneur limité
/// - Mobile natif: affichage direct
class ResponsiveSimulator extends StatelessWidget {
  final Widget child;
  final bool enableSimulator;

  const ResponsiveSimulator({
    super.key,
    required this.child,
    this.enableSimulator = true,
  });

  @override
  Widget build(BuildContext context) {
    // Sur mobile natif, pas de simulation
    if (!kIsWeb) {
      return child;
    }

    // Si la simulation est désactivée
    if (!enableSimulator) {
      return child;
    }

    final screenWidth = MediaQuery.of(context).size.width;

    // Pour écrans ultra-wide (5120x1440 et plus)
    if (screenWidth > 3840) {
      return MobileSimulatorWrapper(
        showControls: false, // Peut être activé pour debug
        child: child,
      );
    }
    // Pour écrans desktop normaux (1920x1080 et plus)
    else if (screenWidth > 1920) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 580,
            maxHeight: 1300,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade800,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRect(child: child),
        ),
      );
    }
    // Pour tablettes et petits écrans
    else {
      return child;
    }
  }
}

/// Helper pour déterminer le type d'appareil
class DeviceType {
  static bool isMobileWeb(BuildContext context) {
    if (!kIsWeb) return false;
    final width = MediaQuery.of(context).size.width;
    return width < 768;
  }

  static bool isTabletWeb(BuildContext context) {
    if (!kIsWeb) return false;
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1920;
  }

  static bool isDesktopWeb(BuildContext context) {
    if (!kIsWeb) return false;
    final width = MediaQuery.of(context).size.width;
    return width >= 1920;
  }

  static bool isUltraWideWeb(BuildContext context) {
    if (!kIsWeb) return false;
    final width = MediaQuery.of(context).size.width;
    return width >= 3840;
  }
}