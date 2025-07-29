import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimistic_game_state_notifier.dart';

/// Widget qui affiche l'état de synchronisation global
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
    
    // Ne rien afficher si tout est synchronisé
    if (optimisticState.isSynchronized) {
      return const SizedBox.shrink();
    }
    
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getBackgroundColor(optimisticState),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(optimisticState),
            const SizedBox(width: 8),
            _buildText(optimisticState),
            if (optimisticState.pendingActionsCount > 0) ...[
              const SizedBox(width: 8),
              _buildPendingCount(optimisticState.pendingActionsCount),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(dynamic optimisticState) {
    if (optimisticState.hasError) {
      return Colors.red.shade100;
    } else if (optimisticState.isSyncing) {
      return Colors.blue.shade100;
    } else if (optimisticState.isOutOfSync) {
      return Colors.orange.shade100;
    }
    return Colors.grey.shade100;
  }

  Widget _buildIcon(dynamic optimisticState) {
    if (optimisticState.hasError) {
      return Icon(
        Icons.error_outline,
        color: Colors.red.shade700,
        size: 16,
      );
    } else if (optimisticState.isSyncing) {
      return _RotatingIcon(
        icon: Icons.sync,
        color: Colors.blue.shade700,
        size: 16,
      );
    } else if (optimisticState.isOutOfSync) {
      return Icon(
        Icons.cloud_off,
        color: Colors.orange.shade700,
        size: 16,
      );
    }
    return Icon(
      Icons.check_circle,
      color: Colors.green.shade700,
      size: 16,
    );
  }

  Widget _buildText(dynamic optimisticState) {
    String text;
    Color textColor;
    
    if (optimisticState.hasError) {
      text = 'Erreur de sync';
      textColor = Colors.red.shade700;
    } else if (optimisticState.isSyncing) {
      text = 'Synchronisation...';
      textColor = Colors.blue.shade700;
    } else if (optimisticState.isOutOfSync) {
      text = 'Hors ligne';
      textColor = Colors.orange.shade700;
    } else {
      text = 'Synchronisé';
      textColor = Colors.green.shade700;
    }
    
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPendingCount(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget pour une icône qui tourne
class _RotatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _RotatingIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  State<_RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<_RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        );
      },
    );
  }
}

/// Widget pour afficher un message d'erreur temporaire
class SyncErrorSnackbar extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const SyncErrorSnackbar({
    super.key,
    required this.message,
    this.onRetry,
  });

  static void show(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SyncErrorSnackbar(
          message: message,
          onRetry: onRetry,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade700,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Réessayer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}