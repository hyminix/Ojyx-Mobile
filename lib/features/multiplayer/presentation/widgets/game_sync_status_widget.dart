import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/room_providers.dart';
import '../../domain/entities/game_sync_event.dart';

/// Widget pour afficher le statut de synchronisation et les événements
class GameSyncStatusWidget extends ConsumerWidget {
  const GameSyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncController = ref.watch(gameSyncControllerProvider.notifier);
    final eventStream = ref.watch(gameSyncEventStreamProvider);
    final errorStream = ref.watch(syncErrorStreamProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Statut de synchronisation',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Indicateur de statut
                _buildStatusIndicator(syncController),
              ],
            ),
            const SizedBox(height: 8),
            
            // Compteur de retry
            Text(
              'Événements en attente: ${syncController.pendingRetryCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            const Divider(),
            
            // Stream des événements récents
            Container(
              height: 100,
              child: StreamBuilder<GameSyncEvent>(
                stream: eventStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'En attente d\'événements...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  
                  final event = snapshot.data!;
                  return _buildEventTile(event);
                },
              ),
            ),
            
            // Stream des erreurs
            StreamBuilder<SyncErrorEvent>(
              stream: errorStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                
                final error = snapshot.data!;
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Erreur: ${error.message}',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusIndicator(GameSyncController controller) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: controller.isInitialized ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
        boxShadow: controller.isInitialized
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
  
  Widget _buildEventTile(GameSyncEvent event) {
    final icon = _getEventIcon(event);
    final title = _getEventTitle(event);
    final subtitle = _getEventSubtitle(event);
    
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Text(
        _formatTime(event.map(
          playerJoined: (e) => e.timestamp,
          playerLeft: (e) => e.timestamp,
          gameStateUpdated: (e) => e.timestamp,
          cardRevealed: (e) => e.timestamp,
          actionCardPlayed: (e) => e.timestamp,
          turnChanged: (e) => e.timestamp,
          roomSettingsChanged: (e) => e.timestamp,
          gameStarted: (e) => e.timestamp,
          gameEnded: (e) => e.timestamp,
          playerDisconnected: (e) => e.disconnectedAt,
          playerReconnected: (e) => e.reconnectedAt,
          chatMessage: (e) => e.timestamp,
          syncError: (e) => e.timestamp,
        )),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
  
  IconData _getEventIcon(GameSyncEvent event) {
    return event.map(
      playerJoined: (_) => Icons.person_add,
      playerLeft: (_) => Icons.person_remove,
      gameStateUpdated: (_) => Icons.sync,
      cardRevealed: (_) => Icons.visibility,
      actionCardPlayed: (_) => Icons.play_arrow,
      turnChanged: (_) => Icons.rotate_right,
      roomSettingsChanged: (_) => Icons.settings,
      gameStarted: (_) => Icons.play_circle,
      gameEnded: (_) => Icons.stop_circle,
      playerDisconnected: (_) => Icons.wifi_off,
      playerReconnected: (_) => Icons.wifi,
      chatMessage: (_) => Icons.chat,
      syncError: (_) => Icons.error,
    );
  }
  
  String _getEventTitle(GameSyncEvent event) {
    return event.map(
      playerJoined: (e) => 'Joueur rejoint',
      playerLeft: (e) => 'Joueur parti',
      gameStateUpdated: (_) => 'État mis à jour',
      cardRevealed: (e) => 'Carte révélée',
      actionCardPlayed: (e) => 'Action jouée',
      turnChanged: (_) => 'Changement de tour',
      roomSettingsChanged: (_) => 'Paramètres modifiés',
      gameStarted: (_) => 'Partie démarrée',
      gameEnded: (_) => 'Partie terminée',
      playerDisconnected: (_) => 'Joueur déconnecté',
      playerReconnected: (_) => 'Joueur reconnecté',
      chatMessage: (_) => 'Message',
      syncError: (e) => 'Erreur: ${e.errorType}',
    );
  }
  
  String _getEventSubtitle(GameSyncEvent event) {
    return event.map(
      playerJoined: (e) => e.player.displayName,
      playerLeft: (e) => e.isTimeout ? 'Timeout' : 'Départ volontaire',
      gameStateUpdated: (e) => e.triggeredBy ?? 'Système',
      cardRevealed: (e) => 'Position: (${e.row}, ${e.col})',
      actionCardPlayed: (e) => e.actionCard.name,
      turnChanged: (e) => 'Tour ${e.turnNumber}',
      roomSettingsChanged: (e) => 'Par ${e.changedBy}',
      gameStarted: (e) => '${e.playerIds.length} joueurs',
      gameEnded: (e) => 'Gagnant: ${e.winnerId}',
      playerDisconnected: (e) => 'Timeout: ${_formatTime(e.timeoutAt)}',
      playerReconnected: (e) => 'Retour en jeu',
      chatMessage: (e) => e.message,
      syncError: (e) => e.message,
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else {
      return '${diff.inHours}h';
    }
  }
}