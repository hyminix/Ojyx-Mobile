import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/room_providers.dart';
import '../../../../core/providers/supabase_provider.dart';

/// Widget de test pour simuler les déconnexions/reconnexions
class ConnectionTestWidget extends ConsumerWidget {
  const ConnectionTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionMonitor = ref.watch(connectionMonitorServiceProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test de connexion',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'État: ${connectionMonitor.isConnected ? "Connecté" : "Déconnecté"}',
              style: TextStyle(
                color: connectionMonitor.isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!connectionMonitor.isConnected && connectionMonitor.disconnectionDuration != null)
              Text(
                'Déconnecté depuis: ${connectionMonitor.disconnectionDuration!.inSeconds}s',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Simuler une déconnexion
                    final supabase = ref.read(supabaseClientProvider);
                    final userId = supabase.auth.currentUser?.id;
                    if (userId != null) {
                      await supabase.rpc('mark_player_disconnected', params: {
                        'p_player_id': userId,
                      });
                    }
                  },
                  child: const Text('Simuler déconnexion'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    // Forcer une reconnexion
                    final supabase = ref.read(supabaseClientProvider);
                    final userId = supabase.auth.currentUser?.id;
                    if (userId != null) {
                      await supabase.rpc('handle_player_reconnection', params: {
                        'p_player_id': userId,
                      });
                    }
                  },
                  child: const Text('Forcer reconnexion'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}