import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/action_card_providers.dart';

class ActionCardDrawPileWidget extends ConsumerWidget {
  final bool canDraw;
  final VoidCallback? onDraw;

  const ActionCardDrawPileWidget({
    super.key,
    this.canDraw = true,
    this.onDraw,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(actionCardStateNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: 'Piochez une carte action',
      triggerMode: TooltipTriggerMode.longPress,
      child: SizedBox(
        width: 100,
        height: 140,
        child: InkWell(
          onTap: canDraw && !state.isLoading ? onDraw : null,
          borderRadius: BorderRadius.circular(12),
          child: Card(
            elevation: canDraw ? 4 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withOpacity(canDraw ? 1.0 : 0.5),
                    colorScheme.primaryContainer.withOpacity(canDraw ? 1.0 : 0.5),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Card back pattern
                  _buildCardBackPattern(context),
                  
                  // Main content
                  if (state.isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.style,
                          size: 32,
                          color: Colors.white.withOpacity(canDraw ? 1.0 : 0.6),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cartes Actions',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(canDraw ? 1.0 : 0.6),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.drawPileCount.toString(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (state.drawPileCount == 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Pile vide',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBackPattern(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: _CardBackPatternPainter(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}

class _CardBackPatternPainter extends CustomPainter {
  final Color color;

  _CardBackPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const patternSize = 20.0;
    final rows = (size.height / patternSize).ceil();
    final cols = (size.width / patternSize).ceil();

    // Draw diagonal pattern
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * patternSize;
        final y = row * patternSize;
        
        // Draw diagonal lines
        canvas.drawLine(
          Offset(x, y),
          Offset(x + patternSize, y + patternSize),
          paint,
        );
        canvas.drawLine(
          Offset(x + patternSize, y),
          Offset(x, y + patternSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}