import 'dart:async';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder<T> extends Mock implements PostgrestFilterBuilder<T> {}
class MockPostgrestTransformBuilder<T> extends Mock implements PostgrestTransformBuilder<T> {}
class MockPostgrestResponse extends Mock implements PostgrestResponse {}

// Fake implementation that acts as both PostgrestFilterBuilder and Future
class FakeRpcResponse<T> extends Fake implements PostgrestFilterBuilder<T>, Future<T> {
  final T _value;
  final List<void Function()> _listeners = [];
  
  FakeRpcResponse(this._value);
  
  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) async {
    return onValue(_value);
  }
  
  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) async => _value;
  
  @override
  Future<T> whenComplete(FutureOr<void> Function() action) async {
    await action();
    return _value;
  }
  
  @override
  Stream<T> asStream() => Stream.value(_value);
  
  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) async => _value;
}