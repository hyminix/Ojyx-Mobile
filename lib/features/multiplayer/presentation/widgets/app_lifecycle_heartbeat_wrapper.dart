import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/room_providers.dart';

/// Widget that manages room heartbeat based on app lifecycle
class AppLifecycleHeartbeatWrapper extends ConsumerStatefulWidget {
  final Widget child;
  
  const AppLifecycleHeartbeatWrapper({
    super.key,
    required this.child,
  });
  
  @override
  ConsumerState<AppLifecycleHeartbeatWrapper> createState() => 
      _AppLifecycleHeartbeatWrapperState();
}

class _AppLifecycleHeartbeatWrapperState 
    extends ConsumerState<AppLifecycleHeartbeatWrapper> 
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final heartbeatController = ref.read(roomHeartbeatControllerProvider.notifier);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App returned to foreground
        heartbeatController.resumeHeartbeat();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App went to background
        heartbeatController.pauseHeartbeat();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App is being terminated or hidden
        heartbeatController.stopHeartbeat();
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}