import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/room_providers.dart';
import '../../domain/entities/room.dart';
import '../../../rooms/presentation/providers/available_rooms_provider.dart';
import '../../../rooms/presentation/widgets/realtime_connection_indicator.dart';

class JoinRoomScreen extends ConsumerWidget {
  const JoinRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utiliser le nouveau provider avec realtime MCP
    final availableRoomsAsync = ref.watch(availableRoomsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejoindre une partie'),
        centerTitle: true,
        actions: [
          // Indicateur de connexion MCP Realtime
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: const Center(
              child: RealtimeConnectionIndicator(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: availableRoomsAsync.when(
          data: (rooms) {
            if (rooms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune partie disponible',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Créez une nouvelle partie pour commencer',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/create-room'),
                      icon: const Icon(Icons.add),
                      label: const Text('Créer une partie'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                // Forcer le rechargement via le nouveau provider
                await ref.read(availableRoomsNotifierProvider.notifier).refresh();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return _RoomCard(room: room);
                },
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
                Text(
                  'Erreur de chargement',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(availableRoomsNotifierProvider),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomCard extends ConsumerStatefulWidget {
  final Room room;

  const _RoomCard({required this.room});

  @override
  ConsumerState<_RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends ConsumerState<_RoomCard> with SingleTickerProviderStateMixin {
  bool _isJoining = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _lastPlayerCount = 0;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _lastPlayerCount = widget.room.currentPlayers;
  }
  
  @override
  void didUpdateWidget(_RoomCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Détecter les changements de nombre de joueurs
    if (widget.room.currentPlayers != _lastPlayerCount) {
      _lastPlayerCount = widget.room.currentPlayers;
      // Animer pour signaler la mise à jour
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });
    }
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    setState(() => _isJoining = true);

    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final joinRoomUseCase = ref.read(joinRoomUseCaseProvider);
      final room = await joinRoomUseCase(
        roomId: widget.room.id,
        playerId: userId,
      );

      if (room != null && mounted) {
        context.go('/room/${room.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spotsAvailable =
        widget.room.maxPlayers - widget.room.currentPlayers;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: _pulseController.isAnimating ? 4 : 1,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.groups,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text('Partie #${widget.room.id.substring(0, 8)}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          '${widget.room.currentPlayers}/${widget.room.maxPlayers} joueurs',
                          key: ValueKey('${widget.room.id}-${widget.room.currentPlayers}'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Créée ${_formatTime(widget.room.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: _isJoining || spotsAvailable == 0 ? null : _joinRoom,
                child: _isJoining
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(spotsAvailable == 0 ? 'Complet' : 'Rejoindre'),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'récemment';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'à l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'il y a ${difference.inHours} h';
    } else {
      return 'il y a ${difference.inDays} j';
    }
  }
}
