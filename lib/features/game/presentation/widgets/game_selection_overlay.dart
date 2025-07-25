import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game_player.dart';
import '../providers/card_selection_provider.dart';

/// A reusable overlay widget for handling various selection modes
/// Supports opponent selection, card selection from discard, and more
class GameSelectionOverlay extends ConsumerStatefulWidget {
  final List<GamePlayer> players;
  final String currentPlayerId;
  final bool requiresConfirmation;
  final String? confirmationMessage;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const GameSelectionOverlay({
    super.key,
    required this.players,
    required this.currentPlayerId,
    this.requiresConfirmation = false,
    this.confirmationMessage,
    this.onConfirm,
    this.onCancel,
  });

  @override
  ConsumerState<GameSelectionOverlay> createState() =>
      _GameSelectionOverlayState();
}

class _GameSelectionOverlayState extends ConsumerState<GameSelectionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectionState = ref.watch(cardSelectionProvider);
    final selectionNotifier = ref.read(cardSelectionProvider.notifier);

    // Update animation based on selection state
    if (selectionState.isSelecting) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    if (!selectionState.isSelecting && _animationController.isDismissed) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return AnimatedOpacity(
            opacity: selectionState.isSelecting ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () => selectionNotifier.cancelSelection(),
              child: Container(
                color: Colors.black.withAlpha((0.5 * 255).round()),
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent tap through
                    child: _buildSelectionContent(context, selectionState),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionContent(
    BuildContext context,
    CardSelectionState selectionState,
  ) {
    switch (selectionState.selectionType) {
      case CardSelectionType.selectOpponent:
      case CardSelectionType.steal
          when selectionState.selectedOpponentId == null:
        return _buildOpponentSelection(context, selectionState);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOpponentSelection(
    BuildContext context,
    CardSelectionState selectionState,
  ) {
    final theme = Theme.of(context);
    final opponents = widget.players
        .where((p) => p.id != widget.currentPlayerId)
        .toList();

    return Card(
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Sélectionnez un adversaire',
                    style: theme.textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => ref
                      .read(cardSelectionProvider.notifier)
                      .cancelSelection(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // GamePlayer grid
            if (opponents.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Aucun adversaire disponible',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: opponents.length,
                  itemBuilder: (context, index) {
                    final player = opponents[index];
                    final isSelected =
                        selectionState.selectedOpponentId == player.id;

                    return Card(
                      elevation: isSelected ? 8 : 2,
                      color: isSelected
                          ? theme.colorScheme.primaryContainer
                          : null,
                      child: InkWell(
                        onTap: () => ref
                            .read(cardSelectionProvider.notifier)
                            .selectOpponent(player.id),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isSelected
                                      ? theme.colorScheme.primary
                                      : theme
                                            .colorScheme
                                            .surfaceContainerHighest,
                                  foregroundColor: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                  child: const Icon(Icons.person),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  player.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
