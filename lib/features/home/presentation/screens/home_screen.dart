import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/ojyx_logo.dart';
import '../widgets/animated_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({this.redirectUrl, super.key});

  final String? redirectUrl;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _animationController.forward();
    
    // Load app version
    _loadAppVersion();
    
    // Handle redirect after auth is complete
    if (widget.redirectUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndRedirect();
      });
    }
  }
  
  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = 'v${packageInfo.version}';
        });
      }
    } catch (e) {
      // Fallback to version from pubspec
      if (mounted) {
        setState(() {
          _appVersion = 'v1.0.0';
        });
      }
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAndRedirect() {
    final authState = ref.read(authNotifierProvider);
    authState.whenData((user) {
      if (user != null && widget.redirectUrl != null && mounted) {
        // Decode and redirect
        context.go(Uri.decodeComponent(widget.redirectUrl!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Listen for auth changes to handle redirect
    ref.listen(authNotifierProvider, (previous, next) {
      if (widget.redirectUrl != null &&
          previous?.valueOrNull == null &&
          next.valueOrNull != null) {
        // User just authenticated, redirect
        context.go(Uri.decodeComponent(widget.redirectUrl!));
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;
              final contentWidth = isTablet ? 500.0 : 400.0;
              
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),
                    // Logo/Title with Animation
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Column(
                              children: [
                                const OjyxLogo(size: 120),
                                const SizedBox(height: 24),
                                Text(
                                  'OJYX',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 8,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Le jeu de cartes stratégique',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 48),

                    // Show redirect notice if present
                    if (widget.redirectUrl != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Connexion requise pour continuer',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Loading or buttons
                    authState.when(
                      data: (user) {
                        if (user == null) {
                          return Column(
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                'Connexion en cours...',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            // Create Room Button
                            AnimatedButton(
                              onPressed: () => context.go('/create-room'),
                              icon: Icons.add,
                              label: 'Créer une partie',
                              variant: AnimatedButtonVariant.elevated,
                              delay: const Duration(milliseconds: 1600),
                            ),
                            const SizedBox(height: 16),

                            // Join Room Button
                            AnimatedButton(
                              onPressed: () => context.go('/join-room'),
                              icon: Icons.login,
                              label: 'Rejoindre une partie',
                              variant: AnimatedButtonVariant.outlined,
                              delay: const Duration(milliseconds: 1700),
                            ),
                            const SizedBox(height: 16),

                            // Rules Button
                            AnimatedButton(
                              onPressed: () => context.go('/rules'),
                              icon: Icons.help_outline,
                              label: 'Règles du Jeu',
                              variant: AnimatedButtonVariant.text,
                              delay: const Duration(milliseconds: 1800),
                            ),
                            const SizedBox(height: 32),

                            // User info
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Joueur anonyme',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                        Text(
                                          'ID: ${user.id.substring(0, 8)}...',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.6),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur de connexion',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.refresh(authNotifierProvider),
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                        const Spacer(flex: 2),
                        
                        // Footer with version
                        if (_appVersion.isNotEmpty)
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              _appVersion,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
