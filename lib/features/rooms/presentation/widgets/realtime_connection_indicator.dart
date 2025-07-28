import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/available_rooms_provider.dart';

/// Indicateur visuel de l'état de la connexion temps réel MCP
class RealtimeConnectionIndicator extends ConsumerWidget {
  const RealtimeConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(availableRoomsNotifierProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(roomsAsync).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(roomsAsync).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStatusColor(roomsAsync),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _getStatusText(roomsAsync),
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(roomsAsync),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (roomsAsync.isLoading) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Color _getStatusColor(AsyncValue<List<dynamic>> state) {
    return state.when(
      data: (_) => Colors.green,
      loading: () => Colors.orange,
      error: (_, _) => Colors.red,
    );
  }
  
  String _getStatusText(AsyncValue<List<dynamic>> state) {
    return state.when(
      data: (_) => 'MCP Realtime connecté',
      loading: () => 'Connexion MCP...',
      error: (_, _) => 'MCP déconnecté',
    );
  }
}