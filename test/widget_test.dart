import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: OjyxApp()));
    await tester.pumpAndSettle();

    // Verify that the app starts with the home screen
    expect(find.text('Ojyx'), findsOneWidget);
  });
}
