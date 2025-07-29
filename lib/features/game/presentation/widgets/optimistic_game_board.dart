import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimistic_game_state_notifier.dart';
import '../providers/connection_monitor_provider.dart';
import 'optimistic_card_widget.dart';
import 'sync_status_indicator.dart';
import 'optimistic_action_button.dart';
import '../../domain/entities/game_player.dart';
import '../../../multiplayer/presentation/widgets/player_connection_status.dart';

/// Plateau de jeu avec gestion optimiste complète
class OptimisticGameBoard extends ConsumerWidget {
  final String currentUserId;
  
  const OptimisticGameBoard({
    super.key,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
    final gameState = optimisticState.localValue;
    final connectionStatus = ref.watch(connectionStatusProvider);
    
    return Stack(
      children: [
        // Plateau principal
        _buildGameBoard(context, ref, gameState),
        
        // Indicateur de synchronisation global
        const SyncStatusIndicator(),
        
        // Overlay de déconnexion
        if (connectionStatus == ConnectionStatus.disconnected)
          _buildDisconnectionOverlay(context, ref),
        
        // Message d'erreur de synchronisation
        if (optimisticState.hasError)
          _buildErrorBanner(context, ref, optimisticState),
      ],
    );
  }

  Widget _buildGameBoard(BuildContext context, WidgetRef ref, dynamic gameState) {
    return Column(
      children: [
        // Zone des adversaires
        Expanded(
          flex: 2,
          child: _buildOpponentsArea(context, ref, gameState),
        ),
        
        // Zone centrale (pioche, défausse, etc.)
        Container(
          height: 120,
          color: Colors.green.shade50,
          child: _buildCentralArea(context, ref, gameState),
        ),
        
        // Zone du joueur actuel
        Expanded(
          flex: 3,
          child: _buildCurrentPlayerArea(context, ref, gameState),
        ),
      ],
    );
  }

  Widget _buildOpponentsArea(BuildContext context, WidgetRef ref, dynamic gameState) {
    final opponents = gameState.players
        .where((p) => p.id != currentUserId)
        .toList();
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: opponents.length,
      itemBuilder: (context, index) {
        final opponent = opponents[index];
        return _buildPlayerGrid(
          context,
          ref,
          opponent,
          isCurrentPlayer: false,
          isCompact: true,
        );
      },
    );
  }

  Widget _buildCentralArea(BuildContext context, WidgetRef ref, dynamic gameState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pioche
        _buildDeck(context, 'Pioche', gameState.deckCount),
        
        // Défausse
        _buildDiscardPile(context, gameState.discardPile),
        
        // Info du tour
        _buildTurnInfo(context, gameState),
      ],
    );
  }

  Widget _buildCurrentPlayerArea(BuildContext context, WidgetRef ref, dynamic gameState) {
    final currentPlayer = gameState.players.firstWhere(
      (p) => p.id == currentUserId,
      orElse: () => throw Exception('Current player not found'),
    );
    
    return Column(
      children: [
        // Grille du joueur
        Expanded(
          child: _buildPlayerGrid(
            context,
            ref,
            currentPlayer,
            isCurrentPlayer: true,
            isCompact: false,
          ),
        ),
        
        // Actions disponibles
        if (gameState.currentPlayer.id == currentUserId)
          _buildActionBar(context, ref, currentPlayer),
      ],
    );
  }

  Widget _buildPlayerGrid(
    BuildContext context,
    WidgetRef ref,
    GamePlayer player,
    {required bool isCurrentPlayer, required bool isCompact}
  ) {
    final cardSize = isCompact ? 50.0 : 70.0;
    
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête du joueur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                player.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isCompact ? 14 : 16,
                ),
              ),
              PlayerConnectionStatus(
                playerId: player.id,
                size: isCompact ? 12 : 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Grille de cartes
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final row = index ~/ 4;
                final col = index % 4;
                final card = player.grid.cards[index];
                
                return OptimisticCardWidget(
                  card: card,
                  row: row,
                  col: col,
                  playerId: player.id,
                  isCurrentPlayer: isCurrentPlayer,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, WidgetRef ref, GamePlayer player) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cartes action
          if (player.actionCards.isNotEmpty)
            ...player.actionCards.map((actionCard) =>
              OptimisticActionButton(
                actionCard: actionCard,
                playerId: player.id,
                actionData: {}, // À personnaliser selon l'action
              ),
            ),
          
          // Bouton fin de tour
          OptimisticEndTurnButton(
            playerId: player.id,
            hasDrawnCard: true, // À déterminer selon l'état
          ),
        ],
      ),
    );
  }

  Widget _buildDeck(BuildContext context, String label, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.layers,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$label ($count)',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDiscardPile(BuildContext context, dynamic topCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: topCard != null ? Colors.white : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: topCard != null
                ? Text(
                    topCard.displayValue,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    Icons.remove,
                    color: Colors.grey.shade600,
                  ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Défausse',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTurnInfo(BuildContext context, dynamic gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tour ${gameState.turnNumber}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Au tour de ${gameState.currentPlayer.name}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectionOverlay(BuildContext context, WidgetRef ref) {
    final reconnectAttempts = ref.watch(reconnectAttemptsProvider);
    
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 64,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connexion perdue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tentative de reconnexion... ($reconnectAttempts)',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
                const SizedBox(height: 16),
                const Text(
                  'Vos actions sont sauvegardées localement',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, WidgetRef ref, dynamic optimisticState) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.red.shade100,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade700,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                optimisticState.syncError ?? 'Erreur de synchronisation',
                style: TextStyle(
                  color: Colors.red.shade700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(optimisticGameStateNotifierProvider.notifier)
                    .forceResync();
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}