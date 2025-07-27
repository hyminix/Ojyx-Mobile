import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../errors/supabase_exceptions.dart';

/// Comprehensive extensions for SupabaseClient to provide safe operations with error handling
extension SupabaseClientExtensions on SupabaseClient {
  // ===== Database Operations =====
  
  /// Safely execute a select query with error handling and retry
  Future<List<Map<String, dynamic>>> safeSelect(
    String table, {
    String columns = '*',
    Map<String, dynamic>? context,
    int maxRetries = 3,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).select(columns),
      operation: 'select_$table',
      context: context,
      maxRetries: maxRetries,
    );
  }

  /// Safely execute a single row select
  Future<Map<String, dynamic>> safeSelectSingle(
    String table, {
    String columns = '*',
    Map<String, dynamic>? context,
    int maxRetries = 3,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).select(columns).single(),
      operation: 'select_single_$table',
      context: context,
      maxRetries: maxRetries,
    );
  }

  /// Safely execute a select with filters
  Future<List<Map<String, dynamic>>> safeSelectWhere(
    String table, {
    required String column,
    required dynamic value,
    String columns = '*',
    Map<String, dynamic>? context,
    int maxRetries = 3,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).select(columns).eq(column, value),
      operation: 'select_where_$table',
      context: {
        'filter_column': column,
        'filter_value': value.toString(),
        ...?context,
      },
      maxRetries: maxRetries,
    );
  }

  /// Safely insert data with error handling
  Future<List<Map<String, dynamic>>> safeInsert(
    String table,
    Map<String, dynamic> data, {
    Map<String, dynamic>? context,
    bool upsert = false,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => upsert 
          ? from(table).upsert(data).select()
          : from(table).insert(data).select(),
      operation: upsert ? 'upsert_$table' : 'insert_$table',
      context: context,
      maxRetries: 1, // Don't retry inserts by default
    );
  }

  /// Safely insert multiple rows
  Future<List<Map<String, dynamic>>> safeInsertMany(
    String table,
    List<Map<String, dynamic>> rows, {
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).insert(rows).select(),
      operation: 'insert_many_$table',
      context: {
        'row_count': rows.length,
        ...?context,
      },
      maxRetries: 1,
    );
  }

  /// Safely update data with error handling
  Future<List<Map<String, dynamic>>> safeUpdate(
    String table,
    Map<String, dynamic> data, {
    required Map<String, Object> match,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).update(data).match(match).select(),
      operation: 'update_$table',
      context: context,
      maxRetries: 1, // Don't retry updates by default
    );
  }

  /// Safely delete data with error handling
  Future<List<Map<String, dynamic>>> safeDelete(
    String table, {
    required Map<String, Object> match,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).delete().match(match).select(),
      operation: 'delete_$table',
      context: context,
      maxRetries: 1, // Don't retry deletes by default
    );
  }
  
  /// Safely execute RPC with retry for read operations
  Future<T> safeRpc<T>(
    String functionName, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? context,
    int maxRetries = 3,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => rpc(functionName, params: params),
      operation: 'rpc_$functionName',
      context: context,
      maxRetries: maxRetries,
    );
  }

  // ===== Auth Operations =====
  
  /// Safely sign in with email and password
  Future<AuthResponse> safeSignInWithPassword({
    required String email,
    required String password,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => auth.signInWithPassword(
        email: email,
        password: password,
      ),
      operation: 'auth_sign_in',
      context: {
        'method': 'password',
        ...?context,
      },
      maxRetries: 1, // Don't retry auth operations
    );
  }

  /// Safely sign up a new user
  Future<AuthResponse> safeSignUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => auth.signUp(
        email: email,
        password: password,
        data: data,
      ),
      operation: 'auth_sign_up',
      context: context,
      maxRetries: 1,
    );
  }

  /// Safely sign out
  Future<void> safeSignOut({
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => auth.signOut(),
      operation: 'auth_sign_out',
      context: context,
      maxRetries: 1,
    );
  }

  /// Safely get current user
  User? get safeCurrentUser {
    try {
      return auth.currentUser;
    } catch (e) {
      // Log error but don't throw - return null instead
      return null;
    }
  }

  /// Safely refresh session
  Future<AuthResponse> safeRefreshSession({
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => auth.refreshSession(),
      operation: 'auth_refresh_session',
      context: context,
      maxRetries: 2, // Allow one retry for refresh
    );
  }

  // ===== Storage Operations =====
  
  /// Safely upload a file to storage
  Future<String> safeUploadFile(
    String bucket,
    String path,
    List<int> fileBytes, {
    FileOptions? fileOptions,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => storage.from(bucket).uploadBinary(
        path,
        fileBytes,
        fileOptions: fileOptions,
      ),
      operation: 'storage_upload',
      context: {
        'bucket': bucket,
        'path': path,
        'size_bytes': fileBytes.length,
        ...?context,
      },
      maxRetries: 2, // Allow retry for network issues
    );
  }

  /// Safely download a file from storage
  Future<List<int>> safeDownloadFile(
    String bucket,
    String path, {
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => storage.from(bucket).download(path),
      operation: 'storage_download',
      context: {
        'bucket': bucket,
        'path': path,
        ...?context,
      },
      maxRetries: 3, // Allow retries for downloads
    );
  }

  /// Safely get public URL for a file
  String safeGetPublicUrl(
    String bucket,
    String path, {
    TransformOptions? transform,
  }) {
    try {
      return storage.from(bucket).getPublicUrl(path, transform: transform);
    } catch (e) {
      // For URL generation, return empty string on error
      return '';
    }
  }

  /// Safely delete a file from storage
  Future<List<FileObject>> safeRemoveFile(
    String bucket,
    List<String> paths, {
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => storage.from(bucket).remove(paths),
      operation: 'storage_remove',
      context: {
        'bucket': bucket,
        'paths': paths,
        ...?context,
      },
      maxRetries: 1, // Don't retry deletes
    );
  }

  /// Safely list files in storage
  Future<List<FileObject>> safeListFiles(
    String bucket, {
    String? path,
    SearchOptions? searchOptions,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => storage.from(bucket).list(
        path: path,
        searchOptions: searchOptions,
      ),
      operation: 'storage_list',
      context: {
        'bucket': bucket,
        'path': path,
        ...?context,
      },
      maxRetries: 3,
    );
  }

  // ===== Realtime Operations =====
  
  /// Create a safe realtime channel
  RealtimeChannel safeChannel(
    String name, {
    RealtimeChannelConfig? params,
  }) {
    try {
      return channel(name, params: params);
    } catch (e) {
      // For channel creation, return a dummy channel that won't connect
      throw Exception('Failed to create channel: $e');
    }
  }

  /// Safely subscribe to a table's changes
  RealtimeChannel safeFromTable(
    String table, {
    String? schema,
    Map<String, dynamic>? filter,
  }) {
    try {
      final channel = safeChannel('db-changes-$table');
      
      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: schema ?? 'public',
        table: table,
        filter: filter != null 
            ? filter.entries.map((e) => '${e.key}=eq.${e.value}').join('&')
            : null,
        callback: (payload) {
          // Callback will be set by the caller
        },
      );
      
      return channel;
    } catch (e) {
      throw Exception('Failed to subscribe to table $table: $e');
    }
  }

  // ===== Utility Methods =====
  
  /// Execute a transaction-like operation (multiple operations that should all succeed)
  Future<T> safeTransaction<T>(
    Future<T> Function() operations, {
    required String operationName,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: operations,
      operation: 'transaction_$operationName',
      context: {
        'transaction': true,
        ...?context,
      },
      maxRetries: 1, // Don't retry transactions
    );
  }

  /// Check connection status safely
  Future<bool> checkConnection() async {
    try {
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => from('_test_connection').select().limit(1),
        operation: 'check_connection',
        maxRetries: 1,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Extension for safe realtime channel operations
extension RealtimeChannelExtensions on RealtimeChannel {
  /// Safely subscribe to channel with error handling
  Future<void> safeSubscribe({
    void Function()? onSuccess,
    void Function(dynamic error)? onError,
  }) async {
    try {
      await subscribe();
      onSuccess?.call();
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }

  /// Safely unsubscribe from channel
  Future<void> safeUnsubscribe() async {
    try {
      await unsubscribe();
    } catch (e) {
      // Log but don't throw - unsubscribe errors are usually not critical
    }
  }
}

/// Extension for PostgrestFilterBuilder to add safe operations
extension PostgrestFilterBuilderExtensions<T> on PostgrestFilterBuilder<T> {
  /// Execute the query with error handling
  Future<T> safeExecute({
    required String operation,
    Map<String, dynamic>? context,
    int maxRetries = 3,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => this as Future<T>,
      operation: operation,
      context: context,
      maxRetries: maxRetries,
    );
  }
}