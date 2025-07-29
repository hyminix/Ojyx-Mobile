import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_health_metrics.freezed.dart';
part 'system_health_metrics.g.dart';

/// Métrique de tendance
enum TrendDirection {
  up,
  down,
  stable,
  unknown,
}

/// Métriques de santé du système multijoueur
@freezed
class SystemHealthMetrics with _$SystemHealthMetrics {
  const factory SystemHealthMetrics({
    // Erreurs de synchronisation
    required int syncErrors1h,
    required int syncErrors24h,
    required TrendDirection syncErrorsTrend,
    
    // Incohérences de données
    required int inconsistencies1h,
    required int inconsistencies24h,
    required TrendDirection inconsistenciesTrend,
    
    // Performance
    required double avgLatency,
    required double p95Latency,
    required TrendDirection latencyTrend,
    
    // Activité
    required int activePlayers,
    required int activeRooms,
    required int totalGamesStarted24h,
    
    // Fiabilité
    required double retryRate,
    required TrendDirection retryRateTrend,
    required double realtimeUptime,
    required double databaseUptime,
    
    // Connexions
    required int connectionErrors1h,
    required int timeouts1h,
    required double avgReconnectTime,
    
    // Capacité
    required double roomCapacityUtilization,
    required int maxConcurrentPlayers24h,
    required double peakLoadUtilization,
    
    // Timestamps
    required DateTime lastUpdated,
    required DateTime periodStart,
    required DateTime periodEnd,
    
    // Alertes actives
    required List<ActiveAlert> activeAlerts,
    
    // Score de santé global (0-100)
    required double healthScore,
  }) = _SystemHealthMetrics;
  
  factory SystemHealthMetrics.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthMetricsFromJson(json);
  
  /// Crée des métriques par défaut pour les tests
  factory SystemHealthMetrics.defaultValues() {
    final now = DateTime.now();
    return SystemHealthMetrics(
      syncErrors1h: 0,
      syncErrors24h: 0,
      syncErrorsTrend: TrendDirection.stable,
      inconsistencies1h: 0,
      inconsistencies24h: 0,
      inconsistenciesTrend: TrendDirection.stable,
      avgLatency: 50.0,
      p95Latency: 150.0,
      latencyTrend: TrendDirection.stable,
      activePlayers: 0,
      activeRooms: 0,
      totalGamesStarted24h: 0,
      retryRate: 2.0,
      retryRateTrend: TrendDirection.stable,
      realtimeUptime: 99.9,
      databaseUptime: 99.9,
      connectionErrors1h: 0,
      timeouts1h: 0,
      avgReconnectTime: 1.5,
      roomCapacityUtilization: 45.0,
      maxConcurrentPlayers24h: 0,
      peakLoadUtilization: 30.0,
      lastUpdated: now,
      periodStart: now.subtract(const Duration(hours: 24)),
      periodEnd: now,
      activeAlerts: [],
      healthScore: 95.0,
    );
  }
}

/// Alerte active dans le système
@freezed
class ActiveAlert with _$ActiveAlert {
  const factory ActiveAlert({
    required String id,
    required String title,
    required String description,
    required AlertSeverity severity,
    required DateTime triggeredAt,
    required String source,
    required Map<String, dynamic> context,
    String? roomId,
    String? playerId,
  }) = _ActiveAlert;
  
  factory ActiveAlert.fromJson(Map<String, dynamic> json) =>
      _$ActiveAlertFromJson(json);
}

/// Niveau de sévérité d'une alerte
enum AlertSeverity {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('critical')
  critical,
}

/// Données historiques pour les graphiques
@freezed
class HistoricalMetrics with _$HistoricalMetrics {
  const factory HistoricalMetrics({
    required List<TimeSeriesPoint> syncErrors,
    required List<TimeSeriesPoint> inconsistencies,
    required List<TimeSeriesPoint> latency,
    required List<TimeSeriesPoint> activePlayers,
    required List<TimeSeriesPoint> retryRate,
    required List<TimeSeriesPoint> uptime,
  }) = _HistoricalMetrics;
  
  factory HistoricalMetrics.fromJson(Map<String, dynamic> json) =>
      _$HistoricalMetricsFromJson(json);
}

/// Point dans une série temporelle
@freezed
class TimeSeriesPoint with _$TimeSeriesPoint {
  const factory TimeSeriesPoint({
    required DateTime timestamp,
    required double value,
    Map<String, dynamic>? metadata,
  }) = _TimeSeriesPoint;
  
  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesPointFromJson(json);
}

/// Extensions pour les métriques
extension SystemHealthMetricsX on SystemHealthMetrics {
  /// Détermine si le système est en bonne santé
  bool get isHealthy => healthScore >= 80.0;
  
  /// Détermine si le système a des problèmes
  bool get hasIssues => healthScore < 80.0;
  
  /// Détermine si le système est en état critique
  bool get isCritical => healthScore < 50.0;
  
  /// Couleur associée au score de santé
  String get healthColor {
    if (healthScore >= 90) return '#4CAF50'; // Vert
    if (healthScore >= 70) return '#FF9800'; // Orange
    if (healthScore >= 50) return '#F44336'; // Rouge
    return '#9C27B0'; // Violet pour critique
  }
  
  /// Nombre total d'alertes critiques
  int get criticalAlertsCount => activeAlerts
      .where((alert) => alert.severity == AlertSeverity.critical)
      .length;
  
  /// Nombre total d'alertes haute priorité
  int get highPriorityAlertsCount => activeAlerts
      .where((alert) => 
          alert.severity == AlertSeverity.high || 
          alert.severity == AlertSeverity.critical)
      .length;
  
  /// Taux d'erreur total (pourcentage)
  double get totalErrorRate {
    final totalEvents = syncErrors1h + inconsistencies1h + connectionErrors1h;
    if (totalEvents == 0) return 0.0;
    
    // Calcul basé sur une estimation du volume total d'événements
    final estimatedTotalEvents = activePlayers * 10; // Estimation simple
    if (estimatedTotalEvents == 0) return 0.0;
    
    return (totalEvents / estimatedTotalEvents) * 100;
  }
  
  /// Indicateur de performance globale
  String get performanceIndicator {
    if (avgLatency < 100 && p95Latency < 300) return 'Excellent';
    if (avgLatency < 200 && p95Latency < 500) return 'Good';
    if (avgLatency < 500 && p95Latency < 1000) return 'Fair';
    return 'Poor';
  }
  
  /// Statut de la connectivité
  String get connectivityStatus {
    if (realtimeUptime > 99.5 && databaseUptime > 99.5) return 'Excellent';
    if (realtimeUptime > 99.0 && databaseUptime > 99.0) return 'Good';
    if (realtimeUptime > 98.0 && databaseUptime > 98.0) return 'Fair';
    return 'Poor';
  }
  
  /// Recommandations basées sur les métriques
  List<String> get recommendations {
    final recommendations = <String>[];
    
    if (syncErrors1h > 10) {
      recommendations.add('Investiguer les erreurs de synchronisation fréquentes');
    }
    
    if (inconsistencies1h > 5) {
      recommendations.add('Vérifier la cohérence des données en base');
    }
    
    if (avgLatency > 300) {
      recommendations.add('Optimiser les performances réseau');
    }
    
    if (retryRate > 10) {
      recommendations.add('Analyser les causes des échecs de retry');
    }
    
    if (realtimeUptime < 99.0) {
      recommendations.add('Vérifier la stabilité de la connexion temps réel');
    }
    
    if (roomCapacityUtilization > 80) {
      recommendations.add('Considérer l\'augmentation de la capacité des rooms');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Système en bon état, continuer la surveillance');
    }
    
    return recommendations;
  }
}

/// Extensions pour les alertes
extension ActiveAlertX on ActiveAlert {
  /// Âge de l'alerte
  Duration get age => DateTime.now().difference(triggeredAt);
  
  /// L'alerte est-elle récente (< 1 heure)
  bool get isRecent => age.inHours < 1;
  
  /// L'alerte est-elle ancienne (> 24 heures)
  bool get isStale => age.inHours > 24;
  
  /// Couleur associée à la sévérité
  String get severityColor {
    switch (severity) {
      case AlertSeverity.low:
        return '#4CAF50'; // Vert
      case AlertSeverity.medium:
        return '#FF9800'; // Orange
      case AlertSeverity.high:
        return '#F44336'; // Rouge
      case AlertSeverity.critical:
        return '#9C27B0'; // Violet
    }
  }
  
  /// Icône associée à la sévérité
  String get severityIcon {
    switch (severity) {
      case AlertSeverity.low:
        return 'info';
      case AlertSeverity.medium:
        return 'warning';
      case AlertSeverity.high:
        return 'error';
      case AlertSeverity.critical:
        return 'dangerous';
    }
  }
}