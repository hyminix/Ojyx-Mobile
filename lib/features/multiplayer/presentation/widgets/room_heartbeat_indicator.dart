import 'package:flutter/material.dart';

/// Widget that displays the heartbeat status of a room
class RoomHeartbeatIndicator extends StatelessWidget {
  final bool isStale;
  final DateTime? lastHeartbeat;
  final bool showDetails;

  const RoomHeartbeatIndicator({
    super.key,
    required this.isStale,
    this.lastHeartbeat,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isStale) {
      // Room is active - show green indicator
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          if (showDetails) ...[
            const SizedBox(width: 4),
            Text(
              'Active',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      );
    }

    // Room is stale - show warning
    final timeSinceHeartbeat = lastHeartbeat != null
        ? DateTime.now().difference(lastHeartbeat!).inMinutes
        : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.orange,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          timeSinceHeartbeat != null
              ? 'Inactive (${timeSinceHeartbeat}m)'
              : 'Room inactive',
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Animated heartbeat pulse indicator
class HeartbeatPulseIndicator extends StatefulWidget {
  final bool isActive;
  final Color color;
  final double size;

  const HeartbeatPulseIndicator({
    super.key,
    required this.isActive,
    this.color = Colors.green,
    this.size = 8.0,
  });

  @override
  State<HeartbeatPulseIndicator> createState() => _HeartbeatPulseIndicatorState();
}

class _HeartbeatPulseIndicatorState extends State<HeartbeatPulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(HeartbeatPulseIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.5),
                  blurRadius: 4 * _animation.value,
                  spreadRadius: 1 * _animation.value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}