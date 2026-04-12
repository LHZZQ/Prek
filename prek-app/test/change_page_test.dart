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

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('change name page renders and can navigate after save', (
    tester,
  ) async {
    useLargeViewport(tester);

    await tester.pumpWidget(const MaterialApp(home: ChangeName()));
    await tester.pumpAndSettle();

    expect(find.text('Enter your new name'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'New Name');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('change email page renders and can navigate after save', (
    tester,
  ) async {
    useLargeViewport(tester);

    await tester.pumpWidget(const MaterialApp(home: ChangeEmail()));
    await tester.pumpAndSettle();

    expect(find.text('Enter your new email'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test@example.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('change password page shows wrong current password message', (
    tester,
  ) async {
    useLargeViewport(tester);

    await tester.pumpWidget(const MaterialApp(home: ChangePW()));
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

  test('password validator returns error for empty', () {
    final validator = SignUpValidator();

    expect(validator.validatePassword(''), 'Password is required');
  });
}
