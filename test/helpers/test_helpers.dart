import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mock GoRouter
class MockGoRouter extends Mock implements GoRouter {
  final List<String> pushedRoutes = [];
  final List<String> replacedRoutes = [];

  @override
  void go(String location, {Object? extra}) {
    pushedRoutes.add(location);
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    pushedRoutes.add(location);
    return null;
  }

  @override
  Future<T?> replace<T>(String location, {Object? extra}) async {
    replacedRoutes.add(location);
    return null;
  }
}

// Helper to create a test app with router
Widget createTestApp({required Widget child, GoRouter? router}) {
  if (router != null) {
    return MaterialApp.router(
      routerConfig: router,
      builder: (context, routerChild) => child,
    );
  }

  return MaterialApp(home: child);
}
