import 'package:integration_test/integration_test.dart';
import 'migration_validation_test.dart' as migration_tests;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Run all integration test suites
  migration_tests.main();
}
