import 'dart:convert';
import 'package:_2025_prek/updatepw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late MockClient mockHttpClient;
  var failUpdate = false;
  var updateRequestCount = 0;

  String buildSessionString() {
    return jsonEncode({
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
    });
  }

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/auth/v1/user') {
      updateRequestCount++;
      if (failUpdate) {
        return http.Response(
          jsonEncode({'message': 'update failed'}),
          500,
          headers: headers,
          request: request,
        );
      }

      return http.Response(
        jsonEncode({
          'id': '00000000-0000-0000-0000-000000000001',
          'aud': 'authenticated',
          'app_metadata': {'provider': 'email'},
          'user_metadata': {},
          'email': 'zzq@gmail.com',
          'created_at': '2026-01-01T00:00:00.000000Z',
          'updated_at': '2026-04-26T00:00:00.000000Z',
        }),
        200,
        headers: headers,
        request: request,
      );
    }

    return http.Response('{}', 200, headers: headers, request: request);
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    try {
      if (Supabase.instance.isInitialized) {
        await Supabase.instance.dispose();
      }
    } catch (_) {}

    mockHttpClient = MockClient(handleRequest);
    await Supabase.initialize(
      url: 'http://localhost',
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'test-anon-key',
      ),
      httpClient: mockHttpClient,
    );
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

  setUp(() async {
    failUpdate = false;
    updateRequestCount = 0;
    await Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpUpdatePW(WidgetTester tester) async {
    useLargeViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: const UpdatePW(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('update pw page render', (
    tester,
  ) async {
    await pumpUpdatePW(tester);

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('New Password'), findsOneWidget);
    expect(find.text('Confirm New Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Done'), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

    await tester.enterText(find.byType(TextFormField).first, 'zzq@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Zzqzzq123!');
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    final emailField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(emailField.controller!.text, isEmpty);

    await tester.tap(find.byIcon(Icons.visibility_off).first);
    await tester.pump();
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off).last);
    await tester.pump();
    expect(find.byIcon(Icons.visibility), findsNWidgets(2));

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(2), 'Zzqzzq123!');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
  });

  testWidgets('update pw page validates mismatched pw', (
    tester,
  ) async {
    await pumpUpdatePW(tester);

    await tester.enterText(find.byType(TextFormField).at(1), 'Zzqzzq123!');
    await tester.enterText(find.byType(TextFormField).at(2), 'Other12345!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pump();

    expect(find.text("New password doesn't match"), findsOneWidget);
  });

  testWidgets('update pw page validates weak password', (tester) async {
    await pumpUpdatePW(tester);

    await tester.enterText(find.byType(TextFormField).at(1), 'weak');
    await tester.enterText(find.byType(TextFormField).at(2), 'weak');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pump();

    expect(find.textContaining('Password must have a minimum'), findsOneWidget);
  });

  testWidgets('update pw page reports expired session', (tester) async {
    await pumpUpdatePW(tester);

    await tester.enterText(find.byType(TextFormField).at(1), 'Zzqzzq123!');
    await tester.enterText(find.byType(TextFormField).at(2), 'Zzqzzq123!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pump();

    expect(find.textContaining('Session expired'), findsOneWidget);
  });

  testWidgets('update pw page navigates to login after update succeeds', (
    tester,
  ) async {
    await Supabase.instance.client.auth.setInitialSession(buildSessionString());
    await pumpUpdatePW(tester);

    await tester.enterText(find.byType(TextFormField).at(1), 'Zzqzzq123!');
    await tester.enterText(find.byType(TextFormField).at(2), 'Zzqzzq123!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pumpAndSettle();

    expect(updateRequestCount, 1);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('update pw page reports update fail', (tester) async {
    failUpdate = true;
    await Supabase.instance.client.auth.setInitialSession(buildSessionString());
    await pumpUpdatePW(tester);

    await tester.enterText(find.byType(TextFormField).at(1), 'Zzqzzq123!');
    await tester.enterText(find.byType(TextFormField).at(2), 'Zzqzzq123!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pump();

    expect(updateRequestCount, 1);
    expect(find.textContaining('Error changing password'), findsOneWidget);
  });
}
