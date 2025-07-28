import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/safe_ref_mixin.dart';
import '../providers/cleanup_monitoring_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> 
    with SafeRefMixin {
  @override
  void initState() {
    super.initState();
    // Rafraîchir les données toutes les 30 secondes
    Future.delayed(Duration.zero, () {
      ref.read(cleanupMonitoringProvider.notifier).startAutoRefresh();
    });
    
    // Register cleanup callback to stop auto-refresh on disposal
    // This is safe because we capture the notifier reference while widget is active
    addCleanupCallback(() {
      ref.read(cleanupMonitoringProvider.notifier).stopAutoRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final monitoringData = ref.watch(cleanupMonitoringProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Monitoring Système'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(cleanupMonitoringProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: monitoringData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(cleanupMonitoringProvider.notifier).refresh();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statut du circuit breaker
              if (data.circuitBreakerActive)
                Card(
                  color: Colors.red.shade100,
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: const Text('Circuit Breaker Actif'),
                    subtitle: Text('${data.cleanupErrorsLastHour} erreurs dans la dernière heure'),
                  ),
                ),
              
              // Statistiques des rooms
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistiques des Parties',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow('Parties actives', data.activeRoomsCount, Colors.green),
                      _buildStatRow('Parties inactives', data.inactiveRoomsCount, Colors.orange),
                      const SizedBox(height: 8),
                      if (data.lastCleanupTime != null)
                        Text(
                          'Dernier nettoyage: ${_formatDateTime(data.lastCleanupTime!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Statistiques des joueurs
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistiques des Joueurs',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow('Joueurs connectés', data.connectedPlayersCount, Colors.green),
                      _buildStatRow('Joueurs déconnectés', data.disconnectedPlayersCount, Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Jobs CRON
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jobs CRON',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ...data.cronJobs.map((job) => ListTile(
                        leading: Icon(
                          job.active ? Icons.check_circle : Icons.cancel,
                          color: job.active ? Colors.green : Colors.red,
                        ),
                        title: Text(job.jobName),
                        subtitle: Text('Schedule: ${job.schedule}'),
                        trailing: Text(job.active ? 'Actif' : 'Inactif'),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Actions
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showConfirmDialog(
                              context,
                              'Forcer le nettoyage',
                              'Voulez-vous forcer l\'exécution du nettoyage maintenant ?',
                              () {
                                ref.read(cleanupMonitoringProvider.notifier).forceCleanup();
                              },
                            );
                          },
                          icon: const Icon(Icons.cleaning_services),
                          label: const Text('Forcer le nettoyage'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.go('/admin/logs');
                          },
                          icon: const Icon(Icons.history),
                          label: const Text('Voir les logs détaillés'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Il y a quelques secondes';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} heures';
    } else {
      return 'Il y a ${difference.inDays} jours';
    }
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
