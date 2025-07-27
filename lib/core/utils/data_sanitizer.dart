import 'package:flutter/foundation.dart';

/// Utility class to sanitize sensitive data before logging or sending to external services
class DataSanitizer {
  // Patterns for sensitive data
  static final _emailPattern = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
  static final _phonePattern = RegExp(r'[\+]?[(]?[0-9]{1,3}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,4}[-\s\.]?[0-9]{1,9}');
  static final _creditCardPattern = RegExp(r'\b(?:\d[ -]*?){13,19}\b');
  static final _ssnPattern = RegExp(r'\b(?!000|666|9\d{2})\d{3}[-]?(?!00)\d{2}[-]?(?!0000)\d{4}\b');
  
  // Keys that often contain sensitive data
  static const _sensitiveKeys = {
    'password',
    'pwd',
    'pass',
    'secret',
    'token',
    'api_key',
    'apikey',
    'auth',
    'authorization',
    'credit_card',
    'creditcard',
    'card_number',
    'cardnumber',
    'cvv',
    'ssn',
    'social_security',
    'email',
    'phone',
    'mobile',
    'address',
    'birthdate',
    'dob',
  };

  /// Sanitizes a map of data by redacting sensitive information
  static Map<String, dynamic> sanitizeMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return {};
    
    final sanitized = <String, dynamic>{};
    
    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;
      
      // Check if key is sensitive
      if (_isSensitiveKey(key)) {
        sanitized[entry.key] = _redactValue(value);
      } else if (value is Map<String, dynamic>) {
        // Recursively sanitize nested maps
        sanitized[entry.key] = sanitizeMap(value);
      } else if (value is List) {
        // Sanitize lists
        sanitized[entry.key] = _sanitizeList(value);
      } else if (value is String) {
        // Check for sensitive patterns in string values
        sanitized[entry.key] = _sanitizeString(value);
      } else {
        // Keep non-sensitive primitive values
        sanitized[entry.key] = value;
      }
    }
    
    return sanitized;
  }

  /// Sanitizes a string by redacting sensitive patterns
  static String _sanitizeString(String value) {
    String sanitized = value;
    
    // Redact emails
    sanitized = sanitized.replaceAllMapped(_emailPattern, (match) => '***@***.***');
    
    // Redact phone numbers
    sanitized = sanitized.replaceAllMapped(_phonePattern, (match) => '***-***-****');
    
    // Redact credit card numbers
    sanitized = sanitized.replaceAllMapped(_creditCardPattern, (match) => '****-****-****-****');
    
    // Redact SSN
    sanitized = sanitized.replaceAllMapped(_ssnPattern, (match) => '***-**-****');
    
    return sanitized;
  }

  /// Sanitizes a list
  static List<dynamic> _sanitizeList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return sanitizeMap(item);
      } else if (item is String) {
        return _sanitizeString(item);
      } else if (item is List) {
        return _sanitizeList(item);
      }
      return item;
    }).toList();
  }

  /// Checks if a key name suggests sensitive data
  static bool _isSensitiveKey(String key) {
    final lowerKey = key.toLowerCase();
    return _sensitiveKeys.any((sensitive) => lowerKey.contains(sensitive));
  }

  /// Redacts a value based on its type
  static dynamic _redactValue(dynamic value) {
    if (value == null) return null;
    
    if (value is String) {
      // Show partial value for debugging (first 3 chars)
      if (value.length > 3) {
        return '${value.substring(0, 3)}${'*' * (value.length - 3)}';
      }
      return '*' * value.length;
    } else if (value is num) {
      // Keep the type but redact the value
      return value is int ? 0 : 0.0;
    } else if (value is bool) {
      return false; // Default to false for sensitive booleans
    } else if (value is List) {
      return ['***'];
    } else if (value is Map) {
      return {'***': '***'};
    }
    
    return '***';
  }

  /// Creates a debug-safe string representation of data
  static String toDebugString(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return '{}';
    
    final sanitized = sanitizeMap(data);
    
    // In debug mode, show more details
    if (kDebugMode) {
      return sanitized.toString();
    }
    
    // In release mode, be more conservative
    return '{data_size: ${data.length}}';
  }
}