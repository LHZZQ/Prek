import 'dart:convert';
import 'package:_2025_prek/change_email.dart';
import 'package:_2025_prek/change_name.dart';
import 'package:_2025_prek/change_pw.dart';
import 'package:_2025_prek/home_page.dart';
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

  Future<void> setLoggedInSession() async {
    await Supabase.instance.client.auth.setInitialSession(
      jsonEncode({
        'access_token': 'test-token',
        'refresh_token': 'test-refresh-token',
        'token_type': 'bearer',
        'user': {
          'id': '00000000-0000-0000-0000-000000000001',
          'aud': 'authenticated',
          'app_metadata': {'provider': 'email'},
          'user_metadata': {},
          'email': 'zzq@gmail.com',
          'created_at': '2026-01-01T00:00:00.000000Z',
        },
      }),
    );
  }

  Future<void> clearSession() async {
    try {
      await Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
    } catch (_) {}
  }

  tearDown(() async {
    await clearSession();
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget buildTestApp(Widget home) {
    return MaterialApp(theme: ThemeData(useMaterial3: false), home: home);
  }

  testWidgets('change name page does not show empty error on open', (
    tester,
  ) async {
    useLargeViewport(tester);

    await tester.pumpWidget(buildTestApp(const ChangeName()));
    await tester.pumpAndSettle();

    expect(find.text('Enter your new name'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    expect(find.text('Username cannot be empty'), findsNothing);
  });

  testWidgets('change email page does not show empty error on open', (
    tester,
  ) async {
    useLargeViewport(tester);

    await tester.pumpWidget(buildTestApp(const ChangeEmail()));
    await tester.pumpAndSettle();

    expect(find.text('Enter your new email'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    expect(find.text('Email cannot be empty'), findsNothing);
  });

  testWidgets('change password page shows wrong current password message', (
    tester,
  ) async {
    useLargeViewport(tester);
    await setLoggedInSession();

    await tester.pumpWidget(buildTestApp(const ChangePW()));
    await tester.pumpAndSettle();

    expect(find.text('Current password'), findsOneWidget);
    expect(find.text('New password'), findsOneWidget);
    expect(find.text('Confirm new password'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Oldzzq123!');
    await tester.enterText(find.byType(TextFormField).at(1), 'Newzzq123!');
    await tester.enterText(find.byType(TextFormField).at(2), 'Newzzq123!');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Current password is wrong'), findsOneWidget);
  });

  testWidgets('change password page eyes buttons', (tester) async {
    useLargeViewport(tester);
    await setLoggedInSession();

    await tester.pumpWidget(buildTestApp(const ChangePW()));
    await tester.pumpAndSettle();

    final visibilityToggles = find.byIcon(Icons.visibility_off);
    expect(visibilityToggles, findsNWidgets(3));

    await tester.tap(visibilityToggles.at(0));
    await tester.tap(visibilityToggles.at(1));
    await tester.tap(visibilityToggles.at(2));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility), findsNWidgets(3));
  });

  test('password validator returns error for empty', () {
    final validator = SignUpValidator();

    expect(validator.validatePassword(''), 'Password is required');
  });

  test('password validator returns error for weak password', () {
    final validator = SignUpValidator();

    expect(
      validator.validatePassword('abcdefg123'),
      startsWith('Password must have a minimum of 1 lower case letter'),
    );
  });

  test('password validator returns null for valid password', () {
    final validator = SignUpValidator();

    expect(validator.validatePassword('Zzqzzq123!'), isNull);
  });
}
