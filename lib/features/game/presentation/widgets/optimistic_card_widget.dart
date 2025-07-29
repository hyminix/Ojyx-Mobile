import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimistic_game_state_notifier.dart';
import '../../domain/entities/card.dart' as game_card;
import '../../domain/entities/card_position.dart';
import '../../domain/entities/optimistic_actions.dart';

/// Widget qui affiche une carte avec gestion optimiste
class OptimisticCardWidget extends ConsumerWidget {
  final game_card.Card card;
  final int row;
  final int col;
  final String playerId;
  final bool isCurrentPlayer;
  final VoidCallback? onTap;

  const OptimisticCardWidget({
    super.key,
    required this.card,
    required this.row,
    required this.col,
    required this.playerId,
    required this.isCurrentPlayer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
    final localGameState = optimisticState.localValue;
    
    // Vérifier si cette carte a une action optimiste en cours
    final cardPosition = CardPosition(
      playerId: playerId,
      row: row,
      col: col,
    );
    
    final isPending = optimisticState.pendingActionsCount > 0 &&
        _hasPendingAction(optimisticState, cardPosition);
    
    return GestureDetector(
      onTap: isCurrentPlayer && !card.isRevealed ? () => _handleTap(ref) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isPending
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: isPending ? 8 : 4,
              spreadRadius: isPending ? 2 : 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Carte principale
            _buildCard(context),
            
            // Indicateur de synchronisation
            if (isPending)
              Positioned(
                top: 4,
                right: 4,
                child: _SyncIndicator(
                  isError: optimisticState.hasError,
                ),
              ),
            
            // Animation de révélation optimiste
            if (card.isRevealed && isPending)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    if (!card.isRevealed) {
      return Container(
        width: 70,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[700]!,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.help_outline,
            color: Colors.grey[600],
            size: 30,
          ),
        ),
      );
    }

    final cardColor = _getCardColor(card.suit);
    
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.displayValue,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            _getSuitIcon(card.suit),
            color: cardColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getCardColor(String suit) {
    switch (suit) {
      case 'hearts':
      case 'diamonds':
        return Colors.red;
      case 'clubs':
      case 'spades':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  IconData _getSuitIcon(String suit) {
    switch (suit) {
      case 'hearts':
        return Icons.favorite;
      case 'diamonds':
        return Icons.diamond;
      case 'clubs':
        return Icons.grass;
      case 'spades':
        return Icons.park;
      default:
        return Icons.help_outline;
    }
  }

  void _handleTap(WidgetRef ref) {
    // Créer l'action optimiste
    final action = RevealCardAction(
      playerId: playerId,
      row: row,
      col: col,
    );
    
    // Appliquer l'action de manière optimiste
    ref.read(optimisticGameStateNotifierProvider.notifier)
        .applyOptimisticAction(action);
    
    // Callback optionnel
    onTap?.call();
  }

  bool _hasPendingAction(dynamic optimisticState, CardPosition position) {
    // Vérifier dans l'état local si cette position a été modifiée récemment
    // Cette logique peut être étendue selon les besoins
    return false; // Placeholder
  }
}

/// Indicateur de synchronisation animé
class _SyncIndicator extends StatefulWidget {
  final bool isError;

  const _SyncIndicator({
    required this.isError,
  });

  @override
  State<_SyncIndicator> createState() => _SyncIndicatorState();
}

class _SyncIndicatorState extends State<_SyncIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    
    if (!widget.isError) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_SyncIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isError && !oldWidget.isError) {
      _controller.stop();
    } else if (!widget.isError && oldWidget.isError) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isError) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 16,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sync,
              color: Colors.white,
              size: 16,
            ),
          ),
        );
      },
    );
  }
}