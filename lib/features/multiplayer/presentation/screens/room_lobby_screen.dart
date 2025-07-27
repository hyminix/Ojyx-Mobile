import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/deep_link_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/room_providers.dart';
import '../../domain/entities/room.dart';

class RoomLobbyScreen extends ConsumerWidget {
  final String roomId;

  const RoomLobbyScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(currentRoomProvider(roomId));
    final currentUserId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salle d\'attente'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Leave room before going back
            if (currentUserId != null) {
              final repository = ref.read(roomRepositoryProvider);
              await repository.leaveRoom(
                roomId: roomId,
                playerId: currentUserId,
              );
            }
            if (context.mounted) {
              context.go('/');
            }
          },
        ),
      ),
      body: roomAsync.when(
        data: (room) {
          final isCreator = room.creatorId == currentUserId;
          final canStart =
              room.playerIds.length >= 2 && room.playerIds.length <= 8;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Room info card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.meeting_room,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Partie #${room.id.substring(0, 8)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.share, size: 20),
                                tooltip: 'Partager la partie',
                                onPressed: () => _shareRoom(context, room.id),
                                visualDensity: VisualDensity.compact,
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                tooltip: 'Copier le code',
                                onPressed: () =>
                                    _copyRoomCode(context, room.id),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                room.status,
                                context,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusText(room.status),
                              style: TextStyle(
                                color: _getStatusColor(room.status, context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Players list
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Joueurs',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  '${room.playerIds.length}/${room.maxPlayers}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: room.maxPlayers,
                                itemBuilder: (context, index) {
                                  if (index < room.playerIds.length) {
                                    final playerId = room.playerIds[index];
                                    final isCurrentUser =
                                        playerId == currentUserId;
                                    final isHost = playerId == room.creatorId;

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: isCurrentUser
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                        child: Icon(
                                          isHost ? Icons.star : Icons.person,
                                          color: isCurrentUser
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      title: Text(
                                        isCurrentUser
                                            ? 'Vous'
                                            : 'Joueur ${index + 1}',
                                        style: TextStyle(
                                          fontWeight: isCurrentUser
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      subtitle: Text(
                                        isHost ? 'Créateur' : 'Joueur',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    );
                                  } else {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        child: Icon(
                                          Icons.person_outline,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      title: Text(
                                        'En attente...',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  if (isCreator && room.status == RoomStatus.waiting) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: canStart
                            ? () => _startGame(context, ref, room)
                            : null,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          canStart
                              ? 'Lancer la partie'
                              : 'En attente de joueurs (minimum 2)',
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ] else if (room.status == RoomStatus.waiting) ...[
                    const LinearProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'En attente du créateur...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(RoomStatus status, BuildContext context) {
    switch (status) {
      case RoomStatus.waiting:
        return Colors.orange;
      case RoomStatus.inGame:
        return Colors.green;
      case RoomStatus.finished:
        return Colors.grey;
      case RoomStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return 'En attente';
      case RoomStatus.inGame:
        return 'En cours';
      case RoomStatus.finished:
        return 'Terminée';
      case RoomStatus.cancelled:
        return 'Annulée';
    }
  }

  void _shareRoom(BuildContext context, String roomId) {
    final message = DeepLinkService.generateShareMessage(roomId);

    // TODO: Implement actual sharing using share_plus package
    // For now, just copy to clipboard
    Clipboard.setData(ClipboardData(text: message));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lien de partage copié!'),
        action: SnackBarAction(
          label: 'Voir',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Partager la partie'),
                content: SelectableText(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _copyRoomCode(BuildContext context, String roomId) {
    Clipboard.setData(ClipboardData(text: roomId));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code de la partie copié!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _startGame(
    BuildContext context,
    WidgetRef ref,
    Room room,
  ) async {
    try {
      // TODO: Implement game start logic
      // For now, just navigate to game screen
      context.go('/game/${room.id}');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
