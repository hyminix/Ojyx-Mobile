import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimistic_game_state_notifier.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/entities/optimistic_actions.dart';

/// Bouton pour jouer une carte action avec gestion optimiste
class OptimisticActionButton extends ConsumerStatefulWidget {
  final ActionCard actionCard;
  final String playerId;
  final Map<String, dynamic> actionData;
  final String? targetPlayerId;
  final VoidCallback? onSuccess;
  
  const OptimisticActionButton({
    super.key,
    required this.actionCard,
    required this.playerId,
    required this.actionData,
    this.targetPlayerId,
    this.onSuccess,
  });

  @override
  ConsumerState<OptimisticActionButton> createState() => _OptimisticActionButtonState();
}

class _OptimisticActionButtonState extends ConsumerState<OptimisticActionButton>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Animation de pression
    await _animationController.forward();
    await _animationController.reverse();

    try {
      // Créer l'action optimiste
      final action = PlayActionCardAction(
        playerId: widget.playerId,
        actionCard: widget.actionCard,
        actionData: widget.actionData,
        targetPlayerId: widget.targetPlayerId,
      );

      // Appliquer l'action
      await ref.read(optimisticGameStateNotifierProvider.notifier)
          .applyOptimisticAction(action);

      // Callback de succès
      widget.onSuccess?.call();
    } catch (e) {
      // Afficher l'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
    final hasError = optimisticState.hasError;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _isProcessing
                      ? Colors.blue.withOpacity(0.3)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: _getButtonColor(),
              child: InkWell(
                onTap: _isProcessing ? null : _handlePress,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isProcessing)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      else
                        Icon(
                          _getActionIcon(widget.actionCard.type),
                          color: Colors.white,
                          size: 20,
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _isProcessing ? 'En cours...' : 'Jouer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getButtonColor() {
    if (_isProcessing) {
      return Colors.blue.shade600;
    }
    
    final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
    if (optimisticState.hasError) {
      return Colors.orange.shade600;
    }
    
    // Couleur selon le type de carte
    switch (widget.actionCard.type) {
      case ActionCardType.swap:
        return Colors.purple.shade600;
      case ActionCardType.peek:
        return Colors.teal.shade600;
      case ActionCardType.reveal:
        return Colors.indigo.shade600;
      case ActionCardType.turnDirection:
        return Colors.deepOrange.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  IconData _getActionIcon(ActionCardType type) {
    switch (type) {
      case ActionCardType.swap:
        return Icons.swap_horiz;
      case ActionCardType.peek:
        return Icons.visibility;
      case ActionCardType.reveal:
        return Icons.flip_to_front;
      case ActionCardType.turnDirection:
        return Icons.rotate_left;
      default:
        return Icons.play_arrow;
    }
  }
}

/// Widget pour terminer le tour avec gestion optimiste
class OptimisticEndTurnButton extends ConsumerStatefulWidget {
  final String playerId;
  final bool hasDrawnCard;
  final VoidCallback? onSuccess;
  
  const OptimisticEndTurnButton({
    super.key,
    required this.playerId,
    required this.hasDrawnCard,
    this.onSuccess,
  });

  @override
  ConsumerState<OptimisticEndTurnButton> createState() => _OptimisticEndTurnButtonState();
}

class _OptimisticEndTurnButtonState extends ConsumerState<OptimisticEndTurnButton> {
  bool _isProcessing = false;

  Future<void> _handleEndTurn() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Créer l'action optimiste
      final action = EndTurnAction(
        playerId: widget.playerId,
        hasDrawnCard: widget.hasDrawnCard,
      );

      // Appliquer l'action
      await ref.read(optimisticGameStateNotifierProvider.notifier)
          .applyOptimisticAction(action);

      // Callback de succès
      widget.onSuccess?.call();
    } catch (e) {
      // Afficher l'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
    final pendingActions = optimisticState.pendingActionsCount;
    
    return ElevatedButton.icon(
      onPressed: _isProcessing ? null : _handleEndTurn,
      icon: _isProcessing
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            )
          : Icon(Icons.check),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_isProcessing ? 'En cours...' : 'Terminer le tour'),
          if (pendingActions > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pendingActions.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}