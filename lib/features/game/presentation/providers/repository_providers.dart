import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../data/repositories/server_action_card_repository.dart';
import '../../data/repositories/supabase_game_state_repository.dart';
import '../../domain/repositories/action_card_repository.dart';
import '../../domain/repositories/game_state_repository.dart';

part 'repository_providers.g.dart';

@riverpod
GameStateRepository gameStateRepository(GameStateRepositoryRef ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseGameStateRepository(supabaseClient);
}

@riverpod
ActionCardRepository serverActionCardRepository(
  ServerActionCardRepositoryRef ref,
) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return ServerActionCardRepository(supabaseClient);
}
