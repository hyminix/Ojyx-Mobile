import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/action_card.dart';

class ActionCardWidget extends ConsumerWidget {
  final ActionCard card;
  final bool isSelectable;
  final VoidCallback? onTap;
  final bool isHighlighted;
  final bool isCompact;

  const ActionCardWidget({
    super.key,
    required this.card,
    this.isSelectable = true,
    this.onTap,
    this.isHighlighted = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = isCompact ? 80.0 : 100.0;
    final height = isCompact ? 100.0 : 140.0;

    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: isSelectable ? onTap : null,
        onLongPress: () => _showDescription(context),
        child: Card(
          elevation: isHighlighted ? 8 : 2,
          color: isHighlighted ? Colors.yellow.shade100 : null,
          child: Container(
            decoration: BoxDecoration(
              color: _getCardColor(),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.all(isCompact ? 4 : 8),
            child: isCompact
                ? _buildCompactContent(context)
                : _buildFullContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Card name
        Text(
          card.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Card type icon
        Icon(_getTypeIcon(), size: 24, color: _getIconColor()),
        const SizedBox(height: 4),

        // Timing icon only
        Icon(_getTimingIcon(), size: 12, color: _getTimingColor()),
      ],
    );
  }

  Widget _buildFullContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Card name
        Text(
          card.name,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Card type icon
        Icon(_getTypeIcon(), size: 32, color: _getIconColor()),

        // Timing indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getTimingIcon(), size: 14, color: _getTimingColor()),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                _getTimingText(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Target indicator
        if (card.target != ActionTarget.none)
          Icon(_getTargetIcon(), size: 16, color: Colors.grey),
      ],
    );
  }

  Color _getCardColor() {
    switch (card.type) {
      // Movement cards
      case ActionCardType.teleport:
      case ActionCardType.swap:
        return Colors.blue.shade50;

      // Attack cards
      case ActionCardType.steal:
      case ActionCardType.curse:
      case ActionCardType.bomb:
        return Colors.red.shade50;

      // Defense cards
      case ActionCardType.shield:
      case ActionCardType.heal:
        return Colors.purple.shade50;

      // Information cards
      case ActionCardType.peek:
      case ActionCardType.reveal:
      case ActionCardType.scout:
        return Colors.orange.shade50;

      // Turn manipulation
      case ActionCardType.turnAround:
      case ActionCardType.skip:
      case ActionCardType.reverse:
      case ActionCardType.freeze:
        return Colors.amber.shade50;

      // Utility cards
      case ActionCardType.draw:
      case ActionCardType.shuffle:
      case ActionCardType.duplicate:
      case ActionCardType.gift:
      case ActionCardType.gamble:
      case ActionCardType.discard:
      case ActionCardType.mirror:
        return Colors.green.shade50;
    }
  }

  IconData _getTypeIcon() {
    switch (card.type) {
      case ActionCardType.teleport:
        return Icons.swap_horiz;
      case ActionCardType.turnAround:
        return Icons.u_turn_left;
      case ActionCardType.peek:
        return Icons.visibility;
      case ActionCardType.swap:
        return Icons.swap_vert;
      case ActionCardType.shield:
        return Icons.shield_outlined;
      case ActionCardType.draw:
        return Icons.add_card;
      case ActionCardType.reveal:
        return Icons.visibility_outlined;
      case ActionCardType.shuffle:
        return Icons.shuffle;
      case ActionCardType.steal:
        return Icons.pan_tool;
      case ActionCardType.duplicate:
        return Icons.content_copy;
      case ActionCardType.skip:
        return Icons.skip_next;
      case ActionCardType.reverse:
        return Icons.replay;
      case ActionCardType.discard:
        return Icons.delete_outline;
      case ActionCardType.freeze:
        return Icons.ac_unit;
      case ActionCardType.mirror:
        return Icons.flip;
      case ActionCardType.bomb:
        return Icons.warning;
      case ActionCardType.heal:
        return Icons.healing;
      case ActionCardType.curse:
        return Icons.sentiment_very_dissatisfied;
      case ActionCardType.gift:
        return Icons.card_giftcard;
      case ActionCardType.gamble:
        return Icons.casino;
      case ActionCardType.scout:
        return Icons.search;
    }
  }

  Color _getIconColor() {
    switch (card.type) {
      // Attack cards
      case ActionCardType.steal:
      case ActionCardType.curse:
      case ActionCardType.bomb:
        return Colors.red.shade700;

      // Defense cards
      case ActionCardType.shield:
      case ActionCardType.heal:
        return Colors.purple.shade700;

      // Movement cards
      case ActionCardType.teleport:
      case ActionCardType.swap:
        return Colors.blue.shade700;

      default:
        return Colors.grey.shade700;
    }
  }

  IconData _getTimingIcon() {
    switch (card.timing) {
      case ActionTiming.immediate:
        return Icons.flash_on;
      case ActionTiming.optional:
        return Icons.schedule;
      case ActionTiming.reactive:
        return Icons.shield;
    }
  }

  Color _getTimingColor() {
    switch (card.timing) {
      case ActionTiming.immediate:
        return Colors.red;
      case ActionTiming.optional:
        return Colors.blue;
      case ActionTiming.reactive:
        return Colors.orange;
    }
  }

  String _getTimingText() {
    switch (card.timing) {
      case ActionTiming.immediate:
        return 'Immédiate';
      case ActionTiming.optional:
        return 'Optionnelle';
      case ActionTiming.reactive:
        return 'Réactive';
    }
  }

  IconData _getTargetIcon() {
    switch (card.target) {
      case ActionTarget.self:
        return Icons.person;
      case ActionTarget.singleOpponent:
        return Icons.person_pin;
      case ActionTarget.allOpponents:
        return Icons.groups;
      case ActionTarget.allPlayers:
        return Icons.people;
      case ActionTarget.deck:
        return Icons.layers;
      case ActionTarget.discard:
        return Icons.delete_sweep;
      case ActionTarget.none:
        return Icons.circle;
    }
  }

  void _showDescription(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(card.description),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
