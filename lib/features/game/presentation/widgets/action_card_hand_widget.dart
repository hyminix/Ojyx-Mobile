import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/entities/game_player.dart';
import 'action_card_widget.dart';

class ActionCardHandWidget extends ConsumerStatefulWidget {
  final GamePlayer player;
  final bool isCurrentPlayer;
  final void Function(ActionCard)? onCardTap;
  final void Function(ActionCard)? onCardDiscard;

  const ActionCardHandWidget({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    this.onCardTap,
    this.onCardDiscard,
  });

  @override
  ConsumerState<ActionCardHandWidget> createState() =>
      _ActionCardHandWidgetState();
}

class _ActionCardHandWidgetState extends ConsumerState<ActionCardHandWidget> {
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final actionCards = widget.player.actionCards;
    final maxHeight = widget.isCurrentPlayer ? 180.0 : 120.0;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Title with card count
          Text(
            'Cartes Actions (${actionCards.length}/$kMaxActionCardsInHand)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),

          // Cards display
          Expanded(
            child: actionCards.isEmpty
                ? _buildEmptyState(context)
                : _buildCardsList(actionCards),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.do_not_disturb, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'Aucune carte action',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsList(List<ActionCard> cards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _buildCard(cards[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildCard(ActionCard card) {
    final isImmediate = card.timing == ActionTiming.immediate;
    final canInteract = widget.isCurrentPlayer && !_isAnimating;

    return GestureDetector(
      onLongPress: widget.isCurrentPlayer && widget.onCardDiscard != null
          ? () => _showDiscardMenu(card)
          : null,
      child: ActionCardWidget(
        card: card,
        isSelectable: canInteract,
        isHighlighted: isImmediate,
        isCompact: !widget.isCurrentPlayer,
        onTap: canInteract && widget.onCardTap != null
            ? () => _handleCardTap(card)
            : null,
      ),
    );
  }

  void _handleCardTap(ActionCard card) {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    widget.onCardTap?.call(card);

    // Reset animation flag after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  void _showDiscardMenu(ActionCard card) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: 'discard',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20),
              SizedBox(width: 8),
              Text('Défausser'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'discard' && widget.onCardDiscard != null) {
        widget.onCardDiscard!(card);
      }
    });
  }
}
