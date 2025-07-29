import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration des alertes intelligentes Sentry pour le multijoueur
class SentryAlertsConfig {
  static const String _baseUrl = 'https://sentry.io/api/0';
  
  /// Initialise les alertes Sentry pour le multijoueur
  static Future<void> setupMultiplayerAlerts() async {
    if (kDebugMode) {
      debugPrint('SentryAlertsConfig: Skipping alerts setup in debug mode');
      return;
    }
    
    final organizationSlug = dotenv.env['SENTRY_ORGANIZATION'];
    final projectSlug = dotenv.env['SENTRY_PROJECT'];
    final authToken = dotenv.env['SENTRY_AUTH_TOKEN'];
    
    if (organizationSlug == null || projectSlug == null || authToken == null) {
      debugPrint('SentryAlertsConfig: Missing Sentry configuration');
      return;
    }
    
    try {
      // Configuration des alertes
      final alerts = _getAlertConfigurations();
      
      for (final alert in alerts) {
        await _createOrUpdateAlert(
          organizationSlug: organizationSlug,
          projectSlug: projectSlug,
          authToken: authToken,
          alertConfig: alert,
        );
      }
      
      debugPrint('SentryAlertsConfig: Successfully configured ${alerts.length} alerts');
    } catch (e) {
      debugPrint('SentryAlertsConfig: Failed to setup alerts - $e');
    }
  }
  
  /// Retourne les configurations d'alertes
  static List<Map<String, dynamic>> _getAlertConfigurations() {
    return [
      {
        'name': 'Multiplayer Sync Errors Spike',
        'dataset': 'error',
        'query': 'error.type:multiplayer.sync',
        'timeWindow': 5, // minutes
        'conditions': [
          {
            'id': 'sentry.rules.conditions.event_frequency.EventFrequencyCondition',
            'value': 10,
            'interval': '5m',
          }
        ],
        'actions': [
          {
            'id': 'sentry.rules.actions.notify_event.NotifyEventAction',
            'targetType': 'IssueOwners',
            'fallthroughType': 'ActiveMembers',
          }
        ],
        'filters': [
          {
            'id': 'sentry.rules.filters.tagged_event.TaggedEventFilter',
            'key': 'error.type',
            'match': 'eq',
            'value': 'multiplayer.sync',
          }
        ],
        'environment': null,
        'frequency': 30,
      },
      
      {
        'name': 'Critical Multiplayer Inconsistencies',
        'dataset': 'error',
        'query': 'error.type:multiplayer.inconsistency level:warning',
        'timeWindow': 10, // minutes
        'conditions': [
          {
            'id': 'sentry.rules.conditions.event_frequency.EventFrequencyCondition',
            'value': 5,
            'interval': '10m',
          }
        ],
        'actions': [
          {
            'id': 'sentry.rules.actions.notify_event.NotifyEventAction',
            'targetType': 'IssueOwners',
            'fallthroughType': 'ActiveMembers',
          }
        ],
        'filters': [
          {
            'id': 'sentry.rules.filters.tagged_event.TaggedEventFilter',
            'key': 'error.type',
            'match': 'eq',
            'value': 'multiplayer.inconsistency',
          },
          {
            'id': 'sentry.rules.filters.level.LevelFilter',
            'match': 'gte',
            'level': '30', // Warning level
          }
        ],
        'environment': null,
        'frequency': 60,
      },
      
      {
        'name': 'Multiplayer Connection Issues',
        'dataset': 'error',
        'query': 'error.type:multiplayer.connection',
        'timeWindow': 5, // minutes
        'conditions': [
          {
            'id': 'sentry.rules.conditions.event_frequency.EventFrequencyCondition',
            'value': 15,
            'interval': '5m',
          }
        ],
        'actions': [
          {
            'id': 'sentry.rules.actions.notify_event.NotifyEventAction',
            'targetType': 'IssueOwners',
            'fallthroughType': 'ActiveMembers',
          }
        ],
        'filters': [
          {
            'id': 'sentry.rules.filters.tagged_event.TaggedEventFilter',
            'key': 'error.type',
            'match': 'eq',
            'value': 'multiplayer.connection',
          }
        ],
        'environment': null,
        'frequency': 15,
      },
      
      {
        'name': 'Slow Multiplayer Operations',
        'dataset': 'error',
        'query': 'error.type:multiplayer.performance performance.slow:true',
        'timeWindow': 15, // minutes
        'conditions': [
          {
            'id': 'sentry.rules.conditions.event_frequency.EventFrequencyCondition',
            'value': 20,
            'interval': '15m',
          }
        ],
        'actions': [
          {
            'id': 'sentry.rules.actions.notify_event.NotifyEventAction',
            'targetType': 'IssueOwners',
            'fallthroughType': 'ActiveMembers',
          }
        ],
        'filters': [
          {
            'id': 'sentry.rules.filters.tagged_event.TaggedEventFilter',
            'key': 'error.type',
            'match': 'eq',
            'value': 'multiplayer.performance',
          },
          {
            'id': 'sentry.rules.filters.tagged_event.TaggedEventFilter',
            'key': 'performance.slow',
            'match': 'eq',
            'value': 'true',
          }
        ],
        'environment': null,
        'frequency': 60,
      },
      
      {
        'name': 'Room Capacity Exceeded',
        'dataset': 'error',
        'query': 'message:"RoomCapacityException"',
        'timeWindow': 10, // minutes
        'conditions': [
          {
            'id': 'sentry.rules.conditions.event_frequency.EventFrequencyCondition',
            'value': 3,
            'interval': '10m',
          }
        ],
        'actions': [
          {
            'id': 'sentry.rules.actions.notify_event.NotifyEventAction',
            'targetType': 'IssueOwners',
            'fallthroughType': 'ActiveMembers',
          }
        ],
        'filters': [
          {
            'id': 'sentry.rules.filters.message_event.MessageFilter',
            'match': 'co',
            'value': 'RoomCapacityException',
          }
        ],
        'environment': null,
        'frequency': 30,
      },
    ];
  }
  
  /// Crée ou met à jour une alerte
  static Future<void> _createOrUpdateAlert({
    required String organizationSlug,
    required String projectSlug,
    required String authToken,
    required Map<String, dynamic> alertConfig,
  }) async {
    final url = Uri.parse('$_baseUrl/projects/$organizationSlug/$projectSlug/rules/');
    
    final headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };
    
    final body = jsonEncode({
      'name': alertConfig['name'],
      'actionMatch': 'any',
      'filterMatch': 'all',
      'conditions': alertConfig['conditions'],
      'actions': alertConfig['actions'],
      'filters': alertConfig['filters'],
      'environment': alertConfig['environment'],
      'frequency': alertConfig['frequency'],
    });
    
    try {
      final response = await http.post(url, headers: headers, body: body);
      
      if (response.statusCode == 201) {
        debugPrint('SentryAlertsConfig: Created alert "${alertConfig['name']}"');
      } else if (response.statusCode == 400) {
        // Essayer de mettre à jour l'alerte existante
        await _updateExistingAlert(
          organizationSlug: organizationSlug,
          projectSlug: projectSlug,
          authToken: authToken,
          alertConfig: alertConfig,
        );
      } else {
        debugPrint('SentryAlertsConfig: Failed to create alert "${alertConfig['name']}" - ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('SentryAlertsConfig: Error creating alert "${alertConfig['name']}" - $e');
    }
  }
  
  /// Met à jour une alerte existante
  static Future<void> _updateExistingAlert({
    required String organizationSlug,
    required String projectSlug,
    required String authToken,
    required Map<String, dynamic> alertConfig,
  }) async {
    try {
      // Récupérer la liste des alertes existantes
      final listUrl = Uri.parse('$_baseUrl/projects/$organizationSlug/$projectSlug/rules/');
      final listResponse = await http.get(listUrl, headers: {
        'Authorization': 'Bearer $authToken',
      });
      
      if (listResponse.statusCode == 200) {
        final rules = jsonDecode(listResponse.body) as List;
        final existingRule = rules.firstWhere(
          (rule) => rule['name'] == alertConfig['name'],
          orElse: () => null,
        );
        
        if (existingRule != null) {
          final updateUrl = Uri.parse('$_baseUrl/projects/$organizationSlug/$projectSlug/rules/${existingRule['id']}/');
          
          final updateBody = jsonEncode({
            'name': alertConfig['name'],
            'actionMatch': 'any',
            'filterMatch': 'all',
            'conditions': alertConfig['conditions'],
            'actions': alertConfig['actions'],
            'filters': alertConfig['filters'],
            'environment': alertConfig['environment'],
            'frequency': alertConfig['frequency'],
          });
          
          final updateResponse = await http.put(
            updateUrl,
            headers: {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json',
            },
            body: updateBody,
          );
          
          if (updateResponse.statusCode == 200) {
            debugPrint('SentryAlertsConfig: Updated alert "${alertConfig['name']}"');
          } else {
            debugPrint('SentryAlertsConfig: Failed to update alert "${alertConfig['name']}" - ${updateResponse.statusCode}');
          }
        }
      }
    } catch (e) {
      debugPrint('SentryAlertsConfig: Error updating alert "${alertConfig['name']}" - $e');
    }
  }
  
  /// Configure les webhook pour les notifications externes
  static Future<void> setupWebhooks({
    required String organizationSlug,
    required String projectSlug,
    required String authToken,
    String? discordWebhookUrl,
    String? slackWebhookUrl,
  }) async {
    if (discordWebhookUrl != null) {
      await _createWebhook(
        organizationSlug: organizationSlug,
        projectSlug: projectSlug,
        authToken: authToken,
        webhookUrl: discordWebhookUrl,
        name: 'Discord Multiplayer Alerts',
      );
    }
    
    if (slackWebhookUrl != null) {
      await _createWebhook(
        organizationSlug: organizationSlug,
        projectSlug: projectSlug,
        authToken: authToken,
        webhookUrl: slackWebhookUrl,
        name: 'Slack Multiplayer Alerts',
      );
    }
  }
  
  /// Crée un webhook
  static Future<void> _createWebhook({
    required String organizationSlug,
    required String projectSlug,
    required String authToken,
    required String webhookUrl,
    required String name,
  }) async {
    final url = Uri.parse('$_baseUrl/projects/$organizationSlug/$projectSlug/plugins/webhooks/');
    
    final body = jsonEncode({
      'url': webhookUrl,
      'name': name,
      'events': ['issue.created', 'issue.resolved', 'issue.assigned'],
    });
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      
      if (response.statusCode == 201) {
        debugPrint('SentryAlertsConfig: Created webhook "$name"');
      } else {
        debugPrint('SentryAlertsConfig: Failed to create webhook "$name" - ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('SentryAlertsConfig: Error creating webhook "$name" - $e');
    }
  }
  
  /// Configure les métriques personnalisées
  static Future<void> setupCustomMetrics({
    required String organizationSlug,
    required String authToken,
  }) async {
    final metrics = [
      {
        'name': 'multiplayer.sync_errors',
        'unit': 'count',
        'description': 'Number of synchronization errors in multiplayer games',
        'tags': ['room_id', 'player_id', 'error_type'],
      },
      {
        'name': 'multiplayer.inconsistencies',
        'unit': 'count',
        'description': 'Number of data inconsistencies detected',
        'tags': ['room_id', 'inconsistency_type', 'severity'],
      },
      {
        'name': 'multiplayer.operation_duration',
        'unit': 'millisecond',
        'description': 'Duration of multiplayer operations',
        'tags': ['operation', 'room_id', 'is_slow'],
      },
      {
        'name': 'multiplayer.active_sessions',
        'unit': 'gauge',
        'description': 'Number of active multiplayer sessions',
        'tags': ['room_status'],
      },
    ];
    
    for (final metric in metrics) {
      await _createCustomMetric(
        organizationSlug: organizationSlug,
        authToken: authToken,
        metricConfig: metric,
      );
    }
  }
  
  /// Crée une métrique personnalisée
  static Future<void> _createCustomMetric({
    required String organizationSlug,
    required String authToken,
    required Map<String, dynamic> metricConfig,
  }) async {
    final url = Uri.parse('$_baseUrl/organizations/$organizationSlug/metrics/');
    
    final body = jsonEncode(metricConfig);
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      
      if (response.statusCode == 201) {
        debugPrint('SentryAlertsConfig: Created metric "${metricConfig['name']}"');
      } else {
        debugPrint('SentryAlertsConfig: Failed to create metric "${metricConfig['name']}" - ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('SentryAlertsConfig: Error creating metric "${metricConfig['name']}" - $e');
    }
  }
}