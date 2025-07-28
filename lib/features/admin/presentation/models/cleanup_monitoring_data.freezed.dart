// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cleanup_monitoring_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CleanupMonitoringData {

 int get activeRoomsCount; int get inactiveRoomsCount; int get connectedPlayersCount; int get disconnectedPlayersCount; DateTime? get lastCleanupTime; int get cleanupErrorsLastHour; bool get circuitBreakerActive; List<CronJobInfo> get cronJobs;
/// Create a copy of CleanupMonitoringData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CleanupMonitoringDataCopyWith<CleanupMonitoringData> get copyWith => _$CleanupMonitoringDataCopyWithImpl<CleanupMonitoringData>(this as CleanupMonitoringData, _$identity);

  /// Serializes this CleanupMonitoringData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanupMonitoringData&&(identical(other.activeRoomsCount, activeRoomsCount) || other.activeRoomsCount == activeRoomsCount)&&(identical(other.inactiveRoomsCount, inactiveRoomsCount) || other.inactiveRoomsCount == inactiveRoomsCount)&&(identical(other.connectedPlayersCount, connectedPlayersCount) || other.connectedPlayersCount == connectedPlayersCount)&&(identical(other.disconnectedPlayersCount, disconnectedPlayersCount) || other.disconnectedPlayersCount == disconnectedPlayersCount)&&(identical(other.lastCleanupTime, lastCleanupTime) || other.lastCleanupTime == lastCleanupTime)&&(identical(other.cleanupErrorsLastHour, cleanupErrorsLastHour) || other.cleanupErrorsLastHour == cleanupErrorsLastHour)&&(identical(other.circuitBreakerActive, circuitBreakerActive) || other.circuitBreakerActive == circuitBreakerActive)&&const DeepCollectionEquality().equals(other.cronJobs, cronJobs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeRoomsCount,inactiveRoomsCount,connectedPlayersCount,disconnectedPlayersCount,lastCleanupTime,cleanupErrorsLastHour,circuitBreakerActive,const DeepCollectionEquality().hash(cronJobs));

@override
String toString() {
  return 'CleanupMonitoringData(activeRoomsCount: $activeRoomsCount, inactiveRoomsCount: $inactiveRoomsCount, connectedPlayersCount: $connectedPlayersCount, disconnectedPlayersCount: $disconnectedPlayersCount, lastCleanupTime: $lastCleanupTime, cleanupErrorsLastHour: $cleanupErrorsLastHour, circuitBreakerActive: $circuitBreakerActive, cronJobs: $cronJobs)';
}


}

/// @nodoc
abstract mixin class $CleanupMonitoringDataCopyWith<$Res>  {
  factory $CleanupMonitoringDataCopyWith(CleanupMonitoringData value, $Res Function(CleanupMonitoringData) _then) = _$CleanupMonitoringDataCopyWithImpl;
@useResult
$Res call({
 int activeRoomsCount, int inactiveRoomsCount, int connectedPlayersCount, int disconnectedPlayersCount, DateTime? lastCleanupTime, int cleanupErrorsLastHour, bool circuitBreakerActive, List<CronJobInfo> cronJobs
});




}
/// @nodoc
class _$CleanupMonitoringDataCopyWithImpl<$Res>
    implements $CleanupMonitoringDataCopyWith<$Res> {
  _$CleanupMonitoringDataCopyWithImpl(this._self, this._then);

  final CleanupMonitoringData _self;
  final $Res Function(CleanupMonitoringData) _then;

/// Create a copy of CleanupMonitoringData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeRoomsCount = null,Object? inactiveRoomsCount = null,Object? connectedPlayersCount = null,Object? disconnectedPlayersCount = null,Object? lastCleanupTime = freezed,Object? cleanupErrorsLastHour = null,Object? circuitBreakerActive = null,Object? cronJobs = null,}) {
  return _then(_self.copyWith(
activeRoomsCount: null == activeRoomsCount ? _self.activeRoomsCount : activeRoomsCount // ignore: cast_nullable_to_non_nullable
as int,inactiveRoomsCount: null == inactiveRoomsCount ? _self.inactiveRoomsCount : inactiveRoomsCount // ignore: cast_nullable_to_non_nullable
as int,connectedPlayersCount: null == connectedPlayersCount ? _self.connectedPlayersCount : connectedPlayersCount // ignore: cast_nullable_to_non_nullable
as int,disconnectedPlayersCount: null == disconnectedPlayersCount ? _self.disconnectedPlayersCount : disconnectedPlayersCount // ignore: cast_nullable_to_non_nullable
as int,lastCleanupTime: freezed == lastCleanupTime ? _self.lastCleanupTime : lastCleanupTime // ignore: cast_nullable_to_non_nullable
as DateTime?,cleanupErrorsLastHour: null == cleanupErrorsLastHour ? _self.cleanupErrorsLastHour : cleanupErrorsLastHour // ignore: cast_nullable_to_non_nullable
as int,circuitBreakerActive: null == circuitBreakerActive ? _self.circuitBreakerActive : circuitBreakerActive // ignore: cast_nullable_to_non_nullable
as bool,cronJobs: null == cronJobs ? _self.cronJobs : cronJobs // ignore: cast_nullable_to_non_nullable
as List<CronJobInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [CleanupMonitoringData].
extension CleanupMonitoringDataPatterns on CleanupMonitoringData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CleanupMonitoringData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CleanupMonitoringData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CleanupMonitoringData value)  $default,){
final _that = this;
switch (_that) {
case _CleanupMonitoringData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CleanupMonitoringData value)?  $default,){
final _that = this;
switch (_that) {
case _CleanupMonitoringData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeRoomsCount,  int inactiveRoomsCount,  int connectedPlayersCount,  int disconnectedPlayersCount,  DateTime? lastCleanupTime,  int cleanupErrorsLastHour,  bool circuitBreakerActive,  List<CronJobInfo> cronJobs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CleanupMonitoringData() when $default != null:
return $default(_that.activeRoomsCount,_that.inactiveRoomsCount,_that.connectedPlayersCount,_that.disconnectedPlayersCount,_that.lastCleanupTime,_that.cleanupErrorsLastHour,_that.circuitBreakerActive,_that.cronJobs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeRoomsCount,  int inactiveRoomsCount,  int connectedPlayersCount,  int disconnectedPlayersCount,  DateTime? lastCleanupTime,  int cleanupErrorsLastHour,  bool circuitBreakerActive,  List<CronJobInfo> cronJobs)  $default,) {final _that = this;
switch (_that) {
case _CleanupMonitoringData():
return $default(_that.activeRoomsCount,_that.inactiveRoomsCount,_that.connectedPlayersCount,_that.disconnectedPlayersCount,_that.lastCleanupTime,_that.cleanupErrorsLastHour,_that.circuitBreakerActive,_that.cronJobs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeRoomsCount,  int inactiveRoomsCount,  int connectedPlayersCount,  int disconnectedPlayersCount,  DateTime? lastCleanupTime,  int cleanupErrorsLastHour,  bool circuitBreakerActive,  List<CronJobInfo> cronJobs)?  $default,) {final _that = this;
switch (_that) {
case _CleanupMonitoringData() when $default != null:
return $default(_that.activeRoomsCount,_that.inactiveRoomsCount,_that.connectedPlayersCount,_that.disconnectedPlayersCount,_that.lastCleanupTime,_that.cleanupErrorsLastHour,_that.circuitBreakerActive,_that.cronJobs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CleanupMonitoringData implements CleanupMonitoringData {
  const _CleanupMonitoringData({required this.activeRoomsCount, required this.inactiveRoomsCount, required this.connectedPlayersCount, required this.disconnectedPlayersCount, this.lastCleanupTime, required this.cleanupErrorsLastHour, required this.circuitBreakerActive, required final  List<CronJobInfo> cronJobs}): _cronJobs = cronJobs;
  factory _CleanupMonitoringData.fromJson(Map<String, dynamic> json) => _$CleanupMonitoringDataFromJson(json);

@override final  int activeRoomsCount;
@override final  int inactiveRoomsCount;
@override final  int connectedPlayersCount;
@override final  int disconnectedPlayersCount;
@override final  DateTime? lastCleanupTime;
@override final  int cleanupErrorsLastHour;
@override final  bool circuitBreakerActive;
 final  List<CronJobInfo> _cronJobs;
@override List<CronJobInfo> get cronJobs {
  if (_cronJobs is EqualUnmodifiableListView) return _cronJobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cronJobs);
}


/// Create a copy of CleanupMonitoringData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CleanupMonitoringDataCopyWith<_CleanupMonitoringData> get copyWith => __$CleanupMonitoringDataCopyWithImpl<_CleanupMonitoringData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CleanupMonitoringDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CleanupMonitoringData&&(identical(other.activeRoomsCount, activeRoomsCount) || other.activeRoomsCount == activeRoomsCount)&&(identical(other.inactiveRoomsCount, inactiveRoomsCount) || other.inactiveRoomsCount == inactiveRoomsCount)&&(identical(other.connectedPlayersCount, connectedPlayersCount) || other.connectedPlayersCount == connectedPlayersCount)&&(identical(other.disconnectedPlayersCount, disconnectedPlayersCount) || other.disconnectedPlayersCount == disconnectedPlayersCount)&&(identical(other.lastCleanupTime, lastCleanupTime) || other.lastCleanupTime == lastCleanupTime)&&(identical(other.cleanupErrorsLastHour, cleanupErrorsLastHour) || other.cleanupErrorsLastHour == cleanupErrorsLastHour)&&(identical(other.circuitBreakerActive, circuitBreakerActive) || other.circuitBreakerActive == circuitBreakerActive)&&const DeepCollectionEquality().equals(other._cronJobs, _cronJobs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeRoomsCount,inactiveRoomsCount,connectedPlayersCount,disconnectedPlayersCount,lastCleanupTime,cleanupErrorsLastHour,circuitBreakerActive,const DeepCollectionEquality().hash(_cronJobs));

@override
String toString() {
  return 'CleanupMonitoringData(activeRoomsCount: $activeRoomsCount, inactiveRoomsCount: $inactiveRoomsCount, connectedPlayersCount: $connectedPlayersCount, disconnectedPlayersCount: $disconnectedPlayersCount, lastCleanupTime: $lastCleanupTime, cleanupErrorsLastHour: $cleanupErrorsLastHour, circuitBreakerActive: $circuitBreakerActive, cronJobs: $cronJobs)';
}


}

/// @nodoc
abstract mixin class _$CleanupMonitoringDataCopyWith<$Res> implements $CleanupMonitoringDataCopyWith<$Res> {
  factory _$CleanupMonitoringDataCopyWith(_CleanupMonitoringData value, $Res Function(_CleanupMonitoringData) _then) = __$CleanupMonitoringDataCopyWithImpl;
@override @useResult
$Res call({
 int activeRoomsCount, int inactiveRoomsCount, int connectedPlayersCount, int disconnectedPlayersCount, DateTime? lastCleanupTime, int cleanupErrorsLastHour, bool circuitBreakerActive, List<CronJobInfo> cronJobs
});




}
/// @nodoc
class __$CleanupMonitoringDataCopyWithImpl<$Res>
    implements _$CleanupMonitoringDataCopyWith<$Res> {
  __$CleanupMonitoringDataCopyWithImpl(this._self, this._then);

  final _CleanupMonitoringData _self;
  final $Res Function(_CleanupMonitoringData) _then;

/// Create a copy of CleanupMonitoringData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeRoomsCount = null,Object? inactiveRoomsCount = null,Object? connectedPlayersCount = null,Object? disconnectedPlayersCount = null,Object? lastCleanupTime = freezed,Object? cleanupErrorsLastHour = null,Object? circuitBreakerActive = null,Object? cronJobs = null,}) {
  return _then(_CleanupMonitoringData(
activeRoomsCount: null == activeRoomsCount ? _self.activeRoomsCount : activeRoomsCount // ignore: cast_nullable_to_non_nullable
as int,inactiveRoomsCount: null == inactiveRoomsCount ? _self.inactiveRoomsCount : inactiveRoomsCount // ignore: cast_nullable_to_non_nullable
as int,connectedPlayersCount: null == connectedPlayersCount ? _self.connectedPlayersCount : connectedPlayersCount // ignore: cast_nullable_to_non_nullable
as int,disconnectedPlayersCount: null == disconnectedPlayersCount ? _self.disconnectedPlayersCount : disconnectedPlayersCount // ignore: cast_nullable_to_non_nullable
as int,lastCleanupTime: freezed == lastCleanupTime ? _self.lastCleanupTime : lastCleanupTime // ignore: cast_nullable_to_non_nullable
as DateTime?,cleanupErrorsLastHour: null == cleanupErrorsLastHour ? _self.cleanupErrorsLastHour : cleanupErrorsLastHour // ignore: cast_nullable_to_non_nullable
as int,circuitBreakerActive: null == circuitBreakerActive ? _self.circuitBreakerActive : circuitBreakerActive // ignore: cast_nullable_to_non_nullable
as bool,cronJobs: null == cronJobs ? _self._cronJobs : cronJobs // ignore: cast_nullable_to_non_nullable
as List<CronJobInfo>,
  ));
}


}


/// @nodoc
mixin _$CronJobInfo {

 String get jobName; String get schedule; bool get active;
/// Create a copy of CronJobInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CronJobInfoCopyWith<CronJobInfo> get copyWith => _$CronJobInfoCopyWithImpl<CronJobInfo>(this as CronJobInfo, _$identity);

  /// Serializes this CronJobInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CronJobInfo&&(identical(other.jobName, jobName) || other.jobName == jobName)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobName,schedule,active);

@override
String toString() {
  return 'CronJobInfo(jobName: $jobName, schedule: $schedule, active: $active)';
}


}

/// @nodoc
abstract mixin class $CronJobInfoCopyWith<$Res>  {
  factory $CronJobInfoCopyWith(CronJobInfo value, $Res Function(CronJobInfo) _then) = _$CronJobInfoCopyWithImpl;
@useResult
$Res call({
 String jobName, String schedule, bool active
});




}
/// @nodoc
class _$CronJobInfoCopyWithImpl<$Res>
    implements $CronJobInfoCopyWith<$Res> {
  _$CronJobInfoCopyWithImpl(this._self, this._then);

  final CronJobInfo _self;
  final $Res Function(CronJobInfo) _then;

/// Create a copy of CronJobInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobName = null,Object? schedule = null,Object? active = null,}) {
  return _then(_self.copyWith(
jobName: null == jobName ? _self.jobName : jobName // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CronJobInfo].
extension CronJobInfoPatterns on CronJobInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CronJobInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CronJobInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CronJobInfo value)  $default,){
final _that = this;
switch (_that) {
case _CronJobInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CronJobInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CronJobInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobName,  String schedule,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CronJobInfo() when $default != null:
return $default(_that.jobName,_that.schedule,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobName,  String schedule,  bool active)  $default,) {final _that = this;
switch (_that) {
case _CronJobInfo():
return $default(_that.jobName,_that.schedule,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobName,  String schedule,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _CronJobInfo() when $default != null:
return $default(_that.jobName,_that.schedule,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CronJobInfo implements CronJobInfo {
  const _CronJobInfo({required this.jobName, required this.schedule, required this.active});
  factory _CronJobInfo.fromJson(Map<String, dynamic> json) => _$CronJobInfoFromJson(json);

@override final  String jobName;
@override final  String schedule;
@override final  bool active;

/// Create a copy of CronJobInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CronJobInfoCopyWith<_CronJobInfo> get copyWith => __$CronJobInfoCopyWithImpl<_CronJobInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CronJobInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CronJobInfo&&(identical(other.jobName, jobName) || other.jobName == jobName)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobName,schedule,active);

@override
String toString() {
  return 'CronJobInfo(jobName: $jobName, schedule: $schedule, active: $active)';
}


}

/// @nodoc
abstract mixin class _$CronJobInfoCopyWith<$Res> implements $CronJobInfoCopyWith<$Res> {
  factory _$CronJobInfoCopyWith(_CronJobInfo value, $Res Function(_CronJobInfo) _then) = __$CronJobInfoCopyWithImpl;
@override @useResult
$Res call({
 String jobName, String schedule, bool active
});




}
/// @nodoc
class __$CronJobInfoCopyWithImpl<$Res>
    implements _$CronJobInfoCopyWith<$Res> {
  __$CronJobInfoCopyWithImpl(this._self, this._then);

  final _CronJobInfo _self;
  final $Res Function(_CronJobInfo) _then;

/// Create a copy of CronJobInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobName = null,Object? schedule = null,Object? active = null,}) {
  return _then(_CronJobInfo(
jobName: null == jobName ? _self.jobName : jobName // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
