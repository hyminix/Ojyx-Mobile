// Version simplifiée sans Freezed pour contourner le problème de génération
class CleanupMonitoringData {
  final int activeRoomsCount;
  final int inactiveRoomsCount;
  final int connectedPlayersCount;
  final int disconnectedPlayersCount;
  final DateTime? lastCleanupTime;
  final int cleanupErrorsLastHour;
  final bool circuitBreakerActive;
  final List<CronJobInfo> cronJobs;

  const CleanupMonitoringData({
    required this.activeRoomsCount,
    required this.inactiveRoomsCount,
    required this.connectedPlayersCount,
    required this.disconnectedPlayersCount,
    this.lastCleanupTime,
    required this.cleanupErrorsLastHour,
    required this.circuitBreakerActive,
    required this.cronJobs,
  });

  factory CleanupMonitoringData.fromJson(Map<String, dynamic> json) {
    return CleanupMonitoringData(
      activeRoomsCount: json['activeRoomsCount'] ?? 0,
      inactiveRoomsCount: json['inactiveRoomsCount'] ?? 0,
      connectedPlayersCount: json['connectedPlayersCount'] ?? 0,
      disconnectedPlayersCount: json['disconnectedPlayersCount'] ?? 0,
      lastCleanupTime: json['lastCleanupTime'] != null
          ? DateTime.parse(json['lastCleanupTime'])
          : null,
      cleanupErrorsLastHour: json['cleanupErrorsLastHour'] ?? 0,
      circuitBreakerActive: json['circuitBreakerActive'] ?? false,
      cronJobs: (json['cronJobs'] as List? ?? [])
          .map((e) => CronJobInfo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeRoomsCount': activeRoomsCount,
      'inactiveRoomsCount': inactiveRoomsCount,
      'connectedPlayersCount': connectedPlayersCount,
      'disconnectedPlayersCount': disconnectedPlayersCount,
      'lastCleanupTime': lastCleanupTime?.toIso8601String(),
      'cleanupErrorsLastHour': cleanupErrorsLastHour,
      'circuitBreakerActive': circuitBreakerActive,
      'cronJobs': cronJobs.map((e) => e.toJson()).toList(),
    };
  }
}

class CronJobInfo {
  final String jobName;
  final String schedule;
  final bool active;

  const CronJobInfo({
    required this.jobName,
    required this.schedule,
    required this.active,
  });

  factory CronJobInfo.fromJson(Map<String, dynamic> json) {
    return CronJobInfo(
      jobName: json['jobName'] ?? '',
      schedule: json['schedule'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobName': jobName,
      'schedule': schedule,
      'active': active,
    };
  }
}