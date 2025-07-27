// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NetworkError _$NetworkErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_NetworkError', json, ($checkedConvert) {
      final val = _NetworkError(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        details: $checkedConvert('details', (v) => v as String?),
        operation: $checkedConvert('operation', (v) => v as String),
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
        statusCode: $checkedConvert('status_code', (v) => (v as num?)?.toInt()),
        timeout: $checkedConvert(
          'timeout',
          (v) => v == null ? null : Duration(microseconds: (v as num).toInt()),
        ),
      );
      return val;
    }, fieldKeyMap: const {'statusCode': 'status_code'});

Map<String, dynamic> _$NetworkErrorToJson(_NetworkError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'operation': instance.operation,
      'timestamp': instance.timestamp.toIso8601String(),
      'status_code': instance.statusCode,
      'timeout': instance.timeout?.inMicroseconds,
    };

_AuthError _$AuthErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AuthError', json, ($checkedConvert) {
      final val = _AuthError(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        details: $checkedConvert('details', (v) => v as String?),
        operation: $checkedConvert('operation', (v) => v as String),
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
        userId: $checkedConvert('user_id', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'userId': 'user_id'});

Map<String, dynamic> _$AuthErrorToJson(_AuthError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'operation': instance.operation,
      'timestamp': instance.timestamp.toIso8601String(),
      'user_id': instance.userId,
    };

_DatabaseError _$DatabaseErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DatabaseError', json, ($checkedConvert) {
      final val = _DatabaseError(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        details: $checkedConvert('details', (v) => v as String?),
        operation: $checkedConvert('operation', (v) => v as String),
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
        table: $checkedConvert('table', (v) => v as String?),
        constraint: $checkedConvert('constraint', (v) => v as String?),
        queryParams: $checkedConvert(
          'query_params',
          (v) => v as Map<String, dynamic>?,
        ),
      );
      return val;
    }, fieldKeyMap: const {'queryParams': 'query_params'});

Map<String, dynamic> _$DatabaseErrorToJson(_DatabaseError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'operation': instance.operation,
      'timestamp': instance.timestamp.toIso8601String(),
      'table': instance.table,
      'constraint': instance.constraint,
      'query_params': instance.queryParams,
    };

_StorageError _$StorageErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_StorageError', json, ($checkedConvert) {
      final val = _StorageError(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        details: $checkedConvert('details', (v) => v as String?),
        operation: $checkedConvert('operation', (v) => v as String),
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
        bucket: $checkedConvert('bucket', (v) => v as String?),
        path: $checkedConvert('path', (v) => v as String?),
        sizeLimit: $checkedConvert('size_limit', (v) => (v as num?)?.toInt()),
      );
      return val;
    }, fieldKeyMap: const {'sizeLimit': 'size_limit'});

Map<String, dynamic> _$StorageErrorToJson(_StorageError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'operation': instance.operation,
      'timestamp': instance.timestamp.toIso8601String(),
      'bucket': instance.bucket,
      'path': instance.path,
      'size_limit': instance.sizeLimit,
    };
