import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../multiplayer/presentation/providers/room_providers.dart';
import '../../../multiplayer/presentation/providers/multiplayer_game_notifier.dart';
import '../providers/game_state_notifier.dart';
import '../widgets/player_grid_widget.dart';
import '../widgets/player_hand_widget.dart';
import '../widgets/turn_info_widget.dart';
import '../widgets/deck_and_discard_widget.dart';
import '../widgets/opponents_view_widget.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/player.dart';

class GameScreen extends ConsumerStatefulWidget {
  final String roomId;
  
  const GameScreen({super.key, required this.roomId});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize multiplayer sync
    Future.microtask(() {
      ref.read(multiplayerGameNotifierProvider(widget.roomId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final gameStateAsync = ref.watch(gameStateNotifierProvider);
    final roomAsync = ref.watch(currentRoomProvider(widget.roomId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ojyx'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _showExitDialog(context),
          ),
        ],
      ),
      body: roomAsync.when(
        data: (room) {
          if (gameStateAsync == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('En attente du début de la partie...'),
                ],
              ),
            );
          }
          
          final currentPlayer = _getCurrentPlayer(gameStateAsync, currentUserId!);
          if (currentPlayer == null) {
            return Center(
              child: Text('Erreur: Joueur non trouvé'),
            );
          }
          
          final isMyTurn = gameStateAsync.currentPlayer.id == currentUserId;
          
          return SafeArea(
            child: Column(
              children: [
                // Turn info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: TurnInfoWidget(
                      gameState: gameStateAsync,
                      currentPlayerId: currentUserId,
                    ),
                  ),
                ),
                
                // Main game area
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Deck and discard piles
                          DeckAndDiscardWidget(
                            gameState: gameStateAsync,
                            canDraw: isMyTurn && gameStateAsync.drawnCard == null,
                            onDrawFromDeck: () => _drawFromDeck(ref),
                            onDrawFromDiscard: () => _drawFromDiscard(ref),
                          ),
                          const SizedBox(height: 24),
                          
                          // Player's grid
                          PlayerGridWidget(
                            grid: currentPlayer.grid,
                            isCurrentPlayer: true,
                            canInteract: isMyTurn && gameStateAsync.drawnCard != null,
                            onCardTap: (row, col) => _handleCardTap(ref, row, col),
                          ),
                          const SizedBox(height: 16),
                          
                          // Other players' grids
                          if (gameStateAsync.players.length > 1) ...[
                            const SizedBox(height: 24),
                            OpponentsViewWidget(
                              gameState: gameStateAsync,
                              currentPlayerId: currentUserId,
                              onPlayerTap: (playerId) {
                                // Pour le moment, on affiche juste un message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Vue du joueur $playerId'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Player hand (drawn card)
                if (gameStateAsync.drawnCard != null && isMyTurn)
                  PlayerHandWidget(
                    drawnCard: gameStateAsync.drawnCard,
                    canDiscard: true,
                    onDiscard: () => _discardDirectly(ref),
                    isCurrentPlayer: true,
                  ),
              ],
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
  
  Player? _getCurrentPlayer(GameState gameState, String playerId) {
    try {
      return gameState.players.firstWhere((p) => p.id == playerId);
    } catch (e) {
      return null;
    }
  }
  
  void _drawFromDeck(WidgetRef ref) {
    final notifier = ref.read(multiplayerGameNotifierProvider(widget.roomId).notifier);
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId != null) {
      notifier.drawFromDeck(currentUserId);
    }
  }
  
  void _drawFromDiscard(WidgetRef ref) {
    final notifier = ref.read(multiplayerGameNotifierProvider(widget.roomId).notifier);
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId != null) {
      notifier.drawFromDiscard(currentUserId);
    }
  }
  
  void _handleCardTap(WidgetRef ref, int row, int col) {
    final gameState = ref.read(gameStateNotifierProvider);
    if (gameState?.drawnCard != null) {
      final notifier = ref.read(multiplayerGameNotifierProvider(widget.roomId).notifier);
      final currentUserId = ref.read(currentUserIdProvider);
      if (currentUserId != null) {
        // Calculate position index (row * 4 + col for 3x4 grid)
        final position = row * 4 + col;
        notifier.discardCard(currentUserId, position);
      }
    }
  }
  
  void _discardDirectly(WidgetRef ref) {
    final notifier = ref.read(multiplayerGameNotifierProvider(widget.roomId).notifier);
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId != null) {
      notifier.discardCard(currentUserId, -1); // -1 indicates direct discard
    }
  }
  
  Future<void> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la partie ?'),
        content: const Text(
          'Si vous quittez maintenant, vous ne pourrez pas revenir dans cette partie.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    
    if (result == true && context.mounted) {
      // TODO: Implement leave game logic
      context.go('/');
    }
  }
}