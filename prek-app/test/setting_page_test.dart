import 'package:_2025_prek/change_email.dart';
import 'package:_2025_prek/change_name.dart';
import 'package:_2025_prek/change_pw.dart';
import 'package:_2025_prek/login.dart';
import 'package:_2025_prek/settings_page.dart';
import 'package:_2025_prek/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'http://localhost',
      ),
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'test-anon-key',
      ),
    );
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpSettingsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(0.85)),
            child: SettingsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<_RecordingNavigatorObserver> pumpSettingsPageWithObserver(
    WidgetTester tester,
  ) async {
    final observer = _RecordingNavigatorObserver();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          navigatorObservers: [observer],
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(0.85)),
            child: SettingsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    observer.pushed.clear();
    return observer;
  }

  testWidgets('settings page renders core', (tester) async {
    useLargeViewport(tester);
    await pumpSettingsPage(tester);

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Settings')),
      findsOneWidget,
    );
    expect(find.widgetWithText(ElevatedButton, 'Change Name'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Change Email'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Change Password'),
      findsOneWidget,
    );
    expect(find.widgetWithText(ElevatedButton, 'Logout'), findsOneWidget);
  });

  testWidgets('settings page renders dark mode', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) {
          final provider = ThemeProvider();
          provider.toggleTheme();
          return provider;
        },
        child: MaterialApp(
          theme: ThemeData.dark(useMaterial3: false),
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(0.85)),
            child: SettingsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Settings')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  final navCases = {'Home': 0, 'History': 1, 'Profile': 2, 'Lookbook': 3};

  for (final entry in navCases.entries) {
    final label = entry.key;
    final index = entry.value;

    testWidgets('bottom nav pushes $label route', (tester) async {
      useLargeViewport(tester);
      final observer = await pumpSettingsPageWithObserver(tester);
      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      navBar.onTap!(index);

      expect(observer.pushed, hasLength(1));
    });
  }

  testWidgets('Change Name navigates to ChangeName page', (tester) async {
    useLargeViewport(tester);
    await pumpSettingsPage(tester);

    await tester.tap(find.text('Change Name'));
    await tester.pumpAndSettle();

    expect(find.byType(ChangeName), findsOneWidget);
  });

  testWidgets('Change Email navigates to ChangeEmail page', (tester) async {
    useLargeViewport(tester);
    await pumpSettingsPage(tester);

    await tester.tap(find.text('Change Email'));
    await tester.pumpAndSettle();

    expect(find.byType(ChangeEmail), findsOneWidget);
  });

  testWidgets('Change Password navigates to ChangePW page', (tester) async {
    useLargeViewport(tester);
    await pumpSettingsPage(tester);

    await tester.tap(find.text('Change Password'));
    await tester.pumpAndSettle();

    expect(find.byType(ChangePW), findsOneWidget);
  });

  testWidgets('Logout navigates to Login page', (tester) async {
    useLargeViewport(tester);
    await pumpSettingsPage(tester);

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(Login), findsOneWidget);
  });
}

class _RecordingNavigatorObserver extends NavigatorObserver {
  final pushed = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    super.didPush(route, previousRoute);
  }
}
