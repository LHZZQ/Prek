import 'dart:convert';
import 'package:_2025_prek/change_email.dart';
import 'package:_2025_prek/change_name.dart';
import 'package:_2025_prek/change_pw.dart';
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

  testWidgets('change name page validates empty save after login', (
    tester,
  ) async {
    useLargeViewport(tester);
    await setLoggedInSession();

    await tester.pumpWidget(buildTestApp(const ChangeName()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pump();

    expect(find.text('Username cannot be empty'), findsOneWidget);
  });

  testWidgets('change name page fail', (tester) async {
    useLargeViewport(tester);
    await setLoggedInSession();

    await tester.pumpWidget(buildTestApp(const ChangeName()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Ziqian');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.byType(ChangeName), findsOneWidget);
    expect(find.text('Ziqian'), findsOneWidget);
  });

  testWidgets('change name page back button', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangeName()),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(ChangeName), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ChangeName), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('change name page renders dark mode', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: false),
        home: const ChangeName(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter your new name'), findsOneWidget);
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

  testWidgets('change email page validates empty save after login', (
    tester,
  ) async {
    useLargeViewport(tester);
    await setLoggedInSession();

    await tester.pumpWidget(buildTestApp(const ChangeEmail()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pump();

    expect(find.text('Email cannot be empty'), findsOneWidget);
  });

  testWidgets('change email page failed', (tester) async {
    useLargeViewport(tester);
    await setLoggedInSession();

    await tester.pumpWidget(buildTestApp(const ChangeEmail()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'zzq123@example.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.byType(ChangeEmail), findsOneWidget);
    expect(find.text('zzq123@example.com'), findsOneWidget);
  });

  testWidgets('change email page back button', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangeEmail()),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(ChangeEmail), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ChangeEmail), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('change email page renders dark mode', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: false),
        home: const ChangeEmail(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter your new email'), findsOneWidget);
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
