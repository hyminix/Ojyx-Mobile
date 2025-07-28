-- =====================================================
-- REQUÊTES DE MONITORING SUPABASE POUR OJYX
-- =====================================================
-- À copier dans le SQL Editor du dashboard Supabase
-- ou à utiliser via des cron jobs pour alertes

-- 1. MONITORING DES VIOLATIONS RLS (dernière heure)
-- ----------------------------------------------------
SELECT 
  table_name,
  period_start,
  anonymous_violations,
  authenticated_violations,
  anonymous_violations + authenticated_violations as total_violations
FROM v_rls_violations_monitor
ORDER BY total_violations DESC;

-- 2. DÉTECTION DES REQUÊTES LENTES (potentiel N+1)
-- ----------------------------------------------------
SELECT * FROM detect_n_plus_one_queries();

-- 3. PERFORMANCE DES POLICIES RLS
-- ----------------------------------------------------
-- Policies non optimisées
SELECT 
  table_name,
  policy_name,
  operation,
  optimization_status
FROM v_policy_performance_metrics
WHERE optimization_status = 'NOT_OPTIMIZED'
ORDER BY table_name, policy_name;

-- Analyse de complexité des policies
SELECT * FROM check_policy_performance(50)
WHERE estimated_cost IN ('HIGH', 'MEDIUM');

-- 4. MÉTRIQUES DES PARTIES ACTIVES
-- ----------------------------------------------------
SELECT 
  active_games,
  active_rooms,
  active_players,
  ROUND(avg_turn_number::numeric, 1) as avg_turns,
  max_turn_number as longest_game_turns,
  games_last_hour as new_games_1h,
  games_in_last_round
FROM v_active_games_stats;

-- 5. MONITORING DES CONNEXIONS
-- ----------------------------------------------------
-- Joueurs par statut de connexion
SELECT 
  connection_status,
  COUNT(*) as player_count,
  COUNT(*) FILTER (WHERE last_seen_at > NOW() - INTERVAL '5 minutes') as active_5min,
  COUNT(*) FILTER (WHERE last_seen_at > NOW() - INTERVAL '1 hour') as active_1h
FROM players
GROUP BY connection_status
ORDER BY player_count DESC;

-- Rooms orphelines (sans joueurs actifs)
SELECT 
  r.id,
  r.code,
  r.status,
  r.created_at,
  r.updated_at,
  array_length(r.player_ids, 1) as player_count,
  COUNT(p.id) as active_players
FROM rooms r
LEFT JOIN players p ON p.id = ANY(r.player_ids) AND p.connection_status = 'online'
WHERE r.status IN ('waiting', 'in_game')
GROUP BY r.id, r.code, r.status, r.created_at, r.updated_at, r.player_ids
HAVING COUNT(p.id) = 0
ORDER BY r.created_at DESC;

-- 6. ANALYSE DES PERFORMANCES GLOBALES
-- ----------------------------------------------------
SELECT 
  snapshot_time,
  online_players,
  waiting_rooms,
  active_rooms,
  active_games,
  ROUND(avg_game_duration_seconds / 60) as avg_game_duration_minutes,
  realtime_connections
FROM mv_performance_metrics
ORDER BY snapshot_time DESC
LIMIT 24; -- Dernières 24 heures si refresh horaire

-- 7. HISTORIQUE DES VIOLATIONS RLS
-- ----------------------------------------------------
SELECT 
  date_trunc('hour', violation_time) as hour,
  table_name,
  operation,
  COUNT(*) as violation_count,
  COUNT(DISTINCT user_id) as unique_users
FROM rls_violations_log
WHERE violation_time > NOW() - INTERVAL '7 days'
AND NOT resolved
GROUP BY date_trunc('hour', violation_time), table_name, operation
ORDER BY hour DESC, violation_count DESC;

-- 8. SANTÉ DES INDEX
-- ----------------------------------------------------
-- Index non utilisés récemment
SELECT 
  tablename,
  indexname,
  idx_scan as scan_count,
  idx_tup_read as tuples_read,
  pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
AND idx_scan < 10
ORDER BY pg_relation_size(indexrelid) DESC;

-- Tables avec beaucoup de sequential scans
SELECT 
  tablename,
  seq_scan,
  seq_tup_read,
  idx_scan,
  CASE 
    WHEN seq_scan > 0 THEN ROUND((seq_tup_read::numeric / seq_scan), 2)
    ELSE 0
  END as avg_rows_per_seq_scan,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as table_size
FROM pg_stat_user_tables
WHERE schemaname = 'public'
AND seq_scan > 1000
ORDER BY seq_scan DESC;

-- 9. DÉTECTION DES DEADLOCKS ET LOCKS LONGS
-- ----------------------------------------------------
-- Requêtes bloquées depuis plus de 5 secondes
SELECT 
  pid,
  usename,
  application_name,
  client_addr,
  query_start,
  state,
  wait_event_type,
  wait_event,
  SUBSTRING(query, 1, 100) as query_preview
FROM pg_stat_activity
WHERE state != 'idle'
AND query_start < NOW() - INTERVAL '5 seconds'
AND pid != pg_backend_pid()
ORDER BY query_start;

-- 10. TAILLE ET CROISSANCE DES TABLES
-- ----------------------------------------------------
SELECT 
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
  pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as table_size,
  pg_size_pretty(pg_indexes_size(schemaname||'.'||tablename)) as indexes_size,
  n_tup_ins as rows_inserted,
  n_tup_upd as rows_updated,
  n_tup_del as rows_deleted,
  n_live_tup as live_rows,
  n_dead_tup as dead_rows,
  ROUND(100.0 * n_dead_tup / NULLIF(n_live_tup, 0), 2) as dead_rows_percent
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- =====================================================
-- REQUÊTES D'ALERTE (À PLANIFIER EN CRON)
-- =====================================================

-- ALERTE 1: Violations RLS détectées
DO $$
DECLARE
  v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM rls_violations_log
  WHERE violation_time > NOW() - INTERVAL '1 hour'
  AND NOT resolved;
  
  IF v_count > 0 THEN
    PERFORM pg_notify('monitoring_alert', 
      json_build_object(
        'type', 'rls_violation',
        'count', v_count,
        'severity', 'high'
      )::text
    );
  END IF;
END $$;

-- ALERTE 2: Performance dégradée
DO $$
DECLARE
  v_slow_queries INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_slow_queries
  FROM pg_stat_activity
  WHERE state != 'idle'
  AND query_start < NOW() - INTERVAL '30 seconds';
  
  IF v_slow_queries > 5 THEN
    PERFORM pg_notify('monitoring_alert',
      json_build_object(
        'type', 'slow_queries',
        'count', v_slow_queries,
        'severity', 'medium'
      )::text
    );
  END IF;
END $$;

-- ALERTE 3: Trop de connexions simultanées
DO $$
DECLARE
  v_connections INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_connections
  FROM pg_stat_activity
  WHERE state != 'idle';
  
  IF v_connections > 50 THEN
    PERFORM pg_notify('monitoring_alert',
      json_build_object(
        'type', 'high_connections',
        'count', v_connections,
        'severity', 'medium'
      )::text
    );
  END IF;
END $$;

-- =====================================================
-- COMMANDES DE MAINTENANCE
-- =====================================================

-- Rafraîchir les métriques de performance
SELECT refresh_performance_metrics();

-- Nettoyer les vieilles violations RLS résolues
DELETE FROM rls_violations_log 
WHERE resolved = TRUE 
AND violation_time < NOW() - INTERVAL '30 days';

-- VACUUM et ANALYZE sur les tables principales
VACUUM ANALYZE players, rooms, game_states, player_grids;