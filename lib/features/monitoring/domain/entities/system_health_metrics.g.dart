// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_health_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SystemHealthMetrics _$SystemHealthMetricsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_SystemHealthMetrics',
  json,
  ($checkedConvert) {
    final val = _SystemHealthMetrics(
      syncErrors1h: $checkedConvert('sync_errors1h', (v) => (v as num).toInt()),
      syncErrors24h: $checkedConvert(
        'sync_errors24h',
        (v) => (v as num).toInt(),
      ),
      syncErrorsTrend: $checkedConvert(
        'sync_errors_trend',
        (v) => $enumDecode(_$TrendDirectionEnumMap, v),
      ),
      inconsistencies1h: $checkedConvert(
        'inconsistencies1h',
        (v) => (v as num).toInt(),
      ),
      inconsistencies24h: $checkedConvert(
        'inconsistencies24h',
        (v) => (v as num).toInt(),
      ),
      inconsistenciesTrend: $checkedConvert(
        'inconsistencies_trend',
        (v) => $enumDecode(_$TrendDirectionEnumMap, v),
      ),
      avgLatency: $checkedConvert('avg_latency', (v) => (v as num).toDouble()),
      p95Latency: $checkedConvert('p95_latency', (v) => (v as num).toDouble()),
      latencyTrend: $checkedConvert(
        'latency_trend',
        (v) => $enumDecode(_$TrendDirectionEnumMap, v),
      ),
      activePlayers: $checkedConvert(
        'active_players',
        (v) => (v as num).toInt(),
      ),
      activeRooms: $checkedConvert('active_rooms', (v) => (v as num).toInt()),
      totalGamesStarted24h: $checkedConvert(
        'total_games_started24h',
        (v) => (v as num).toInt(),
      ),
      retryRate: $checkedConvert('retry_rate', (v) => (v as num).toDouble()),
      retryRateTrend: $checkedConvert(
        'retry_rate_trend',
        (v) => $enumDecode(_$TrendDirectionEnumMap, v),
      ),
      realtimeUptime: $checkedConvert(
        'realtime_uptime',
        (v) => (v as num).toDouble(),
      ),
      databaseUptime: $checkedConvert(
        'database_uptime',
        (v) => (v as num).toDouble(),
      ),
      connectionErrors1h: $checkedConvert(
        'connection_errors1h',
        (v) => (v as num).toInt(),
      ),
      timeouts1h: $checkedConvert('timeouts1h', (v) => (v as num).toInt()),
      avgReconnectTime: $checkedConvert(
        'avg_reconnect_time',
        (v) => (v as num).toDouble(),
      ),
      roomCapacityUtilization: $checkedConvert(
        'room_capacity_utilization',
        (v) => (v as num).toDouble(),
      ),
      maxConcurrentPlayers24h: $checkedConvert(
        'max_concurrent_players24h',
        (v) => (v as num).toInt(),
      ),
      peakLoadUtilization: $checkedConvert(
        'peak_load_utilization',
        (v) => (v as num).toDouble(),
      ),
      lastUpdated: $checkedConvert(
        'last_updated',
        (v) => DateTime.parse(v as String),
      ),
      periodStart: $checkedConvert(
        'period_start',
        (v) => DateTime.parse(v as String),
      ),
      periodEnd: $checkedConvert(
        'period_end',
        (v) => DateTime.parse(v as String),
      ),
      activeAlerts: $checkedConvert(
        'active_alerts',
        (v) => (v as List<dynamic>)
            .map((e) => ActiveAlert.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      healthScore: $checkedConvert(
        'health_score',
        (v) => (v as num).toDouble(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'syncErrors1h': 'sync_errors1h',
    'syncErrors24h': 'sync_errors24h',
    'syncErrorsTrend': 'sync_errors_trend',
    'inconsistenciesTrend': 'inconsistencies_trend',
    'avgLatency': 'avg_latency',
    'p95Latency': 'p95_latency',
    'latencyTrend': 'latency_trend',
    'activePlayers': 'active_players',
    'activeRooms': 'active_rooms',
    'totalGamesStarted24h': 'total_games_started24h',
    'retryRate': 'retry_rate',
    'retryRateTrend': 'retry_rate_trend',
    'realtimeUptime': 'realtime_uptime',
    'databaseUptime': 'database_uptime',
    'connectionErrors1h': 'connection_errors1h',
    'avgReconnectTime': 'avg_reconnect_time',
    'roomCapacityUtilization': 'room_capacity_utilization',
    'maxConcurrentPlayers24h': 'max_concurrent_players24h',
    'peakLoadUtilization': 'peak_load_utilization',
    'lastUpdated': 'last_updated',
    'periodStart': 'period_start',
    'periodEnd': 'period_end',
    'activeAlerts': 'active_alerts',
    'healthScore': 'health_score',
  },
);

Map<String, dynamic> _$SystemHealthMetricsToJson(
  _SystemHealthMetrics instance,
) => <String, dynamic>{
  'sync_errors1h': instance.syncErrors1h,
  'sync_errors24h': instance.syncErrors24h,
  'sync_errors_trend': _$TrendDirectionEnumMap[instance.syncErrorsTrend]!,
  'inconsistencies1h': instance.inconsistencies1h,
  'inconsistencies24h': instance.inconsistencies24h,
  'inconsistencies_trend':
      _$TrendDirectionEnumMap[instance.inconsistenciesTrend]!,
  'avg_latency': instance.avgLatency,
  'p95_latency': instance.p95Latency,
  'latency_trend': _$TrendDirectionEnumMap[instance.latencyTrend]!,
  'active_players': instance.activePlayers,
  'active_rooms': instance.activeRooms,
  'total_games_started24h': instance.totalGamesStarted24h,
  'retry_rate': instance.retryRate,
  'retry_rate_trend': _$TrendDirectionEnumMap[instance.retryRateTrend]!,
  'realtime_uptime': instance.realtimeUptime,
  'database_uptime': instance.databaseUptime,
  'connection_errors1h': instance.connectionErrors1h,
  'timeouts1h': instance.timeouts1h,
  'avg_reconnect_time': instance.avgReconnectTime,
  'room_capacity_utilization': instance.roomCapacityUtilization,
  'max_concurrent_players24h': instance.maxConcurrentPlayers24h,
  'peak_load_utilization': instance.peakLoadUtilization,
  'last_updated': instance.lastUpdated.toIso8601String(),
  'period_start': instance.periodStart.toIso8601String(),
  'period_end': instance.periodEnd.toIso8601String(),
  'active_alerts': instance.activeAlerts.map((e) => e.toJson()).toList(),
  'health_score': instance.healthScore,
};

const _$TrendDirectionEnumMap = {
  TrendDirection.up: 'up',
  TrendDirection.down: 'down',
  TrendDirection.stable: 'stable',
  TrendDirection.unknown: 'unknown',
};

_ActiveAlert _$ActiveAlertFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ActiveAlert',
  json,
  ($checkedConvert) {
    final val = _ActiveAlert(
      id: $checkedConvert('id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String),
      description: $checkedConvert('description', (v) => v as String),
      severity: $checkedConvert(
        'severity',
        (v) => $enumDecode(_$AlertSeverityEnumMap, v),
      ),
      triggeredAt: $checkedConvert(
        'triggered_at',
        (v) => DateTime.parse(v as String),
      ),
      source: $checkedConvert('source', (v) => v as String),
      context: $checkedConvert('context', (v) => v as Map<String, dynamic>),
      roomId: $checkedConvert('room_id', (v) => v as String?),
      playerId: $checkedConvert('player_id', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'triggeredAt': 'triggered_at',
    'roomId': 'room_id',
    'playerId': 'player_id',
  },
);

Map<String, dynamic> _$ActiveAlertToJson(_ActiveAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
      'triggered_at': instance.triggeredAt.toIso8601String(),
      'source': instance.source,
      'context': instance.context,
      'room_id': instance.roomId,
      'player_id': instance.playerId,
    };

const _$AlertSeverityEnumMap = {
  AlertSeverity.low: 'low',
  AlertSeverity.medium: 'medium',
  AlertSeverity.high: 'high',
  AlertSeverity.critical: 'critical',
};

_HistoricalMetrics _$HistoricalMetricsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_HistoricalMetrics',
      json,
      ($checkedConvert) {
        final val = _HistoricalMetrics(
          syncErrors: $checkedConvert(
            'sync_errors',
            (v) => (v as List<dynamic>)
                .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          inconsistencies: $checkedConvert(
            'inconsistencies',
            (v) => (v as List<dynamic>)
                .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          latency: $checkedConvert(
            'latency',
            (v) => (v as List<dynamic>)
                .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          activePlayers: $checkedConvert(
            'active_players',
            (v) => (v as List<dynamic>)
                .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          retryRate: $checkedConvert(
            'retry_rate',
            (v) => (v as List<dynamic>)
                .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          uptime: $checkedConvert(
            'uptime',
            (v) => (v as List<dynamic>)
                .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'syncErrors': 'sync_errors',
        'activePlayers': 'active_players',
        'retryRate': 'retry_rate',
      },
    );

Map<String, dynamic> _$HistoricalMetricsToJson(
  _HistoricalMetrics instance,
) => <String, dynamic>{
  'sync_errors': instance.syncErrors.map((e) => e.toJson()).toList(),
  'inconsistencies': instance.inconsistencies.map((e) => e.toJson()).toList(),
  'latency': instance.latency.map((e) => e.toJson()).toList(),
  'active_players': instance.activePlayers.map((e) => e.toJson()).toList(),
  'retry_rate': instance.retryRate.map((e) => e.toJson()).toList(),
  'uptime': instance.uptime.map((e) => e.toJson()).toList(),
};

_TimeSeriesPoint _$TimeSeriesPointFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TimeSeriesPoint', json, ($checkedConvert) {
  final val = _TimeSeriesPoint(
    timestamp: $checkedConvert('timestamp', (v) => DateTime.parse(v as String)),
    value: $checkedConvert('value', (v) => (v as num).toDouble()),
    metadata: $checkedConvert('metadata', (v) => v as Map<String, dynamic>?),
  );
  return val;
});

Map<String, dynamic> _$TimeSeriesPointToJson(_TimeSeriesPoint instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'value': instance.value,
      'metadata': instance.metadata,
    };
