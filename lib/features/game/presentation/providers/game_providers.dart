import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game_state.dart';

// Provider for current game state
final gameStateNotifierProvider = StateProvider<GameState?>((ref) => null);