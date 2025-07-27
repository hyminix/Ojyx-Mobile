import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/core/theme/app_theme.dart';
import 'package:ojyx/core/config/router_config.dart';
import 'package:ojyx/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Mock classes for widget testing
class MockGoRouter extends Mock implements GoRouter {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

/// Test wrapper widget that provides necessary dependencies
class TestWrapper extends StatelessWidget {
  final Widget child;
  final List<Override> overrides;
  final GoRouter? router;
  final ThemeData? theme;
  final Locale? locale;
  
  const TestWrapper({
    Key? key,
    required this.child,
    this.overrides = const [],
    this.router,
    this.theme,
    this.locale,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
        locale: locale ?? const Locale('fr'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: router != null
        ? Router.withConfig(
            routerDelegate: router!.routerDelegate,
            routeInformationParser: router!.routeInformationParser,
            routeInformationProvider: router!.routeInformationProvider,
          )
        : child,
    ),
    );
  }
}

/// Extension methods for widget testing
extension WidgetTesterExtensions on WidgetTester {
  /// Pumps a widget wrapped with test dependencies
  Future<void> pumpTestWidget(
    Widget widget, {
    List<Override> overrides = const [],
    GoRouter? router,
    ThemeData? theme,
    Locale? locale,
  }) async {
    await pumpWidget(
      TestWrapper(
        child: widget,
        overrides: overrides,
        router: router,
        theme: theme,
        locale: locale,
      ),
    );
  }
  
  /// Pumps and settles with a maximum duration to prevent infinite animations
  Future<void> pumpAndSettleWithTimeout({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    await pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  }
  
  /// Taps a widget and waits for animations to complete
  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettleWithTimeout();
  }
  
  /// Enters text and waits for animations
  Future<void> enterTextAndSettle(Finder finder, String text) async {
    await enterText(finder, text);
    await pumpAndSettleWithTimeout();
  }
  
  /// Scrolls until a widget is visible
  Future<void> scrollUntilVisible(
    Finder finder, {
    double delta = 300,
    Finder? scrollable,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final scrollableFinder = scrollable ?? find.byType(Scrollable).last;
    
    await ensureVisible(finder);
    await pumpAndSettleWithTimeout();
  }
}

/// Common finders for widget testing
class CommonFinders {
  /// Finds a button by its text
  static Finder findButtonByText(String text) {
    return find.widgetWithText(ElevatedButton, text);
  }
  
  /// Finds a text button by its text
  static Finder findTextButtonByText(String text) {
    return find.widgetWithText(TextButton, text);
  }
  
  /// Finds an icon button by icon
  static Finder findIconButton(IconData icon) {
    return find.widgetWithIcon(IconButton, icon);
  }
  
  /// Finds a text field by label
  static Finder findTextFieldByLabel(String label) {
    return find.ancestor(
      of: find.text(label),
      matching: find.byType(TextField),
    );
  }
  
  /// Finds a card containing specific text
  static Finder findCardWithText(String text) {
    return find.ancestor(
      of: find.text(text),
      matching: find.byType(Card),
    );
  }
  
  /// Finds a list tile containing text
  static Finder findListTileWithText(String text) {
    return find.ancestor(
      of: find.text(text),
      matching: find.byType(ListTile),
    );
  }
}

/// Widget test utilities
class WidgetTestUtils {
  /// Creates a mock GoRouter with navigation stubs
  static MockGoRouter createMockRouter() {
    final router = MockGoRouter();
    
    // Setup common navigation stubs
    when(() => router.go(any())).thenAnswer((_) async {});
    when(() => router.goNamed(
      any(),
      pathParameters: any(named: 'pathParameters'),
      queryParameters: any(named: 'queryParameters'),
      extra: any(named: 'extra'),
    )).thenAnswer((_) async {});
    when(() => router.push(any())).thenAnswer((_) async => null);
    when(() => router.pushNamed(
      any(),
      pathParameters: any(named: 'pathParameters'),
      queryParameters: any(named: 'queryParameters'),
      extra: any(named: 'extra'),
    )).thenAnswer((_) async => null);
    when(() => router.pop(any())).thenAnswer((_) async {});
    when(() => router.canPop()).thenReturn(true);
    
    return router;
  }
  
  /// Creates a provider container for testing
  static ProviderContainer createTestContainer({
    List<Override> overrides = const [],
  }) {
    final container = ProviderContainer(
      overrides: overrides,
    );
    
    addTearDown(container.dispose);
    return container;
  }
  
  /// Waits for a specific duration in tests
  static Future<void> wait(Duration duration) async {
    await Future.delayed(duration);
  }
  
  /// Verifies that a widget displays a loading indicator
  static void expectLoading(WidgetTester tester) {
    expect(
      find.byType(CircularProgressIndicator),
      findsOneWidget,
      reason: 'Should display loading indicator',
    );
  }
  
  /// Verifies that a widget displays an error message
  static void expectError(WidgetTester tester, String message) {
    expect(
      find.text(message),
      findsOneWidget,
      reason: 'Should display error message: $message',
    );
  }
  
  /// Verifies that a widget displays a snackbar
  static void expectSnackbar(WidgetTester tester, String message) {
    expect(
      find.ancestor(
        of: find.text(message),
        matching: find.byType(SnackBar),
      ),
      findsOneWidget,
      reason: 'Should display snackbar with message: $message',
    );
  }
}

/// Test matchers for widget properties
class WidgetMatchers {
  /// Matches a widget with specific color
  static Matcher hasColor(Color color) {
    return _HasColor(color);
  }
  
  /// Matches a widget that is enabled
  static Matcher get isEnabled => _IsEnabled(true);
  
  /// Matches a widget that is disabled
  static Matcher get isDisabled => _IsEnabled(false);
}

class _HasColor extends Matcher {
  final Color expectedColor;
  
  _HasColor(this.expectedColor);
  
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Container) {
      final decoration = item.decoration;
      if (decoration is BoxDecoration) {
        return decoration.color == expectedColor;
      }
    }
    if (item is ColoredBox) {
      return item.color == expectedColor;
    }
    return false;
  }
  
  @override
  Description describe(Description description) {
    return description.add('has color $expectedColor');
  }
}

class _IsEnabled extends Matcher {
  final bool expectedEnabled;
  
  _IsEnabled(this.expectedEnabled);
  
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is ElevatedButton) {
      return (item.onPressed != null) == expectedEnabled;
    }
    if (item is TextButton) {
      return (item.onPressed != null) == expectedEnabled;
    }
    if (item is IconButton) {
      return (item.onPressed != null) == expectedEnabled;
    }
    return false;
  }
  
  @override
  Description describe(Description description) {
    return description.add(expectedEnabled ? 'is enabled' : 'is disabled');
  }
}

/// Screen size configurations for responsive testing
class TestScreenSizes {
  static const smallPhone = Size(320, 568);  // iPhone SE
  static const phone = Size(375, 812);       // iPhone X
  static const largePhone = Size(414, 896);  // iPhone 11 Pro Max
  static const tablet = Size(768, 1024);     // iPad
  static const desktop = Size(1920, 1080);   // Full HD
}

/// Extension for testing different screen sizes
extension ScreenSizeTester on WidgetTester {
  /// Sets the screen size for testing
  Future<void> setScreenSize(Size size) async {
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  }
}