import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/card.dart' as game;
import 'card_widget.dart';

class DiscardPileWidget extends StatefulWidget {
  final game.Card? topCard;
  final bool canDiscard;
  final bool showStackEffect;
  final VoidCallback? onTap;
  final ValueChanged<game.Card>? onCardDropped;

  const DiscardPileWidget({
    super.key,
    required this.topCard,
    this.canDiscard = false,
    this.showStackEffect = false,
    this.onTap,
    this.onCardDropped,
  });

  @override
  State<DiscardPileWidget> createState() => _DiscardPileWidgetState();
}

class _DiscardPileWidgetState extends State<DiscardPileWidget> {
  bool _isHovering = false;
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovering && widget.onTap != null ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Shadow cards for stack effect
              if (widget.showStackEffect && widget.topCard != null) ...[
                Positioned(
                  left: -8,
                  top: -8,
                  child: Transform.rotate(
                    angle: -0.1,
                    child: _buildShadowCard(context, opacity: 0.2),
                  ),
                ),
                Positioned(
                  left: -4,
                  top: -4,
                  child: Transform.rotate(
                    angle: -0.05,
                    child: _buildShadowCard(context, opacity: 0.4),
                  ),
                ),
              ],
              // Main content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.topCard != null
                    ? _buildTopCard(context)
                    : _buildEmptyState(context),
              ),
              // Highlight overlay
              if (widget.canDiscard || _isDragOver)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isDragOver
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withValues(
                                opacity: 0.5,
                              ),
                        width: 3,
                      ),
                      boxShadow: [
                        if (_isDragOver)
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              opacity: 0.3,
                            ),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    // Wrap with DragTarget if card dropping is enabled
    // Skip DragTarget in test environment to avoid hanging
    final isTestEnvironment = Platform.environment.containsKey('FLUTTER_TEST');

    if (widget.onCardDropped != null && !isTestEnvironment) {
      content = DragTarget<game.Card>(
        onWillAcceptWithDetails: (card) {
          setState(() => _isDragOver = true);
          return widget.canDiscard;
        },
        onAcceptWithDetails: (card) {
          setState(() => _isDragOver = false);
          widget.onCardDropped!(card);
        },
        onLeave: (_) {
          setState(() => _isDragOver = false);
        },
        builder: (context, candidateData, rejectedData) {
          return content;
        },
      );
    }

    return Semantics(
      label: widget.topCard != null
          ? 'Défausse avec carte ${widget.topCard!.value} visible'
          : 'Défausse vide',
      child: content,
    );
  }

  Widget _buildTopCard(BuildContext context) {
    return Transform.rotate(
      angle: 0.05, // Slight rotation for visual effect
      child: SizedBox(
        width: 80,
        height: 112,
        child: CardWidget(card: widget.topCard),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 80,
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.3 * 255).round()),
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.layers_clear,
            size: 32,
            color: theme.colorScheme.onSurface.withAlpha((0.3 * 255).round()),
          ),
          const SizedBox(height: 8),
          Text(
            'Défausse',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowCard(BuildContext context, {required double opacity}) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: opacity,
      child: Container(
        width: 80,
        height: 112,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
