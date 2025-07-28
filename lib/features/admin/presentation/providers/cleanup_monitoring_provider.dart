import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cleanup_monitoring_data_simple.dart';

part 'cleanup_monitoring_provider.g.dart';

@riverpod
class CleanupMonitoring extends _$CleanupMonitoring {
  Timer? _refreshTimer;
  
  @override
  Future<CleanupMonitoringData> build() async {
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });
    
    return _fetchMonitoringData();
  }
  
  Future<CleanupMonitoringData> _fetchMonitoringData() async {
    final supabase = Supabase.instance.client;
    
    try {
      // Récupérer les statistiques via la fonction PostgreSQL
      final statusResponse = await supabase
          .rpc('get_cleanup_status')
          .single();
      
      // Récupérer les jobs CRON
      final cronJobsResponse = await supabase
          .from('cron.job')
          .select('jobname, schedule, active')
          .inFilter('jobname', [
            'cleanup-inactive-games',
            'periodic-connection-check',
            'reset-old-connections',
            'cleanup-old-logs'
          ]);
      
      return CleanupMonitoringData(
        activeRoomsCount: statusResponse['active_rooms_count'] ?? 0,
        inactiveRoomsCount: statusResponse['inactive_rooms_count'] ?? 0,
        connectedPlayersCount: statusResponse['connected_players_count'] ?? 0,
        disconnectedPlayersCount: statusResponse['disconnected_players_count'] ?? 0,
        lastCleanupTime: statusResponse['last_cleanup_time'] != null
            ? DateTime.parse(statusResponse['last_cleanup_time'])
            : null,
        cleanupErrorsLastHour: statusResponse['cleanup_errors_last_hour'] ?? 0,
        circuitBreakerActive: statusResponse['circuit_breaker_active'] ?? false,
        cronJobs: (cronJobsResponse as List).map((job) => CronJobInfo(
          jobName: job['jobname'],
          schedule: job['schedule'],
          active: job['active'],
        )).toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch monitoring data: $e');
    }
  }
  
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMonitoringData());
  }
  
  void startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      refresh();
    });
  }
  
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
  
  Future<void> forceCleanup() async {
    final supabase = Supabase.instance.client;
    
    try {
      // Exécuter la fonction de nettoyage manuellement
      await supabase.rpc('cleanup_inactive_games');
      
      // Rafraîchir les données
      await refresh();
    } catch (e) {
      throw Exception('Failed to force cleanup: $e');
    }
  }
}
