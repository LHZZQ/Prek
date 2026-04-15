import 'package:_2025_prek/change_email.dart';
import 'package:_2025_prek/change_name.dart';
import 'package:_2025_prek/change_pw.dart';
import 'package:_2025_prek/forgotpw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // avoid overflowed
  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      // reset to default after test
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('change name page', (tester) async {
    useLargeViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: ChangeName()));
    await tester.pumpAndSettle();

    expect(find.text('Enter your new name'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ziqian');
    expect(find.text('Ziqian'), findsOneWidget);
  });

  testWidgets('change email page', (tester) async {
    useLargeViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: ChangeEmail()));
    await tester.pumpAndSettle();

    expect(find.text('Enter your new email'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test54321@gmail.com');
    expect(find.text('test54321@gmail.com'), findsOneWidget);
  });

  testWidgets('change password page', (tester) async {
    useLargeViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: ChangePW()));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byIcon(Icons.visibility_off), findsNWidgets(3));
    expect(find.byIcon(Icons.visibility), findsNothing);

    // test first eye
    await tester.tap(find.byIcon(Icons.visibility_off).first);
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('forgot password page', (tester) async {
    useLargeViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: ForgotPW()));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    final emailFieldFinder = find.byType(TextFormField);
    await tester.enterText(emailFieldFinder, 'test233@gmail.com');
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    final emailField = tester.widget<TextFormField>(emailFieldFinder);
    expect(emailField.controller!.text, isEmpty);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pumpAndSettle();

    expect(find.text('Email Confirmation'), findsOneWidget);
    expect(
      find.text(
        'A password reset link is sent to the email address if it is registered.',
      ),
      findsOneWidget,
    );
    expect(find.widgetWithText(TextButton, 'OK'), findsOneWidget);
  });
}
