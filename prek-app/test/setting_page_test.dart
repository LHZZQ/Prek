import 'package:_2025_prek/change_email.dart';
import 'package:_2025_prek/change_name.dart';
import 'package:_2025_prek/change_pw.dart';
import 'package:_2025_prek/login.dart';
import 'package:_2025_prek/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(0.85)),
          child: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('settings page renders core', (tester) async {
    useLargeViewport(tester);
    await pumpSettingsPage(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Change Name'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Change Email'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Change Password'),
      findsOneWidget,
    );
    expect(find.widgetWithText(ElevatedButton, 'Logout'), findsOneWidget);
  });

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

  // will change in the future
  testWidgets('Logout navigates to Login page', (tester) async {
    useLargeViewport(tester);
    await pumpSettingsPage(tester);

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(Login), findsOneWidget);
  });
}
