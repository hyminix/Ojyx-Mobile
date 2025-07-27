import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/main.dart';

void main() {
  testWidgets('App démarre sans crash', (tester) async {
    // Test de fumée simple : l'app se lance
    await tester.pumpWidget(
      const ProviderScope(
        child: OjyxApp(),
      ),
    );
    
    // On attend un peu pour laisser l'app s'initialiser
    await tester.pump(const Duration(seconds: 1));
    
    // Si on arrive ici, c'est que l'app n'a pas crashé
    expect(find.byType(OjyxApp), findsOneWidget);
  });
}