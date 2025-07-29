import 'package:flutter/material.dart';
import '../../domain/entities/lobby_player.dart';

/// Widget to display player connection status with visual indicators
class PlayerConnectionStatus extends StatelessWidget {
  final LobbyPlayer player;
  final bool showDetails;

  const PlayerConnectionStatus({
    super.key,
    required this.player,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusIcon(),
        if (showDetails) ...[
          const SizedBox(width: 4),
          _buildStatusText(context),
        ],
      ],
    );
  }

  Widget _buildStatusIcon() {
    Color color;
    IconData icon;
    double size = 10;

    switch (player.connectionStatus) {
      case ConnectionStatus.online:
        color = Colors.green;
        icon = Icons.circle;
        break;
      case ConnectionStatus.away:
        color = Colors.orange;
        icon = Icons.circle_outlined;
        break;
      case ConnectionStatus.offline:
        color = Colors.grey;
        icon = Icons.circle_outlined;
        break;
    }

    return Icon(
      icon,
      color: color,
      size: size,
    );
  }

  Widget _buildStatusText(BuildContext context) {

    final statusText = _getStatusText();
    final color = _getStatusColor();

    return Text(
      statusText,
      style: TextStyle(
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String _getStatusText() {
    switch (player.connectionStatus) {
      case ConnectionStatus.online:
        return 'En ligne';
      case ConnectionStatus.away:
        return 'Déconnecté';
      case ConnectionStatus.offline:
        return 'Hors ligne';
    }
  }

  Color _getStatusColor() {
    switch (player.connectionStatus) {
      case ConnectionStatus.online:
        return Colors.green[700]!;
      case ConnectionStatus.away:
        return Colors.orange[700]!;
      case ConnectionStatus.offline:
        return Colors.grey[600]!;
    }
  }

  String? _calculateTimeRemaining() {
    // Connection timeout is not currently tracked in LobbyPlayer
    return null;
  }
}

/// Animated connection indicator with pulse effect
class ConnectionPulseIndicator extends StatefulWidget {
  final String connectionStatus;
  final double size;

  const ConnectionPulseIndicator({
    super.key,
    required this.connectionStatus,
    this.size = 8.0,
  });

  @override
  State<ConnectionPulseIndicator> createState() => _ConnectionPulseIndicatorState();
}

class _ConnectionPulseIndicatorState extends State<ConnectionPulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    if (widget.connectionStatus == 'online') {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(ConnectionPulseIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.connectionStatus != oldWidget.connectionStatus) {
      if (widget.connectionStatus == 'online') {
        _animationController.repeat();
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getIndicatorColor();

    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse animation
          if (widget.connectionStatus == 'online')
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: color.withOpacity(_opacityAnimation.value * 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          // Main indicator
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: widget.connectionStatus == 'online'
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getIndicatorColor() {
    switch (widget.connectionStatus) {
      case 'online':
        return Colors.green;
      case 'disconnected':
        return Colors.orange;
      case 'offline':
      default:
        return Colors.grey;
    }
  }
}