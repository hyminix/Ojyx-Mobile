import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/optimistic_action.dart';
import '../../domain/entities/optimistic_actions.dart';

part 'optimistic_action_storage.g.dart';

/// Service de stockage local pour les actions optimistes en attente
@riverpod
OptimisticActionStorage optimisticActionStorage(OptimisticActionStorageRef ref) {
  return OptimisticActionStorage();
}

class OptimisticActionStorage {
  static const String _storageKey = 'pending_optimistic_actions';
  static const String _metadataKey = 'optimistic_actions_metadata';
  
  /// Sauvegarde une action en attente
  Future<void> savePendingAction(OptimisticAction action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Charger les actions existantes
      final existingJson = prefs.getStringList(_storageKey) ?? [];
      
      // Ajouter la nouvelle action
      final actionJson = jsonEncode({
        ...action.toJson(),
        '_type': action.runtimeType.toString(),
      });
      
      existingJson.add(actionJson);
      
      // Sauvegarder
      await prefs.setStringList(_storageKey, existingJson);
      
      // Mettre à jour les métadonnées
      await _updateMetadata(existingJson.length);
      
      debugPrint('OptimisticActionStorage: Saved action ${action.id}');
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error saving action - $e');
    }
  }
  
  /// Supprime une action spécifique
  Future<void> removePendingAction(String actionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingJson = prefs.getStringList(_storageKey) ?? [];
      
      // Filtrer l'action à supprimer
      final filtered = existingJson.where((json) {
        try {
          final decoded = jsonDecode(json);
          return decoded['id'] != actionId;
        } catch (_) {
          return true;
        }
      }).toList();
      
      // Sauvegarder la liste filtrée
      await prefs.setStringList(_storageKey, filtered);
      
      // Mettre à jour les métadonnées
      await _updateMetadata(filtered.length);
      
      debugPrint('OptimisticActionStorage: Removed action $actionId');
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error removing action - $e');
    }
  }
  
  /// Charge toutes les actions en attente
  Future<List<OptimisticAction>> loadPendingActions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_storageKey) ?? [];
      
      final actions = <OptimisticAction>[];
      
      for (final json in jsonList) {
        try {
          final decoded = jsonDecode(json);
          final action = _deserializeAction(decoded);
          
          if (action != null) {
            actions.add(action);
          }
        } catch (e) {
          debugPrint('OptimisticActionStorage: Error deserializing action - $e');
        }
      }
      
      debugPrint('OptimisticActionStorage: Loaded ${actions.length} pending actions');
      return actions;
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error loading actions - $e');
      return [];
    }
  }
  
  /// Supprime toutes les actions en attente
  Future<void> clearAllPendingActions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      await prefs.remove(_metadataKey);
      
      debugPrint('OptimisticActionStorage: Cleared all pending actions');
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error clearing actions - $e');
    }
  }
  
  /// Obtient le nombre d'actions en attente
  Future<int> getPendingActionsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadata = prefs.getString(_metadataKey);
      
      if (metadata != null) {
        final decoded = jsonDecode(metadata);
        return decoded['count'] ?? 0;
      }
      
      // Fallback: compter directement
      final actions = prefs.getStringList(_storageKey) ?? [];
      return actions.length;
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error getting count - $e');
      return 0;
    }
  }
  
  /// Supprime les actions expirées (plus de 24h)
  Future<void> cleanupExpiredActions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingJson = prefs.getStringList(_storageKey) ?? [];
      final now = DateTime.now();
      
      final filtered = existingJson.where((json) {
        try {
          final decoded = jsonDecode(json);
          final timestamp = DateTime.parse(decoded['timestamp']);
          final age = now.difference(timestamp);
          
          // Garder les actions de moins de 24h
          return age.inHours < 24;
        } catch (_) {
          return false; // Supprimer les actions invalides
        }
      }).toList();
      
      if (filtered.length != existingJson.length) {
        await prefs.setStringList(_storageKey, filtered);
        await _updateMetadata(filtered.length);
        
        debugPrint('OptimisticActionStorage: Cleaned up ${existingJson.length - filtered.length} expired actions');
      }
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error cleaning up - $e');
    }
  }
  
  /// Désérialise une action depuis JSON
  OptimisticAction? _deserializeAction(Map<String, dynamic> json) {
    try {
      final type = json['_type'] ?? json['type'];
      
      switch (type) {
        case 'RevealCardAction':
        case 'reveal_card':
          return RevealCardAction(
            id: json['id'],
            timestamp: DateTime.parse(json['timestamp']),
            playerId: json['playerId'],
            row: json['row'],
            col: json['col'],
            retryCount: json['retryCount'] ?? 0,
          );
          
        case 'PlayActionCardAction':
        case 'play_action_card':
          return PlayActionCardAction(
            id: json['id'],
            timestamp: DateTime.parse(json['timestamp']),
            playerId: json['playerId'],
            actionCard: ActionCard.fromJson(json['actionCard']),
            actionData: json['actionData'],
            targetPlayerId: json['targetPlayerId'],
            retryCount: json['retryCount'] ?? 0,
          );
          
        case 'EndTurnAction':
        case 'end_turn':
          return EndTurnAction(
            id: json['id'],
            timestamp: DateTime.parse(json['timestamp']),
            playerId: json['playerId'],
            hasDrawnCard: json['hasDrawnCard'],
            retryCount: json['retryCount'] ?? 0,
          );
          
        default:
          debugPrint('OptimisticActionStorage: Unknown action type - $type');
          return null;
      }
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error deserializing action - $e');
      return null;
    }
  }
  
  /// Met à jour les métadonnées
  Future<void> _updateMetadata(int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadata = {
        'count': count,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString(_metadataKey, jsonEncode(metadata));
    } catch (e) {
      debugPrint('OptimisticActionStorage: Error updating metadata - $e');
    }
  }
}