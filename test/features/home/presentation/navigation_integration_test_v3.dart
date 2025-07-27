import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';
import 'package:ojyx/core/config/router_config.dart';
import 'package:flutter/material.dart';
import '../../../helpers/supabase_test_helpers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-id';
}

void main() {
  group('Navigation Integration Test', () {
    late MockSupabaseClient mockSupabaseClient;
    late MockGoTrueClient mockAuth;

    setUp(() {
      mockSupabaseClient = createMockSupabaseClient();
      mockAuth = MockGoTrueClient();

      when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    });

    testWidgets('should navigate from home to create room', (tester) async {
      // Arrange
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supabaseClientProvider.overrideWithValue(mockSupabaseClient),
          ],
          child: Consumer(
            builder: (context, ref, child) {
              final router = ref.watch(routerProvider);
              return MaterialApp.router(routerConfig: router);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify we're on home screen
      expect(find.text('OJYX'), findsOneWidget);

      // Tap create room button
      await tester.tap(find.text('Créer une partie'));
      await tester.pumpAndSettle();

      // Verify navigation happened (we should see create room screen content)
      expect(find.text('Nombre de joueurs'), findsOneWidget);
    });

    testWidgets('should show all routes are configured', (tester) async {
      // Arrange
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supabaseClientProvider.overrideWithValue(mockSupabaseClient),
          ],
          child: Consumer(
            builder: (context, ref, child) {
              final router = ref.watch(routerProvider);

              // Test that all routes are properly configured
              expect(router.configuration.routes.length, greaterThan(0));

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
