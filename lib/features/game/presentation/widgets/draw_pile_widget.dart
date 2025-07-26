import 'package:flutter/material.dart';

class DrawPileWidget extends StatefulWidget {
  final int cardCount;
  final bool isPlayerTurn;
  final VoidCallback? onTap;

  const DrawPileWidget({
    super.key,
    required this.cardCount,
    required this.isPlayerTurn,
    this.onTap,
  });

  @override
  State<DrawPileWidget> createState() => _DrawPileWidgetState();
}

class _DrawPileWidgetState extends State<DrawPileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _canDraw => widget.isPlayerTurn;

  void _handleTap() {
    if (_canDraw && widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (_canDraw) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_canDraw) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (_canDraw) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Pioche avec ${widget.cardCount} cartes restantes',
      child: Tooltip(
        message: _canDraw
            ? (widget.cardCount > 0
                  ? 'Piocher une carte'
                  : 'Mélanger la défausse')
            : 'Pas votre tour',
        child: GestureDetector(
          onTap: _handleTap,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shadow cards for stack effect
                if (widget.cardCount > 2)
                  Transform.translate(
                    offset: const Offset(-4, -4),
                    child: _buildCard(context, opacity: 0.3),
                  ),
                if (widget.cardCount > 1)
                  Transform.translate(
                    offset: const Offset(-2, -2),
                    child: _buildCard(context, opacity: 0.6),
                  ),
                // Top card
                _buildCard(
                  context,
                  isTop: true,
                  showGlow: widget.isPlayerTurn && widget.cardCount > 0,
                ),
                // Card count badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(widget.cardCount),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.cardCount == 0
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.cardCount.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    bool isTop = false,
    bool showGlow = false,
    double opacity = 1.0,
  }) {
    final theme = Theme.of(context);
    final cardOpacity = widget.cardCount == 0 ? 0.5 : opacity;

    return Container(
      width: 80,
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (isTop) ...[
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * cardOpacity * 255).round()),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          if (showGlow)
            BoxShadow(
              color: theme.colorScheme.primary.withAlpha((0.5 * 255).round()),
              blurRadius: 16,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: cardOpacity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Card back pattern
                CustomPaint(
                  size: Size.infinite,
                  painter: _CardBackPainter(
                    color: theme.colorScheme.onPrimary.withAlpha((0.1 * 255).round()),
                  ),
                ),
                if (isTop && widget.cardCount == 0)
                  Center(
                    child: Icon(
                      Icons.close,
                      size: 40,
                      color: theme.colorScheme.onPrimary.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardBackPainter extends CustomPainter {
  final Color color;

  _CardBackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 15.0;

    // Diagonal lines pattern
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
