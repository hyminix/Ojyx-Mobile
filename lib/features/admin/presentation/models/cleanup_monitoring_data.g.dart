// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleanup_monitoring_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CleanupMonitoringData _$CleanupMonitoringDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_CleanupMonitoringData',
  json,
  ($checkedConvert) {
    final val = _CleanupMonitoringData(
      activeRoomsCount: $checkedConvert(
        'active_rooms_count',
        (v) => (v as num).toInt(),
      ),
      inactiveRoomsCount: $checkedConvert(
        'inactive_rooms_count',
        (v) => (v as num).toInt(),
      ),
      connectedPlayersCount: $checkedConvert(
        'connected_players_count',
        (v) => (v as num).toInt(),
      ),
      disconnectedPlayersCount: $checkedConvert(
        'disconnected_players_count',
        (v) => (v as num).toInt(),
      ),
      lastCleanupTime: $checkedConvert(
        'last_cleanup_time',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      cleanupErrorsLastHour: $checkedConvert(
        'cleanup_errors_last_hour',
        (v) => (v as num).toInt(),
      ),
      circuitBreakerActive: $checkedConvert(
        'circuit_breaker_active',
        (v) => v as bool,
      ),
      cronJobs: $checkedConvert(
        'cron_jobs',
        (v) => (v as List<dynamic>)
            .map((e) => CronJobInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'activeRoomsCount': 'active_rooms_count',
    'inactiveRoomsCount': 'inactive_rooms_count',
    'connectedPlayersCount': 'connected_players_count',
    'disconnectedPlayersCount': 'disconnected_players_count',
    'lastCleanupTime': 'last_cleanup_time',
    'cleanupErrorsLastHour': 'cleanup_errors_last_hour',
    'circuitBreakerActive': 'circuit_breaker_active',
    'cronJobs': 'cron_jobs',
  },
);

Map<String, dynamic> _$CleanupMonitoringDataToJson(
  _CleanupMonitoringData instance,
) => <String, dynamic>{
  'active_rooms_count': instance.activeRoomsCount,
  'inactive_rooms_count': instance.inactiveRoomsCount,
  'connected_players_count': instance.connectedPlayersCount,
  'disconnected_players_count': instance.disconnectedPlayersCount,
  'last_cleanup_time': instance.lastCleanupTime?.toIso8601String(),
  'cleanup_errors_last_hour': instance.cleanupErrorsLastHour,
  'circuit_breaker_active': instance.circuitBreakerActive,
  'cron_jobs': instance.cronJobs.map((e) => e.toJson()).toList(),
};

_CronJobInfo _$CronJobInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_CronJobInfo', json, ($checkedConvert) {
      final val = _CronJobInfo(
        jobName: $checkedConvert('job_name', (v) => v as String),
        schedule: $checkedConvert('schedule', (v) => v as String),
        active: $checkedConvert('active', (v) => v as bool),
      );
      return val;
    }, fieldKeyMap: const {'jobName': 'job_name'});

Map<String, dynamic> _$CronJobInfoToJson(_CronJobInfo instance) =>
    <String, dynamic>{
      'job_name': instance.jobName,
      'schedule': instance.schedule,
      'active': instance.active,
    };
