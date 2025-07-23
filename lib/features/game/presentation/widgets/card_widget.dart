import 'package:flutter/material.dart';
import '../../domain/entities/card.dart' as game;
import '../../../../core/utils/constants.dart';

class CardWidget extends StatelessWidget {
  final game.Card? card;
  final bool isPlaceholder;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  
  const CardWidget({
    super.key,
    this.card,
    this.isPlaceholder = false,
    this.isSelected = false,
    this.isHighlighted = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(isSelected ? 0 : 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : isHighlighted
                      ? Colors.orange
                      : Colors.transparent,
              width: isSelected || isHighlighted ? 3 : 0,
            ),
            boxShadow: [
              if (card != null || isPlaceholder)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildCardContent(context),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCardContent(BuildContext context) {
    if (isPlaceholder) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.add,
            size: 32,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      );
    }
    
    if (card == null) {
      return const SizedBox.shrink();
    }
    
    if (!card!.isRevealed) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Pattern de dos de carte
            CustomPaint(
              size: Size.infinite,
              painter: _CardBackPainter(
                color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1),
              ),
            ),
            Center(
              child: Icon(
                Icons.question_mark,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      );
    }
    
    // Carte révélée
    return Container(
      color: _getCardBackgroundColor(context),
      child: Stack(
        children: [
          // Valeur en haut à gauche
          Positioned(
            top: 8,
            left: 8,
            child: _buildCardValue(context, small: true),
          ),
          // Valeur en bas à droite (inversée)
          Positioned(
            bottom: 8,
            right: 8,
            child: Transform.rotate(
              angle: 3.14159,
              child: _buildCardValue(context, small: true),
            ),
          ),
          // Valeur centrale
          Center(
            child: _buildCardValue(context, small: false),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCardValue(BuildContext context, {required bool small}) {
    final textStyle = small
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getCardTextColor(),
          )
        : Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getCardTextColor(),
          );
    
    return Text(
      card!.value.toString(),
      style: textStyle,
    );
  }
  
  Color _getCardBackgroundColor(BuildContext context) {
    final baseColor = _getCardBaseColor();
    return Color.alphaBlend(
      baseColor.withValues(alpha: 0.9),
      Theme.of(context).colorScheme.surface,
    );
  }
  
  Color _getCardBaseColor() {
    switch (card!.color) {
      case CardValueColor.darkBlue:
      case CardValueColor.lightBlue:
        return Colors.blue.shade100;
      case CardValueColor.green:
        return Colors.green.shade100;
      case CardValueColor.yellow:
        return Colors.yellow.shade100;
      case CardValueColor.red:
        return Colors.red.shade100;
    }
  }
  
  Color _getCardTextColor() {
    switch (card!.color) {
      case CardValueColor.darkBlue:
      case CardValueColor.lightBlue:
        return Colors.blue.shade900;
      case CardValueColor.green:
        return Colors.green.shade900;
      case CardValueColor.yellow:
        return Colors.yellow.shade900;
      case CardValueColor.red:
        return Colors.red.shade900;
    }
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
    
    // Lignes diagonales
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