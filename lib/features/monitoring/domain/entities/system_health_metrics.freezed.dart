// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_health_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemHealthMetrics {

// Erreurs de synchronisation
 int get syncErrors1h; int get syncErrors24h; TrendDirection get syncErrorsTrend;// Incohérences de données
 int get inconsistencies1h; int get inconsistencies24h; TrendDirection get inconsistenciesTrend;// Performance
 double get avgLatency; double get p95Latency; TrendDirection get latencyTrend;// Activité
 int get activePlayers; int get activeRooms; int get totalGamesStarted24h;// Fiabilité
 double get retryRate; TrendDirection get retryRateTrend; double get realtimeUptime; double get databaseUptime;// Connexions
 int get connectionErrors1h; int get timeouts1h; double get avgReconnectTime;// Capacité
 double get roomCapacityUtilization; int get maxConcurrentPlayers24h; double get peakLoadUtilization;// Timestamps
 DateTime get lastUpdated; DateTime get periodStart; DateTime get periodEnd;// Alertes actives
 List<ActiveAlert> get activeAlerts;// Score de santé global (0-100)
 double get healthScore;
/// Create a copy of SystemHealthMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemHealthMetricsCopyWith<SystemHealthMetrics> get copyWith => _$SystemHealthMetricsCopyWithImpl<SystemHealthMetrics>(this as SystemHealthMetrics, _$identity);

  /// Serializes this SystemHealthMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemHealthMetrics&&(identical(other.syncErrors1h, syncErrors1h) || other.syncErrors1h == syncErrors1h)&&(identical(other.syncErrors24h, syncErrors24h) || other.syncErrors24h == syncErrors24h)&&(identical(other.syncErrorsTrend, syncErrorsTrend) || other.syncErrorsTrend == syncErrorsTrend)&&(identical(other.inconsistencies1h, inconsistencies1h) || other.inconsistencies1h == inconsistencies1h)&&(identical(other.inconsistencies24h, inconsistencies24h) || other.inconsistencies24h == inconsistencies24h)&&(identical(other.inconsistenciesTrend, inconsistenciesTrend) || other.inconsistenciesTrend == inconsistenciesTrend)&&(identical(other.avgLatency, avgLatency) || other.avgLatency == avgLatency)&&(identical(other.p95Latency, p95Latency) || other.p95Latency == p95Latency)&&(identical(other.latencyTrend, latencyTrend) || other.latencyTrend == latencyTrend)&&(identical(other.activePlayers, activePlayers) || other.activePlayers == activePlayers)&&(identical(other.activeRooms, activeRooms) || other.activeRooms == activeRooms)&&(identical(other.totalGamesStarted24h, totalGamesStarted24h) || other.totalGamesStarted24h == totalGamesStarted24h)&&(identical(other.retryRate, retryRate) || other.retryRate == retryRate)&&(identical(other.retryRateTrend, retryRateTrend) || other.retryRateTrend == retryRateTrend)&&(identical(other.realtimeUptime, realtimeUptime) || other.realtimeUptime == realtimeUptime)&&(identical(other.databaseUptime, databaseUptime) || other.databaseUptime == databaseUptime)&&(identical(other.connectionErrors1h, connectionErrors1h) || other.connectionErrors1h == connectionErrors1h)&&(identical(other.timeouts1h, timeouts1h) || other.timeouts1h == timeouts1h)&&(identical(other.avgReconnectTime, avgReconnectTime) || other.avgReconnectTime == avgReconnectTime)&&(identical(other.roomCapacityUtilization, roomCapacityUtilization) || other.roomCapacityUtilization == roomCapacityUtilization)&&(identical(other.maxConcurrentPlayers24h, maxConcurrentPlayers24h) || other.maxConcurrentPlayers24h == maxConcurrentPlayers24h)&&(identical(other.peakLoadUtilization, peakLoadUtilization) || other.peakLoadUtilization == peakLoadUtilization)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&const DeepCollectionEquality().equals(other.activeAlerts, activeAlerts)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,syncErrors1h,syncErrors24h,syncErrorsTrend,inconsistencies1h,inconsistencies24h,inconsistenciesTrend,avgLatency,p95Latency,latencyTrend,activePlayers,activeRooms,totalGamesStarted24h,retryRate,retryRateTrend,realtimeUptime,databaseUptime,connectionErrors1h,timeouts1h,avgReconnectTime,roomCapacityUtilization,maxConcurrentPlayers24h,peakLoadUtilization,lastUpdated,periodStart,periodEnd,const DeepCollectionEquality().hash(activeAlerts),healthScore]);

@override
String toString() {
  return 'SystemHealthMetrics(syncErrors1h: $syncErrors1h, syncErrors24h: $syncErrors24h, syncErrorsTrend: $syncErrorsTrend, inconsistencies1h: $inconsistencies1h, inconsistencies24h: $inconsistencies24h, inconsistenciesTrend: $inconsistenciesTrend, avgLatency: $avgLatency, p95Latency: $p95Latency, latencyTrend: $latencyTrend, activePlayers: $activePlayers, activeRooms: $activeRooms, totalGamesStarted24h: $totalGamesStarted24h, retryRate: $retryRate, retryRateTrend: $retryRateTrend, realtimeUptime: $realtimeUptime, databaseUptime: $databaseUptime, connectionErrors1h: $connectionErrors1h, timeouts1h: $timeouts1h, avgReconnectTime: $avgReconnectTime, roomCapacityUtilization: $roomCapacityUtilization, maxConcurrentPlayers24h: $maxConcurrentPlayers24h, peakLoadUtilization: $peakLoadUtilization, lastUpdated: $lastUpdated, periodStart: $periodStart, periodEnd: $periodEnd, activeAlerts: $activeAlerts, healthScore: $healthScore)';
}


}

/// @nodoc
abstract mixin class $SystemHealthMetricsCopyWith<$Res>  {
  factory $SystemHealthMetricsCopyWith(SystemHealthMetrics value, $Res Function(SystemHealthMetrics) _then) = _$SystemHealthMetricsCopyWithImpl;
@useResult
$Res call({
 int syncErrors1h, int syncErrors24h, TrendDirection syncErrorsTrend, int inconsistencies1h, int inconsistencies24h, TrendDirection inconsistenciesTrend, double avgLatency, double p95Latency, TrendDirection latencyTrend, int activePlayers, int activeRooms, int totalGamesStarted24h, double retryRate, TrendDirection retryRateTrend, double realtimeUptime, double databaseUptime, int connectionErrors1h, int timeouts1h, double avgReconnectTime, double roomCapacityUtilization, int maxConcurrentPlayers24h, double peakLoadUtilization, DateTime lastUpdated, DateTime periodStart, DateTime periodEnd, List<ActiveAlert> activeAlerts, double healthScore
});




}
/// @nodoc
class _$SystemHealthMetricsCopyWithImpl<$Res>
    implements $SystemHealthMetricsCopyWith<$Res> {
  _$SystemHealthMetricsCopyWithImpl(this._self, this._then);

  final SystemHealthMetrics _self;
  final $Res Function(SystemHealthMetrics) _then;

/// Create a copy of SystemHealthMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? syncErrors1h = null,Object? syncErrors24h = null,Object? syncErrorsTrend = null,Object? inconsistencies1h = null,Object? inconsistencies24h = null,Object? inconsistenciesTrend = null,Object? avgLatency = null,Object? p95Latency = null,Object? latencyTrend = null,Object? activePlayers = null,Object? activeRooms = null,Object? totalGamesStarted24h = null,Object? retryRate = null,Object? retryRateTrend = null,Object? realtimeUptime = null,Object? databaseUptime = null,Object? connectionErrors1h = null,Object? timeouts1h = null,Object? avgReconnectTime = null,Object? roomCapacityUtilization = null,Object? maxConcurrentPlayers24h = null,Object? peakLoadUtilization = null,Object? lastUpdated = null,Object? periodStart = null,Object? periodEnd = null,Object? activeAlerts = null,Object? healthScore = null,}) {
  return _then(_self.copyWith(
syncErrors1h: null == syncErrors1h ? _self.syncErrors1h : syncErrors1h // ignore: cast_nullable_to_non_nullable
as int,syncErrors24h: null == syncErrors24h ? _self.syncErrors24h : syncErrors24h // ignore: cast_nullable_to_non_nullable
as int,syncErrorsTrend: null == syncErrorsTrend ? _self.syncErrorsTrend : syncErrorsTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,inconsistencies1h: null == inconsistencies1h ? _self.inconsistencies1h : inconsistencies1h // ignore: cast_nullable_to_non_nullable
as int,inconsistencies24h: null == inconsistencies24h ? _self.inconsistencies24h : inconsistencies24h // ignore: cast_nullable_to_non_nullable
as int,inconsistenciesTrend: null == inconsistenciesTrend ? _self.inconsistenciesTrend : inconsistenciesTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,avgLatency: null == avgLatency ? _self.avgLatency : avgLatency // ignore: cast_nullable_to_non_nullable
as double,p95Latency: null == p95Latency ? _self.p95Latency : p95Latency // ignore: cast_nullable_to_non_nullable
as double,latencyTrend: null == latencyTrend ? _self.latencyTrend : latencyTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,activePlayers: null == activePlayers ? _self.activePlayers : activePlayers // ignore: cast_nullable_to_non_nullable
as int,activeRooms: null == activeRooms ? _self.activeRooms : activeRooms // ignore: cast_nullable_to_non_nullable
as int,totalGamesStarted24h: null == totalGamesStarted24h ? _self.totalGamesStarted24h : totalGamesStarted24h // ignore: cast_nullable_to_non_nullable
as int,retryRate: null == retryRate ? _self.retryRate : retryRate // ignore: cast_nullable_to_non_nullable
as double,retryRateTrend: null == retryRateTrend ? _self.retryRateTrend : retryRateTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,realtimeUptime: null == realtimeUptime ? _self.realtimeUptime : realtimeUptime // ignore: cast_nullable_to_non_nullable
as double,databaseUptime: null == databaseUptime ? _self.databaseUptime : databaseUptime // ignore: cast_nullable_to_non_nullable
as double,connectionErrors1h: null == connectionErrors1h ? _self.connectionErrors1h : connectionErrors1h // ignore: cast_nullable_to_non_nullable
as int,timeouts1h: null == timeouts1h ? _self.timeouts1h : timeouts1h // ignore: cast_nullable_to_non_nullable
as int,avgReconnectTime: null == avgReconnectTime ? _self.avgReconnectTime : avgReconnectTime // ignore: cast_nullable_to_non_nullable
as double,roomCapacityUtilization: null == roomCapacityUtilization ? _self.roomCapacityUtilization : roomCapacityUtilization // ignore: cast_nullable_to_non_nullable
as double,maxConcurrentPlayers24h: null == maxConcurrentPlayers24h ? _self.maxConcurrentPlayers24h : maxConcurrentPlayers24h // ignore: cast_nullable_to_non_nullable
as int,peakLoadUtilization: null == peakLoadUtilization ? _self.peakLoadUtilization : peakLoadUtilization // ignore: cast_nullable_to_non_nullable
as double,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,activeAlerts: null == activeAlerts ? _self.activeAlerts : activeAlerts // ignore: cast_nullable_to_non_nullable
as List<ActiveAlert>,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemHealthMetrics].
extension SystemHealthMetricsPatterns on SystemHealthMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemHealthMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemHealthMetrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemHealthMetrics value)  $default,){
final _that = this;
switch (_that) {
case _SystemHealthMetrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemHealthMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _SystemHealthMetrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int syncErrors1h,  int syncErrors24h,  TrendDirection syncErrorsTrend,  int inconsistencies1h,  int inconsistencies24h,  TrendDirection inconsistenciesTrend,  double avgLatency,  double p95Latency,  TrendDirection latencyTrend,  int activePlayers,  int activeRooms,  int totalGamesStarted24h,  double retryRate,  TrendDirection retryRateTrend,  double realtimeUptime,  double databaseUptime,  int connectionErrors1h,  int timeouts1h,  double avgReconnectTime,  double roomCapacityUtilization,  int maxConcurrentPlayers24h,  double peakLoadUtilization,  DateTime lastUpdated,  DateTime periodStart,  DateTime periodEnd,  List<ActiveAlert> activeAlerts,  double healthScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemHealthMetrics() when $default != null:
return $default(_that.syncErrors1h,_that.syncErrors24h,_that.syncErrorsTrend,_that.inconsistencies1h,_that.inconsistencies24h,_that.inconsistenciesTrend,_that.avgLatency,_that.p95Latency,_that.latencyTrend,_that.activePlayers,_that.activeRooms,_that.totalGamesStarted24h,_that.retryRate,_that.retryRateTrend,_that.realtimeUptime,_that.databaseUptime,_that.connectionErrors1h,_that.timeouts1h,_that.avgReconnectTime,_that.roomCapacityUtilization,_that.maxConcurrentPlayers24h,_that.peakLoadUtilization,_that.lastUpdated,_that.periodStart,_that.periodEnd,_that.activeAlerts,_that.healthScore);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int syncErrors1h,  int syncErrors24h,  TrendDirection syncErrorsTrend,  int inconsistencies1h,  int inconsistencies24h,  TrendDirection inconsistenciesTrend,  double avgLatency,  double p95Latency,  TrendDirection latencyTrend,  int activePlayers,  int activeRooms,  int totalGamesStarted24h,  double retryRate,  TrendDirection retryRateTrend,  double realtimeUptime,  double databaseUptime,  int connectionErrors1h,  int timeouts1h,  double avgReconnectTime,  double roomCapacityUtilization,  int maxConcurrentPlayers24h,  double peakLoadUtilization,  DateTime lastUpdated,  DateTime periodStart,  DateTime periodEnd,  List<ActiveAlert> activeAlerts,  double healthScore)  $default,) {final _that = this;
switch (_that) {
case _SystemHealthMetrics():
return $default(_that.syncErrors1h,_that.syncErrors24h,_that.syncErrorsTrend,_that.inconsistencies1h,_that.inconsistencies24h,_that.inconsistenciesTrend,_that.avgLatency,_that.p95Latency,_that.latencyTrend,_that.activePlayers,_that.activeRooms,_that.totalGamesStarted24h,_that.retryRate,_that.retryRateTrend,_that.realtimeUptime,_that.databaseUptime,_that.connectionErrors1h,_that.timeouts1h,_that.avgReconnectTime,_that.roomCapacityUtilization,_that.maxConcurrentPlayers24h,_that.peakLoadUtilization,_that.lastUpdated,_that.periodStart,_that.periodEnd,_that.activeAlerts,_that.healthScore);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int syncErrors1h,  int syncErrors24h,  TrendDirection syncErrorsTrend,  int inconsistencies1h,  int inconsistencies24h,  TrendDirection inconsistenciesTrend,  double avgLatency,  double p95Latency,  TrendDirection latencyTrend,  int activePlayers,  int activeRooms,  int totalGamesStarted24h,  double retryRate,  TrendDirection retryRateTrend,  double realtimeUptime,  double databaseUptime,  int connectionErrors1h,  int timeouts1h,  double avgReconnectTime,  double roomCapacityUtilization,  int maxConcurrentPlayers24h,  double peakLoadUtilization,  DateTime lastUpdated,  DateTime periodStart,  DateTime periodEnd,  List<ActiveAlert> activeAlerts,  double healthScore)?  $default,) {final _that = this;
switch (_that) {
case _SystemHealthMetrics() when $default != null:
return $default(_that.syncErrors1h,_that.syncErrors24h,_that.syncErrorsTrend,_that.inconsistencies1h,_that.inconsistencies24h,_that.inconsistenciesTrend,_that.avgLatency,_that.p95Latency,_that.latencyTrend,_that.activePlayers,_that.activeRooms,_that.totalGamesStarted24h,_that.retryRate,_that.retryRateTrend,_that.realtimeUptime,_that.databaseUptime,_that.connectionErrors1h,_that.timeouts1h,_that.avgReconnectTime,_that.roomCapacityUtilization,_that.maxConcurrentPlayers24h,_that.peakLoadUtilization,_that.lastUpdated,_that.periodStart,_that.periodEnd,_that.activeAlerts,_that.healthScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SystemHealthMetrics implements SystemHealthMetrics {
  const _SystemHealthMetrics({required this.syncErrors1h, required this.syncErrors24h, required this.syncErrorsTrend, required this.inconsistencies1h, required this.inconsistencies24h, required this.inconsistenciesTrend, required this.avgLatency, required this.p95Latency, required this.latencyTrend, required this.activePlayers, required this.activeRooms, required this.totalGamesStarted24h, required this.retryRate, required this.retryRateTrend, required this.realtimeUptime, required this.databaseUptime, required this.connectionErrors1h, required this.timeouts1h, required this.avgReconnectTime, required this.roomCapacityUtilization, required this.maxConcurrentPlayers24h, required this.peakLoadUtilization, required this.lastUpdated, required this.periodStart, required this.periodEnd, required final  List<ActiveAlert> activeAlerts, required this.healthScore}): _activeAlerts = activeAlerts;
  factory _SystemHealthMetrics.fromJson(Map<String, dynamic> json) => _$SystemHealthMetricsFromJson(json);

// Erreurs de synchronisation
@override final  int syncErrors1h;
@override final  int syncErrors24h;
@override final  TrendDirection syncErrorsTrend;
// Incohérences de données
@override final  int inconsistencies1h;
@override final  int inconsistencies24h;
@override final  TrendDirection inconsistenciesTrend;
// Performance
@override final  double avgLatency;
@override final  double p95Latency;
@override final  TrendDirection latencyTrend;
// Activité
@override final  int activePlayers;
@override final  int activeRooms;
@override final  int totalGamesStarted24h;
// Fiabilité
@override final  double retryRate;
@override final  TrendDirection retryRateTrend;
@override final  double realtimeUptime;
@override final  double databaseUptime;
// Connexions
@override final  int connectionErrors1h;
@override final  int timeouts1h;
@override final  double avgReconnectTime;
// Capacité
@override final  double roomCapacityUtilization;
@override final  int maxConcurrentPlayers24h;
@override final  double peakLoadUtilization;
// Timestamps
@override final  DateTime lastUpdated;
@override final  DateTime periodStart;
@override final  DateTime periodEnd;
// Alertes actives
 final  List<ActiveAlert> _activeAlerts;
// Alertes actives
@override List<ActiveAlert> get activeAlerts {
  if (_activeAlerts is EqualUnmodifiableListView) return _activeAlerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeAlerts);
}

// Score de santé global (0-100)
@override final  double healthScore;

/// Create a copy of SystemHealthMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemHealthMetricsCopyWith<_SystemHealthMetrics> get copyWith => __$SystemHealthMetricsCopyWithImpl<_SystemHealthMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemHealthMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemHealthMetrics&&(identical(other.syncErrors1h, syncErrors1h) || other.syncErrors1h == syncErrors1h)&&(identical(other.syncErrors24h, syncErrors24h) || other.syncErrors24h == syncErrors24h)&&(identical(other.syncErrorsTrend, syncErrorsTrend) || other.syncErrorsTrend == syncErrorsTrend)&&(identical(other.inconsistencies1h, inconsistencies1h) || other.inconsistencies1h == inconsistencies1h)&&(identical(other.inconsistencies24h, inconsistencies24h) || other.inconsistencies24h == inconsistencies24h)&&(identical(other.inconsistenciesTrend, inconsistenciesTrend) || other.inconsistenciesTrend == inconsistenciesTrend)&&(identical(other.avgLatency, avgLatency) || other.avgLatency == avgLatency)&&(identical(other.p95Latency, p95Latency) || other.p95Latency == p95Latency)&&(identical(other.latencyTrend, latencyTrend) || other.latencyTrend == latencyTrend)&&(identical(other.activePlayers, activePlayers) || other.activePlayers == activePlayers)&&(identical(other.activeRooms, activeRooms) || other.activeRooms == activeRooms)&&(identical(other.totalGamesStarted24h, totalGamesStarted24h) || other.totalGamesStarted24h == totalGamesStarted24h)&&(identical(other.retryRate, retryRate) || other.retryRate == retryRate)&&(identical(other.retryRateTrend, retryRateTrend) || other.retryRateTrend == retryRateTrend)&&(identical(other.realtimeUptime, realtimeUptime) || other.realtimeUptime == realtimeUptime)&&(identical(other.databaseUptime, databaseUptime) || other.databaseUptime == databaseUptime)&&(identical(other.connectionErrors1h, connectionErrors1h) || other.connectionErrors1h == connectionErrors1h)&&(identical(other.timeouts1h, timeouts1h) || other.timeouts1h == timeouts1h)&&(identical(other.avgReconnectTime, avgReconnectTime) || other.avgReconnectTime == avgReconnectTime)&&(identical(other.roomCapacityUtilization, roomCapacityUtilization) || other.roomCapacityUtilization == roomCapacityUtilization)&&(identical(other.maxConcurrentPlayers24h, maxConcurrentPlayers24h) || other.maxConcurrentPlayers24h == maxConcurrentPlayers24h)&&(identical(other.peakLoadUtilization, peakLoadUtilization) || other.peakLoadUtilization == peakLoadUtilization)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&const DeepCollectionEquality().equals(other._activeAlerts, _activeAlerts)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,syncErrors1h,syncErrors24h,syncErrorsTrend,inconsistencies1h,inconsistencies24h,inconsistenciesTrend,avgLatency,p95Latency,latencyTrend,activePlayers,activeRooms,totalGamesStarted24h,retryRate,retryRateTrend,realtimeUptime,databaseUptime,connectionErrors1h,timeouts1h,avgReconnectTime,roomCapacityUtilization,maxConcurrentPlayers24h,peakLoadUtilization,lastUpdated,periodStart,periodEnd,const DeepCollectionEquality().hash(_activeAlerts),healthScore]);

@override
String toString() {
  return 'SystemHealthMetrics(syncErrors1h: $syncErrors1h, syncErrors24h: $syncErrors24h, syncErrorsTrend: $syncErrorsTrend, inconsistencies1h: $inconsistencies1h, inconsistencies24h: $inconsistencies24h, inconsistenciesTrend: $inconsistenciesTrend, avgLatency: $avgLatency, p95Latency: $p95Latency, latencyTrend: $latencyTrend, activePlayers: $activePlayers, activeRooms: $activeRooms, totalGamesStarted24h: $totalGamesStarted24h, retryRate: $retryRate, retryRateTrend: $retryRateTrend, realtimeUptime: $realtimeUptime, databaseUptime: $databaseUptime, connectionErrors1h: $connectionErrors1h, timeouts1h: $timeouts1h, avgReconnectTime: $avgReconnectTime, roomCapacityUtilization: $roomCapacityUtilization, maxConcurrentPlayers24h: $maxConcurrentPlayers24h, peakLoadUtilization: $peakLoadUtilization, lastUpdated: $lastUpdated, periodStart: $periodStart, periodEnd: $periodEnd, activeAlerts: $activeAlerts, healthScore: $healthScore)';
}


}

/// @nodoc
abstract mixin class _$SystemHealthMetricsCopyWith<$Res> implements $SystemHealthMetricsCopyWith<$Res> {
  factory _$SystemHealthMetricsCopyWith(_SystemHealthMetrics value, $Res Function(_SystemHealthMetrics) _then) = __$SystemHealthMetricsCopyWithImpl;
@override @useResult
$Res call({
 int syncErrors1h, int syncErrors24h, TrendDirection syncErrorsTrend, int inconsistencies1h, int inconsistencies24h, TrendDirection inconsistenciesTrend, double avgLatency, double p95Latency, TrendDirection latencyTrend, int activePlayers, int activeRooms, int totalGamesStarted24h, double retryRate, TrendDirection retryRateTrend, double realtimeUptime, double databaseUptime, int connectionErrors1h, int timeouts1h, double avgReconnectTime, double roomCapacityUtilization, int maxConcurrentPlayers24h, double peakLoadUtilization, DateTime lastUpdated, DateTime periodStart, DateTime periodEnd, List<ActiveAlert> activeAlerts, double healthScore
});




}
/// @nodoc
class __$SystemHealthMetricsCopyWithImpl<$Res>
    implements _$SystemHealthMetricsCopyWith<$Res> {
  __$SystemHealthMetricsCopyWithImpl(this._self, this._then);

  final _SystemHealthMetrics _self;
  final $Res Function(_SystemHealthMetrics) _then;

/// Create a copy of SystemHealthMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? syncErrors1h = null,Object? syncErrors24h = null,Object? syncErrorsTrend = null,Object? inconsistencies1h = null,Object? inconsistencies24h = null,Object? inconsistenciesTrend = null,Object? avgLatency = null,Object? p95Latency = null,Object? latencyTrend = null,Object? activePlayers = null,Object? activeRooms = null,Object? totalGamesStarted24h = null,Object? retryRate = null,Object? retryRateTrend = null,Object? realtimeUptime = null,Object? databaseUptime = null,Object? connectionErrors1h = null,Object? timeouts1h = null,Object? avgReconnectTime = null,Object? roomCapacityUtilization = null,Object? maxConcurrentPlayers24h = null,Object? peakLoadUtilization = null,Object? lastUpdated = null,Object? periodStart = null,Object? periodEnd = null,Object? activeAlerts = null,Object? healthScore = null,}) {
  return _then(_SystemHealthMetrics(
syncErrors1h: null == syncErrors1h ? _self.syncErrors1h : syncErrors1h // ignore: cast_nullable_to_non_nullable
as int,syncErrors24h: null == syncErrors24h ? _self.syncErrors24h : syncErrors24h // ignore: cast_nullable_to_non_nullable
as int,syncErrorsTrend: null == syncErrorsTrend ? _self.syncErrorsTrend : syncErrorsTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,inconsistencies1h: null == inconsistencies1h ? _self.inconsistencies1h : inconsistencies1h // ignore: cast_nullable_to_non_nullable
as int,inconsistencies24h: null == inconsistencies24h ? _self.inconsistencies24h : inconsistencies24h // ignore: cast_nullable_to_non_nullable
as int,inconsistenciesTrend: null == inconsistenciesTrend ? _self.inconsistenciesTrend : inconsistenciesTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,avgLatency: null == avgLatency ? _self.avgLatency : avgLatency // ignore: cast_nullable_to_non_nullable
as double,p95Latency: null == p95Latency ? _self.p95Latency : p95Latency // ignore: cast_nullable_to_non_nullable
as double,latencyTrend: null == latencyTrend ? _self.latencyTrend : latencyTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,activePlayers: null == activePlayers ? _self.activePlayers : activePlayers // ignore: cast_nullable_to_non_nullable
as int,activeRooms: null == activeRooms ? _self.activeRooms : activeRooms // ignore: cast_nullable_to_non_nullable
as int,totalGamesStarted24h: null == totalGamesStarted24h ? _self.totalGamesStarted24h : totalGamesStarted24h // ignore: cast_nullable_to_non_nullable
as int,retryRate: null == retryRate ? _self.retryRate : retryRate // ignore: cast_nullable_to_non_nullable
as double,retryRateTrend: null == retryRateTrend ? _self.retryRateTrend : retryRateTrend // ignore: cast_nullable_to_non_nullable
as TrendDirection,realtimeUptime: null == realtimeUptime ? _self.realtimeUptime : realtimeUptime // ignore: cast_nullable_to_non_nullable
as double,databaseUptime: null == databaseUptime ? _self.databaseUptime : databaseUptime // ignore: cast_nullable_to_non_nullable
as double,connectionErrors1h: null == connectionErrors1h ? _self.connectionErrors1h : connectionErrors1h // ignore: cast_nullable_to_non_nullable
as int,timeouts1h: null == timeouts1h ? _self.timeouts1h : timeouts1h // ignore: cast_nullable_to_non_nullable
as int,avgReconnectTime: null == avgReconnectTime ? _self.avgReconnectTime : avgReconnectTime // ignore: cast_nullable_to_non_nullable
as double,roomCapacityUtilization: null == roomCapacityUtilization ? _self.roomCapacityUtilization : roomCapacityUtilization // ignore: cast_nullable_to_non_nullable
as double,maxConcurrentPlayers24h: null == maxConcurrentPlayers24h ? _self.maxConcurrentPlayers24h : maxConcurrentPlayers24h // ignore: cast_nullable_to_non_nullable
as int,peakLoadUtilization: null == peakLoadUtilization ? _self.peakLoadUtilization : peakLoadUtilization // ignore: cast_nullable_to_non_nullable
as double,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,activeAlerts: null == activeAlerts ? _self._activeAlerts : activeAlerts // ignore: cast_nullable_to_non_nullable
as List<ActiveAlert>,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ActiveAlert {

 String get id; String get title; String get description; AlertSeverity get severity; DateTime get triggeredAt; String get source; Map<String, dynamic> get context; String? get roomId; String? get playerId;
/// Create a copy of ActiveAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveAlertCopyWith<ActiveAlert> get copyWith => _$ActiveAlertCopyWithImpl<ActiveAlert>(this as ActiveAlert, _$identity);

  /// Serializes this ActiveAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.context, context)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,severity,triggeredAt,source,const DeepCollectionEquality().hash(context),roomId,playerId);

@override
String toString() {
  return 'ActiveAlert(id: $id, title: $title, description: $description, severity: $severity, triggeredAt: $triggeredAt, source: $source, context: $context, roomId: $roomId, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $ActiveAlertCopyWith<$Res>  {
  factory $ActiveAlertCopyWith(ActiveAlert value, $Res Function(ActiveAlert) _then) = _$ActiveAlertCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, AlertSeverity severity, DateTime triggeredAt, String source, Map<String, dynamic> context, String? roomId, String? playerId
});




}
/// @nodoc
class _$ActiveAlertCopyWithImpl<$Res>
    implements $ActiveAlertCopyWith<$Res> {
  _$ActiveAlertCopyWithImpl(this._self, this._then);

  final ActiveAlert _self;
  final $Res Function(ActiveAlert) _then;

/// Create a copy of ActiveAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? severity = null,Object? triggeredAt = null,Object? source = null,Object? context = null,Object? roomId = freezed,Object? playerId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,playerId: freezed == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveAlert].
extension ActiveAlertPatterns on ActiveAlert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveAlert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveAlert value)  $default,){
final _that = this;
switch (_that) {
case _ActiveAlert():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveAlert value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveAlert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  AlertSeverity severity,  DateTime triggeredAt,  String source,  Map<String, dynamic> context,  String? roomId,  String? playerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveAlert() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.severity,_that.triggeredAt,_that.source,_that.context,_that.roomId,_that.playerId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  AlertSeverity severity,  DateTime triggeredAt,  String source,  Map<String, dynamic> context,  String? roomId,  String? playerId)  $default,) {final _that = this;
switch (_that) {
case _ActiveAlert():
return $default(_that.id,_that.title,_that.description,_that.severity,_that.triggeredAt,_that.source,_that.context,_that.roomId,_that.playerId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  AlertSeverity severity,  DateTime triggeredAt,  String source,  Map<String, dynamic> context,  String? roomId,  String? playerId)?  $default,) {final _that = this;
switch (_that) {
case _ActiveAlert() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.severity,_that.triggeredAt,_that.source,_that.context,_that.roomId,_that.playerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveAlert implements ActiveAlert {
  const _ActiveAlert({required this.id, required this.title, required this.description, required this.severity, required this.triggeredAt, required this.source, required final  Map<String, dynamic> context, this.roomId, this.playerId}): _context = context;
  factory _ActiveAlert.fromJson(Map<String, dynamic> json) => _$ActiveAlertFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  AlertSeverity severity;
@override final  DateTime triggeredAt;
@override final  String source;
 final  Map<String, dynamic> _context;
@override Map<String, dynamic> get context {
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_context);
}

@override final  String? roomId;
@override final  String? playerId;

/// Create a copy of ActiveAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveAlertCopyWith<_ActiveAlert> get copyWith => __$ActiveAlertCopyWithImpl<_ActiveAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other._context, _context)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,severity,triggeredAt,source,const DeepCollectionEquality().hash(_context),roomId,playerId);

@override
String toString() {
  return 'ActiveAlert(id: $id, title: $title, description: $description, severity: $severity, triggeredAt: $triggeredAt, source: $source, context: $context, roomId: $roomId, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class _$ActiveAlertCopyWith<$Res> implements $ActiveAlertCopyWith<$Res> {
  factory _$ActiveAlertCopyWith(_ActiveAlert value, $Res Function(_ActiveAlert) _then) = __$ActiveAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, AlertSeverity severity, DateTime triggeredAt, String source, Map<String, dynamic> context, String? roomId, String? playerId
});




}
/// @nodoc
class __$ActiveAlertCopyWithImpl<$Res>
    implements _$ActiveAlertCopyWith<$Res> {
  __$ActiveAlertCopyWithImpl(this._self, this._then);

  final _ActiveAlert _self;
  final $Res Function(_ActiveAlert) _then;

/// Create a copy of ActiveAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? severity = null,Object? triggeredAt = null,Object? source = null,Object? context = null,Object? roomId = freezed,Object? playerId = freezed,}) {
  return _then(_ActiveAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,context: null == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,playerId: freezed == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HistoricalMetrics {

 List<TimeSeriesPoint> get syncErrors; List<TimeSeriesPoint> get inconsistencies; List<TimeSeriesPoint> get latency; List<TimeSeriesPoint> get activePlayers; List<TimeSeriesPoint> get retryRate; List<TimeSeriesPoint> get uptime;
/// Create a copy of HistoricalMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoricalMetricsCopyWith<HistoricalMetrics> get copyWith => _$HistoricalMetricsCopyWithImpl<HistoricalMetrics>(this as HistoricalMetrics, _$identity);

  /// Serializes this HistoricalMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoricalMetrics&&const DeepCollectionEquality().equals(other.syncErrors, syncErrors)&&const DeepCollectionEquality().equals(other.inconsistencies, inconsistencies)&&const DeepCollectionEquality().equals(other.latency, latency)&&const DeepCollectionEquality().equals(other.activePlayers, activePlayers)&&const DeepCollectionEquality().equals(other.retryRate, retryRate)&&const DeepCollectionEquality().equals(other.uptime, uptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(syncErrors),const DeepCollectionEquality().hash(inconsistencies),const DeepCollectionEquality().hash(latency),const DeepCollectionEquality().hash(activePlayers),const DeepCollectionEquality().hash(retryRate),const DeepCollectionEquality().hash(uptime));

@override
String toString() {
  return 'HistoricalMetrics(syncErrors: $syncErrors, inconsistencies: $inconsistencies, latency: $latency, activePlayers: $activePlayers, retryRate: $retryRate, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class $HistoricalMetricsCopyWith<$Res>  {
  factory $HistoricalMetricsCopyWith(HistoricalMetrics value, $Res Function(HistoricalMetrics) _then) = _$HistoricalMetricsCopyWithImpl;
@useResult
$Res call({
 List<TimeSeriesPoint> syncErrors, List<TimeSeriesPoint> inconsistencies, List<TimeSeriesPoint> latency, List<TimeSeriesPoint> activePlayers, List<TimeSeriesPoint> retryRate, List<TimeSeriesPoint> uptime
});




}
/// @nodoc
class _$HistoricalMetricsCopyWithImpl<$Res>
    implements $HistoricalMetricsCopyWith<$Res> {
  _$HistoricalMetricsCopyWithImpl(this._self, this._then);

  final HistoricalMetrics _self;
  final $Res Function(HistoricalMetrics) _then;

/// Create a copy of HistoricalMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? syncErrors = null,Object? inconsistencies = null,Object? latency = null,Object? activePlayers = null,Object? retryRate = null,Object? uptime = null,}) {
  return _then(_self.copyWith(
syncErrors: null == syncErrors ? _self.syncErrors : syncErrors // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,inconsistencies: null == inconsistencies ? _self.inconsistencies : inconsistencies // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,activePlayers: null == activePlayers ? _self.activePlayers : activePlayers // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,retryRate: null == retryRate ? _self.retryRate : retryRate // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoricalMetrics].
extension HistoricalMetricsPatterns on HistoricalMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoricalMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoricalMetrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoricalMetrics value)  $default,){
final _that = this;
switch (_that) {
case _HistoricalMetrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoricalMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _HistoricalMetrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TimeSeriesPoint> syncErrors,  List<TimeSeriesPoint> inconsistencies,  List<TimeSeriesPoint> latency,  List<TimeSeriesPoint> activePlayers,  List<TimeSeriesPoint> retryRate,  List<TimeSeriesPoint> uptime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoricalMetrics() when $default != null:
return $default(_that.syncErrors,_that.inconsistencies,_that.latency,_that.activePlayers,_that.retryRate,_that.uptime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TimeSeriesPoint> syncErrors,  List<TimeSeriesPoint> inconsistencies,  List<TimeSeriesPoint> latency,  List<TimeSeriesPoint> activePlayers,  List<TimeSeriesPoint> retryRate,  List<TimeSeriesPoint> uptime)  $default,) {final _that = this;
switch (_that) {
case _HistoricalMetrics():
return $default(_that.syncErrors,_that.inconsistencies,_that.latency,_that.activePlayers,_that.retryRate,_that.uptime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TimeSeriesPoint> syncErrors,  List<TimeSeriesPoint> inconsistencies,  List<TimeSeriesPoint> latency,  List<TimeSeriesPoint> activePlayers,  List<TimeSeriesPoint> retryRate,  List<TimeSeriesPoint> uptime)?  $default,) {final _that = this;
switch (_that) {
case _HistoricalMetrics() when $default != null:
return $default(_that.syncErrors,_that.inconsistencies,_that.latency,_that.activePlayers,_that.retryRate,_that.uptime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoricalMetrics implements HistoricalMetrics {
  const _HistoricalMetrics({required final  List<TimeSeriesPoint> syncErrors, required final  List<TimeSeriesPoint> inconsistencies, required final  List<TimeSeriesPoint> latency, required final  List<TimeSeriesPoint> activePlayers, required final  List<TimeSeriesPoint> retryRate, required final  List<TimeSeriesPoint> uptime}): _syncErrors = syncErrors,_inconsistencies = inconsistencies,_latency = latency,_activePlayers = activePlayers,_retryRate = retryRate,_uptime = uptime;
  factory _HistoricalMetrics.fromJson(Map<String, dynamic> json) => _$HistoricalMetricsFromJson(json);

 final  List<TimeSeriesPoint> _syncErrors;
@override List<TimeSeriesPoint> get syncErrors {
  if (_syncErrors is EqualUnmodifiableListView) return _syncErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_syncErrors);
}

 final  List<TimeSeriesPoint> _inconsistencies;
@override List<TimeSeriesPoint> get inconsistencies {
  if (_inconsistencies is EqualUnmodifiableListView) return _inconsistencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inconsistencies);
}

 final  List<TimeSeriesPoint> _latency;
@override List<TimeSeriesPoint> get latency {
  if (_latency is EqualUnmodifiableListView) return _latency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_latency);
}

 final  List<TimeSeriesPoint> _activePlayers;
@override List<TimeSeriesPoint> get activePlayers {
  if (_activePlayers is EqualUnmodifiableListView) return _activePlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activePlayers);
}

 final  List<TimeSeriesPoint> _retryRate;
@override List<TimeSeriesPoint> get retryRate {
  if (_retryRate is EqualUnmodifiableListView) return _retryRate;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_retryRate);
}

 final  List<TimeSeriesPoint> _uptime;
@override List<TimeSeriesPoint> get uptime {
  if (_uptime is EqualUnmodifiableListView) return _uptime;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uptime);
}


/// Create a copy of HistoricalMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoricalMetricsCopyWith<_HistoricalMetrics> get copyWith => __$HistoricalMetricsCopyWithImpl<_HistoricalMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoricalMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoricalMetrics&&const DeepCollectionEquality().equals(other._syncErrors, _syncErrors)&&const DeepCollectionEquality().equals(other._inconsistencies, _inconsistencies)&&const DeepCollectionEquality().equals(other._latency, _latency)&&const DeepCollectionEquality().equals(other._activePlayers, _activePlayers)&&const DeepCollectionEquality().equals(other._retryRate, _retryRate)&&const DeepCollectionEquality().equals(other._uptime, _uptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_syncErrors),const DeepCollectionEquality().hash(_inconsistencies),const DeepCollectionEquality().hash(_latency),const DeepCollectionEquality().hash(_activePlayers),const DeepCollectionEquality().hash(_retryRate),const DeepCollectionEquality().hash(_uptime));

@override
String toString() {
  return 'HistoricalMetrics(syncErrors: $syncErrors, inconsistencies: $inconsistencies, latency: $latency, activePlayers: $activePlayers, retryRate: $retryRate, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class _$HistoricalMetricsCopyWith<$Res> implements $HistoricalMetricsCopyWith<$Res> {
  factory _$HistoricalMetricsCopyWith(_HistoricalMetrics value, $Res Function(_HistoricalMetrics) _then) = __$HistoricalMetricsCopyWithImpl;
@override @useResult
$Res call({
 List<TimeSeriesPoint> syncErrors, List<TimeSeriesPoint> inconsistencies, List<TimeSeriesPoint> latency, List<TimeSeriesPoint> activePlayers, List<TimeSeriesPoint> retryRate, List<TimeSeriesPoint> uptime
});




}
/// @nodoc
class __$HistoricalMetricsCopyWithImpl<$Res>
    implements _$HistoricalMetricsCopyWith<$Res> {
  __$HistoricalMetricsCopyWithImpl(this._self, this._then);

  final _HistoricalMetrics _self;
  final $Res Function(_HistoricalMetrics) _then;

/// Create a copy of HistoricalMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? syncErrors = null,Object? inconsistencies = null,Object? latency = null,Object? activePlayers = null,Object? retryRate = null,Object? uptime = null,}) {
  return _then(_HistoricalMetrics(
syncErrors: null == syncErrors ? _self._syncErrors : syncErrors // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,inconsistencies: null == inconsistencies ? _self._inconsistencies : inconsistencies // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,latency: null == latency ? _self._latency : latency // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,activePlayers: null == activePlayers ? _self._activePlayers : activePlayers // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,retryRate: null == retryRate ? _self._retryRate : retryRate // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,uptime: null == uptime ? _self._uptime : uptime // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,
  ));
}


}


/// @nodoc
mixin _$TimeSeriesPoint {

 DateTime get timestamp; double get value; Map<String, dynamic>? get metadata;
/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSeriesPointCopyWith<TimeSeriesPoint> get copyWith => _$TimeSeriesPointCopyWithImpl<TimeSeriesPoint>(this as TimeSeriesPoint, _$identity);

  /// Serializes this TimeSeriesPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSeriesPoint&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,value,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'TimeSeriesPoint(timestamp: $timestamp, value: $value, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TimeSeriesPointCopyWith<$Res>  {
  factory $TimeSeriesPointCopyWith(TimeSeriesPoint value, $Res Function(TimeSeriesPoint) _then) = _$TimeSeriesPointCopyWithImpl;
@useResult
$Res call({
 DateTime timestamp, double value, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$TimeSeriesPointCopyWithImpl<$Res>
    implements $TimeSeriesPointCopyWith<$Res> {
  _$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final TimeSeriesPoint _self;
  final $Res Function(TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? value = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSeriesPoint].
extension TimeSeriesPointPatterns on TimeSeriesPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSeriesPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime timestamp,  double value,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.timestamp,_that.value,_that.metadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime timestamp,  double value,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint():
return $default(_that.timestamp,_that.value,_that.metadata);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime timestamp,  double value,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.timestamp,_that.value,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSeriesPoint implements TimeSeriesPoint {
  const _TimeSeriesPoint({required this.timestamp, required this.value, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  factory _TimeSeriesPoint.fromJson(Map<String, dynamic> json) => _$TimeSeriesPointFromJson(json);

@override final  DateTime timestamp;
@override final  double value;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSeriesPointCopyWith<_TimeSeriesPoint> get copyWith => __$TimeSeriesPointCopyWithImpl<_TimeSeriesPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSeriesPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSeriesPoint&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,value,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'TimeSeriesPoint(timestamp: $timestamp, value: $value, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TimeSeriesPointCopyWith<$Res> implements $TimeSeriesPointCopyWith<$Res> {
  factory _$TimeSeriesPointCopyWith(_TimeSeriesPoint value, $Res Function(_TimeSeriesPoint) _then) = __$TimeSeriesPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime timestamp, double value, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$TimeSeriesPointCopyWithImpl<$Res>
    implements _$TimeSeriesPointCopyWith<$Res> {
  __$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final _TimeSeriesPoint _self;
  final $Res Function(_TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? value = null,Object? metadata = freezed,}) {
  return _then(_TimeSeriesPoint(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
