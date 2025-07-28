import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../multiplayer/domain/entities/room.dart';
import '../../../multiplayer/data/models/room_model.dart';

part 'available_rooms_provider.g.dart';

/// Provider qui maintient une liste en temps réel des parties disponibles
@riverpod
class AvailableRoomsNotifier extends _$AvailableRoomsNotifier {
  StreamSubscription? _roomsSubscription;
  final _supabase = Supabase.instance.client;
  
  // Batching pour optimiser les mises à jour
  Timer? _batchTimer;
  final Set<String> _pendingRoomUpdates = {};
  final Set<String> _pendingPlayerUpdates = {};
  static const _batchDelay = Duration(milliseconds: 100);
  
  @override
  Future<List<Room>> build() async {
    // Nettoyer les subscriptions précédentes
    ref.onDispose(() {
      _roomsSubscription?.cancel();
      _batchTimer?.cancel();
    });
    
    // Charger la liste initiale
    final initialRooms = await _loadAvailableRooms();
    
    // Établir la subscription temps réel
    _setupRealtimeSubscription();
    
    return initialRooms;
  }
  
  /// Charge la liste initiale des rooms disponibles avec le nombre de joueurs
  Future<List<Room>> _loadAvailableRooms() async {
    try {
      // Récupérer les rooms en attente
      final roomsResponse = await _supabase
          .from('rooms')
          .select()
          .eq('status', 'waiting')
          .order('created_at', ascending: false);
      
      final rooms = <Room>[];
      
      // Pour chaque room, compter les joueurs
      for (final roomJson in (roomsResponse as List<dynamic>).cast<Map<String, dynamic>>()) {
        final playersCount = await _supabase
            .from('players')
            .select('id')
            .eq('current_room_id', roomJson['id'])
            .count(CountOption.exact);
        
        // Enrichir les données de la room avec le nombre de joueurs
        final enrichedRoom = <String, dynamic>{
          ...roomJson,
          'current_players': playersCount.count ?? 0,
        };
        
        rooms.add(RoomModel.fromJson(enrichedRoom).toDomain());
      }
      
      return rooms;
    } catch (e) {
      throw Exception('Failed to load available rooms: $e');
    }
  }
  
  /// Configure la subscription temps réel sur la table rooms
  void _setupRealtimeSubscription() {
    // Créer un channel pour écouter les changements
    final channel = _supabase.channel('available-rooms');
    
    // Écouter les INSERT de nouvelles rooms
    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'rooms',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'status',
        value: 'waiting',
      ),
      callback: (payload) {
        _handleRoomInsert(payload.newRecord);
      },
    );
    
    // Écouter les UPDATE sur les rooms
    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'rooms',
      callback: (payload) {
        _handleRoomUpdate(payload.oldRecord, payload.newRecord);
      },
    );
    
    // Écouter les DELETE de rooms
    channel.onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'rooms',
      callback: (payload) {
        _handleRoomDelete(payload.oldRecord);
      },
    );
    
    // Écouter aussi les changements sur la table players
    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'players',
      callback: (payload) {
        // Recharger la room concernée si elle est dans notre liste
        _handlePlayerChange(payload);
      },
    );
    
    // S'abonner au channel
    channel.subscribe();
  }
  
  /// Gère l'insertion d'une nouvelle room
  void _handleRoomInsert(Map<String, dynamic> newRoom) {
    if (newRoom['status'] != 'waiting') return;
    
    final roomId = newRoom['id'] as String;
    _pendingRoomUpdates.add(roomId);
    _scheduleBatchUpdate();
  }
  
  /// Gère la mise à jour d'une room
  void _handleRoomUpdate(
    Map<String, dynamic> oldRoom,
    Map<String, dynamic> newRoom,
  ) {
    final roomId = newRoom['id'] as String;
    _pendingRoomUpdates.add(roomId);
    _scheduleBatchUpdate();
  }
  
  /// Gère la suppression d'une room
  void _handleRoomDelete(Map<String, dynamic> oldRoom) {
    final roomId = oldRoom['id'] as String;
    _pendingRoomUpdates.add(roomId);
    _scheduleBatchUpdate();
  }
  
  /// Gère les changements sur la table players
  void _handlePlayerChange(PostgresChangePayload payload) {
    // Extraire le room_id concerné
    String? roomId;
    if (payload.eventType == PostgresChangeEvent.insert || 
        payload.eventType == PostgresChangeEvent.update) {
      roomId = payload.newRecord['current_room_id'];
    } else if (payload.eventType == PostgresChangeEvent.delete) {
      roomId = payload.oldRecord['current_room_id'];
    }
    
    if (roomId == null) return;
    
    // Vérifier si cette room est dans notre liste
    final rooms = state.value ?? [];
    final roomExists = rooms.any((r) => r.id == roomId);
    if (!roomExists) return;
    
    _pendingPlayerUpdates.add(roomId);
    _scheduleBatchUpdate();
  }
  
  /// Programme une mise à jour batch
  void _scheduleBatchUpdate() {
    _batchTimer?.cancel();
    _batchTimer = Timer(_batchDelay, _processBatchUpdates);
  }
  
  /// Traite toutes les mises à jour en attente en une seule fois
  Future<void> _processBatchUpdates() async {
    if (_pendingRoomUpdates.isEmpty && _pendingPlayerUpdates.isEmpty) return;
    
    final rooms = state.value ?? [];
    final updatedRooms = <Room>[];
    final roomsToRemove = <String>{};
    final roomsToAdd = <String>{};
    
    try {
      // Traiter les mises à jour de rooms
      if (_pendingRoomUpdates.isNotEmpty) {
        final roomIds = _pendingRoomUpdates.toList();
        _pendingRoomUpdates.clear();
        
        // Récupérer toutes les rooms mises à jour en une seule requête
        final roomsResponse = await _supabase
            .from('rooms')
            .select()
            .inFilter('id', roomIds);
        
        for (final roomData in (roomsResponse as List<dynamic>).cast<Map<String, dynamic>>()) {
          final roomId = roomData['id'] as String;
          final status = roomData['status'] as String;
          
          if (status == 'waiting') {
            // Room à ajouter ou mettre à jour
            roomsToAdd.add(roomId);
            
            // Compter les joueurs pour cette room
            final playersCount = await _supabase
                .from('players')
                .select('id')
                .eq('current_room_id', roomId)
                .count(CountOption.exact);
            
            final enrichedRoom = <String, dynamic>{
              ...roomData,
              'current_players': playersCount.count ?? 0,
            };
            
            updatedRooms.add(RoomModel.fromJson(enrichedRoom).toDomain());
          } else {
            // Room à retirer
            roomsToRemove.add(roomId);
          }
        }
        
        // Gérer les rooms supprimées (qui ne sont plus dans la réponse)
        for (final roomId in roomIds) {
          if (!roomsToAdd.contains(roomId)) {
            roomsToRemove.add(roomId);
          }
        }
      }
      
      // Traiter les mises à jour de joueurs
      if (_pendingPlayerUpdates.isNotEmpty) {
        final playerRoomIds = _pendingPlayerUpdates.toList();
        _pendingPlayerUpdates.clear();
        
        // Récupérer les rooms affectées avec leur nombre de joueurs
        for (final roomId in playerRoomIds) {
          if (roomsToRemove.contains(roomId) || roomsToAdd.contains(roomId)) {
            // Cette room est déjà traitée
            continue;
          }
          
          final roomResponse = await _supabase
              .from('rooms')
              .select()
              .eq('id', roomId)
              .single();
          
          final playersCount = await _supabase
              .from('players')
              .select('id')
              .eq('current_room_id', roomId)
              .count(CountOption.exact);
          
          final enrichedRoom = <String, dynamic>{
            ...roomResponse,
            'current_players': playersCount.count ?? 0,
          };
          
          updatedRooms.add(RoomModel.fromJson(enrichedRoom).toDomain());
        }
      }
      
      // Construire la nouvelle liste de rooms
      final newRooms = <Room>[];
      
      // Conserver les rooms existantes non modifiées
      for (final room in rooms) {
        if (!roomsToRemove.contains(room.id) && 
            !roomsToAdd.contains(room.id) &&
            !_pendingPlayerUpdates.contains(room.id)) {
          newRooms.add(room);
        }
      }
      
      // Ajouter les rooms mises à jour
      newRooms.addAll(updatedRooms);
      
      // Trier par date de création (plus récentes en premier)
      newRooms.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      
      // Mettre à jour l'état une seule fois
      state = AsyncData(newRooms);
    } catch (e) {
      // En cas d'erreur, ne pas crasher
      // TODO: Logger l'erreur avec Sentry
    }
  }
  
  /// Force le rechargement complet de la liste
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadAvailableRooms());
  }
}
