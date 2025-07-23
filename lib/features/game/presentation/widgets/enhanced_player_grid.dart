import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/card.dart' as game;
import '../../domain/entities/card_position.dart';
import '../providers/card_selection_provider.dart';
import 'player_grid_widget.dart';
import 'card_widget.dart';
import 'card_animation_widget.dart';
import 'visual_feedback_widget.dart';

/// Enhanced player grid with animations and visual feedback
class EnhancedPlayerGrid extends ConsumerStatefulWidget {
  final Player player;
  final bool isCurrentPlayer;
  final Function(int position) onCardTap;
  final bool showSuccessFeedback;
  final bool showErrorFeedback;
  final bool enablePulseAnimation;
  final bool enableRippleEffect;
  final bool animateSwap;
  final bool enableChainedAnimations;

  const EnhancedPlayerGrid({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    required this.onCardTap,
    this.showSuccessFeedback = false,
    this.showErrorFeedback = false,
    this.enablePulseAnimation = false,
    this.enableRippleEffect = false,
    this.animateSwap = false,
    this.enableChainedAnimations = false,
  });

  @override
  ConsumerState<EnhancedPlayerGrid> createState() => _EnhancedPlayerGridState();
}

class _EnhancedPlayerGridState extends ConsumerState<EnhancedPlayerGrid> {
  final Map<int, GlobalKey<CardAnimationWidgetState>> _animationKeys = {};
  final Map<int, GlobalKey<VisualFeedbackWidgetState>> _feedbackKeys = {};

  @override
  void initState() {
    super.initState();
    // Initialize keys for each card position
    for (int i = 0; i < 12; i++) {
      _animationKeys[i] = GlobalKey<CardAnimationWidgetState>();
      _feedbackKeys[i] = GlobalKey<VisualFeedbackWidgetState>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectionState = ref.watch(cardSelectionProvider);

    // Build enhanced cards
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final row = index ~/ 4;
        final col = index % 4;
        final position = index;
        final card = widget.player.grid.getCard(row, col);
        final isSelectable = _isCardSelectable(position, selectionState);
        // final cardPosition = CardPosition(row: row, col: col);  // CardPosition doesn't have playerId
        final isSelected = selectionState.selections.any((s) => s.row == row && s.col == col);
        
        return VisualFeedbackWidget(
          key: _feedbackKeys[position],
          tooltip: widget.isCurrentPlayer && card?.isRevealed == true
              ? 'Valeur: ${card?.value}'
              : null,
          onFeedbackComplete: () {
            if (widget.enableChainedAnimations) {
              _startChainedAnimation(position);
            }
          },
          child: CardAnimationWidget(
            key: _animationKeys[position],
            card: card ?? const game.Card(value: 0, isRevealed: false),
            child: CardWidget(
              card: card,
              isSelected: isSelected,
              isHighlighted: isSelectable && selectionState.isSelecting,
              onTap: card != null ? () => _handleCardTap(position) : null,
            ),
          ),
        );
      },
    );
  }

  bool _isCardSelectable(int position, CardSelectionState state) {
    if (!state.isSelecting) return false;

    final row = position ~/ 4;
    final col = position % 4;
    final card = widget.player.grid.getCard(row, col);
    if (card == null) return false;

    switch (state.selectionType) {
      case CardSelectionType.teleport:
      case CardSelectionType.swap:
        return card.isRevealed;
      case CardSelectionType.peek:
        return !card.isRevealed;
      case CardSelectionType.bomb:
      case CardSelectionType.mirror:
      case CardSelectionType.gift:
      case CardSelectionType.steal:
      case CardSelectionType.scout:
        return true;
      default:
        return false;
    }
  }

  void _handleCardTap(int position) {
    final selectionState = ref.read(cardSelectionProvider);
    
    // Show feedback animations
    if (widget.enableRippleEffect) {
      final RenderBox? box = _feedbackKeys[position]?.currentContext
          ?.findRenderObject() as RenderBox?;
      if (box != null) {
        final localPosition = box.size.center(Offset.zero);
        _feedbackKeys[position]?.currentState?.showRipple(localPosition);
      }
    }

    // Handle selection logic
    if (selectionState.isSelecting) {
      final isValid = _isCardSelectable(position, selectionState);
      
      if (isValid) {
        ref.read(cardSelectionProvider.notifier).selectCard(
          position,
          position, // Using position as playerId for now
        );
        
        if (widget.showSuccessFeedback) {
          _feedbackKeys[position]?.currentState?.showSuccess();
        }

        // Animate swap if needed
        if (widget.animateSwap && 
            selectionState.selections.isNotEmpty &&
            selectionState.selectionType == CardSelectionType.swap) {
          final firstPos = selectionState.selections.first;
          final firstIndex = firstPos.row * 4 + firstPos.col;
          _animateSwap(firstIndex, position);
        }
      } else if (widget.showErrorFeedback) {
        _feedbackKeys[position]?.currentState?.showError();
      }
    }

    // Pulse animation for highlighted cards
    if (widget.enablePulseAnimation && _isCardSelectable(position, selectionState)) {
      _feedbackKeys[position]?.currentState?.showPulse(intensity: 1.2);
    }

    // Call the original callback
    widget.onCardTap(position);
  }

  void _animateSwap(int from, int to) {
    final fromBox = _animationKeys[from]?.currentContext
        ?.findRenderObject() as RenderBox?;
    final toBox = _animationKeys[to]?.currentContext
        ?.findRenderObject() as RenderBox?;

    if (fromBox != null && toBox != null) {
      final fromPosition = fromBox.localToGlobal(Offset.zero);
      final toPosition = toBox.localToGlobal(Offset.zero);

      _animationKeys[from]?.currentState?.animateSwapWith(toPosition);
      _animationKeys[to]?.currentState?.animateSwapWith(fromPosition);
    }
  }

  void _startChainedAnimation(int position) {
    // Example of chained animations
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationKeys[position]?.currentState?.animateTeleport();
    });
  }

  @override
  void didUpdateWidget(EnhancedPlayerGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Start pulse animations for highlighted cards
    if (widget.enablePulseAnimation && !oldWidget.enablePulseAnimation) {
      final selectionState = ref.read(cardSelectionProvider);
      for (int i = 0; i < 12; i++) {
        if (_isCardSelectable(i, selectionState)) {
          _feedbackKeys[i]?.currentState?.showPulse(intensity: 1.1);
        }
      }
    }
  }
}