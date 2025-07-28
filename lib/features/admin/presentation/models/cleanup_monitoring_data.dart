import 'package:freezed_annotation/freezed_annotation.dart';

part 'cleanup_monitoring_data.freezed.dart';
part 'cleanup_monitoring_data.g.dart';

@freezed
class CleanupMonitoringData with _$CleanupMonitoringData {
  const factory CleanupMonitoringData({
    required int activeRoomsCount,
    required int inactiveRoomsCount,
    required int connectedPlayersCount,
    required int disconnectedPlayersCount,
    DateTime? lastCleanupTime,
    required int cleanupErrorsLastHour,
    required bool circuitBreakerActive,
    required List<CronJobInfo> cronJobs,
  }) = _CleanupMonitoringData;

  factory CleanupMonitoringData.fromJson(Map<String, dynamic> json) =>
      _$CleanupMonitoringDataFromJson(json);
}

@freezed
class CronJobInfo with _$CronJobInfo {
  const factory CronJobInfo({
    required String jobName,
    required String schedule,
    required bool active,
  }) = _CronJobInfo;

  factory CronJobInfo.fromJson(Map<String, dynamic> json) =>
      _$CronJobInfoFromJson(json);
}
