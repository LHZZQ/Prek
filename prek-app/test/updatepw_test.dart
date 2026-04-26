import 'package:_2025_prek/updatepw.dart';
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
}
