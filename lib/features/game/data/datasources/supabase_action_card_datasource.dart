import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/action_card.dart';
import 'action_card_local_datasource.dart';

class SupabaseActionCardDataSource implements ActionCardLocalDataSource {
  final SupabaseClient _supabaseClient;
  final String _gameStateId;
  final _random = math.Random();

  SupabaseActionCardDataSource(this._supabaseClient, this._gameStateId);

  @override
  Future<List<ActionCard>> getAvailableActionCards() async {
    final response = await _supabaseClient
        .from('decks')
        .select()
        .eq('game_state_id', _gameStateId)
        .eq('deck_type', 'action_cards')
        .single();

    final cards = (response['cards'] as List<dynamic>?) ?? [];
    return cards
        .map((card) => ActionCard.fromJson(card as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ActionCard>> getPlayerActionCards(String playerId) async {
    final response = await _supabaseClient
        .from('player_grids')
        .select()
        .eq('game_state_id', _gameStateId)
        .eq('player_id', playerId)
        .single();

    final cards = (response['action_cards'] as List<dynamic>?) ?? [];
    return cards
        .map((card) => ActionCard.fromJson(card as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addActionCardToPlayer(String playerId, ActionCard card) async {
    // First, get current action cards
    final response = await _supabaseClient
        .from('player_grids')
        .select()
        .eq('game_state_id', _gameStateId)
        .eq('player_id', playerId)
        .single();

    final currentCards = (response['action_cards'] as List<dynamic>?) ?? [];

    if (currentCards.length >= kMaxActionCardsInHand) {
      throw Exception(
        'GamePlayer cannot have more than $kMaxActionCardsInHand action cards',
      );
    }

    // Add the new card
    final updatedCards = [...currentCards, card.toJson()];

    // Update player grid with new action cards
    await _supabaseClient
        .from('player_grids')
        .update({'action_cards': updatedCards})
        .eq('game_state_id', _gameStateId)
        .eq('player_id', playerId)
        .select();
  }

  @override
  Future<void> removeActionCardFromPlayer(
    String playerId,
    ActionCard card,
  ) async {
    // Get current action cards
    final response = await _supabaseClient
        .from('player_grids')
        .select()
        .eq('game_state_id', _gameStateId)
        .eq('player_id', playerId)
        .single();

    final currentCards = (response['action_cards'] as List<dynamic>?) ?? [];

    // Check if player has the card
    final hasCard = currentCards.any((c) => c['id'] == card.id);
    if (!hasCard) {
      throw Exception('GamePlayer does not have this action card');
    }

    // Remove the card
    final updatedCards = currentCards.where((c) => c['id'] != card.id).toList();

    // Update player grid
    await _supabaseClient
        .from('player_grids')
        .update({'action_cards': updatedCards})
        .eq('game_state_id', _gameStateId)
        .eq('player_id', playerId)
        .select();
  }

  @override
  Future<ActionCard?> drawActionCard() async {
    // Get current deck state
    final response = await _supabaseClient
        .from('decks')
        .select()
        .eq('game_state_id', _gameStateId)
        .eq('deck_type', 'action_cards')
        .single();

    final cards = (response['cards'] as List<dynamic>?) ?? [];
    final position = response['position'] as int? ?? 0;

    if (position >= cards.length) {
      return null; // Deck is empty
    }

    // Get the card at current position
    final drawnCard = ActionCard.fromJson(
      cards[position] as Map<String, dynamic>,
    );

    // Update deck position
    await _supabaseClient
        .from('decks')
        .update({'position': position + 1})
        .eq('game_state_id', _gameStateId)
        .eq('deck_type', 'action_cards')
        .select();

    return drawnCard;
  }

  @override
  Future<void> discardActionCard(ActionCard card) async {
    // Get current discard pile from game_states
    final gameStateResponse = await _supabaseClient
        .from('game_states')
        .select()
        .eq('id', _gameStateId)
        .single();

    final discardPile =
        (gameStateResponse['action_cards_discard'] as List<dynamic>?) ?? [];

    // Add card to discard pile
    final updatedDiscard = [...discardPile, card.toJson()];

    // Update game state with new discard pile
    await _supabaseClient
        .from('game_states')
        .update({'action_cards_discard': updatedDiscard})
        .eq('id', _gameStateId)
        .select();
  }

  @override
  Future<void> shuffleActionCards() async {
    // Get current deck
    final response = await _supabaseClient
        .from('decks')
        .select()
        .eq('game_state_id', _gameStateId)
        .eq('deck_type', 'action_cards')
        .single();

    final cards = List<Map<String, dynamic>>.from(
      response['cards'] as List<dynamic>,
    );
    final position = response['position'] as int? ?? 0;

    // Only shuffle cards that haven't been drawn yet
    final remainingCards = cards.sublist(position);
    remainingCards.shuffle(_random);

    // Reconstruct the deck with drawn cards at the beginning
    final shuffledDeck = [...cards.sublist(0, position), ...remainingCards];

    // Update deck with shuffled cards
    await _supabaseClient
        .from('decks')
        .update({'cards': shuffledDeck})
        .eq('game_state_id', _gameStateId)
        .eq('deck_type', 'action_cards')
        .select();
  }

  @override
  Future<void> initializeDeck() async {
    final cards = <Map<String, dynamic>>[];

    // Create a balanced deck of action cards
    final actionCardTypes = [
      // Movement cards
      (
        ActionCardType.teleport,
        'Téléportation',
        'Échangez deux cartes de votre grille',
        ActionTiming.optional,
        ActionTarget.self,
        4,
      ),
      (
        ActionCardType.swap,
        'Échange',
        'Échangez une carte avec un adversaire',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        3,
      ),
      // Turn manipulation
      (
        ActionCardType.turnAround,
        'Demi-tour',
        'Inversez le sens du jeu',
        ActionTiming.immediate,
        ActionTarget.none,
        3,
      ),
      (
        ActionCardType.skip,
        'Saut',
        'Le prochain joueur passe son tour',
        ActionTiming.optional,
        ActionTarget.none,
        4,
      ),
      // Information cards
      (
        ActionCardType.peek,
        'Coup d\'œil',
        'Regardez une carte adverse',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        4,
      ),
      (
        ActionCardType.reveal,
        'Révélation',
        'Révélez une carte à tous',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        2,
      ),
      // Protection cards
      (
        ActionCardType.shield,
        'Bouclier',
        'Protégez-vous des attaques ce tour',
        ActionTiming.reactive,
        ActionTarget.self,
        3,
      ),
      // Attack cards
      (
        ActionCardType.steal,
        'Vol',
        'Volez une carte action à un adversaire',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        2,
      ),
      (
        ActionCardType.curse,
        'Malédiction',
        'Doublez le score d\'une colonne adverse',
        ActionTiming.optional,
        ActionTarget.singleOpponent,
        2,
      ),
      // Utility cards
      (
        ActionCardType.draw,
        'Pioche',
        'Piochez 2 cartes actions',
        ActionTiming.optional,
        ActionTarget.deck,
        3,
      ),
      (
        ActionCardType.shuffle,
        'Mélange',
        'Mélangez votre grille',
        ActionTiming.optional,
        ActionTarget.self,
        2,
      ),
      (
        ActionCardType.heal,
        'Soin',
        'Divisez par 2 le score d\'une colonne',
        ActionTiming.optional,
        ActionTarget.self,
        2,
      ),
    ];

    // Generate cards based on distribution
    var idCounter = 1;
    for (final (type, name, description, timing, target, count)
        in actionCardTypes) {
      for (int i = 0; i < count; i++) {
        cards.add({
          'id': 'action-${idCounter++}',
          'type': type.name,
          'name': name,
          'description': description,
          'timing': timing.name,
          'target': target.name,
          'parameters': {},
        });
      }
    }

    // Shuffle the deck
    cards.shuffle(_random);

    // Insert deck into database
    await _supabaseClient.from('decks').insert({
      'game_state_id': _gameStateId,
      'deck_type': 'action_cards',
      'cards': cards,
      'position': 0,
      'seed': _random.nextInt(1000000),
    }).select();
  }
}
