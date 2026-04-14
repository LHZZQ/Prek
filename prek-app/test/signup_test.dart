import 'package:flutter_test/flutter_test.dart';
import 'package:_2025_prek/signup.dart';
import 'package:flutter/material.dart';

void main() {
  final validator = SignUpValidator();

  group('SignUpValidator Logic', () {
    test('validateEmail returns error when email is null', () {
      var result = validator.validateEmail(null);
      expect(result, 'Email is required');
    });

    test('validateEmail returns error when email is empty', () {
      var result = validator.validateEmail('');
      expect(result, 'Email is required');
    });

    test('validateEmail returns error string when format is invalid', () {
      var result = validator.validateEmail('wrongemail');
      expect(result, 'Enter a valid email');
    });

    test('validateEmail returns null when email is valid', () {
      var result = validator.validateEmail('test@gmail.com');
      expect(result, null);
    });

    test('validateEmail trims whitespace and still validates', () {
      var result = validator.validateEmail('  test@gmail.com  ');
      expect(result, null);
    });

    test('validatePassword returns error when password is null', () {
      var result = validator.validatePassword(null);
      expect(result, 'Password is required');
    });

    test('validatePassword returns error when password is empty', () {
      var result = validator.validatePassword('');
      expect(result, 'Password is required');
    });

    test('validatePassword returns error when invalid', () {
      var result = validator.validatePassword('123');
      expect(
        result,
        'Password must have a minimum of 1 lower case letter [a-z], a minimum of 1 upper case letter [A-Z], a minimum of 1 numeric character [0-9], a minimum of 1 special character: ~`!@#%^&*()-_+={}[]|:"<>,./?, and must be at least 10 characters',
      );
    });

    test('validatePassword returns null when valid', () {
      var result = validator.validatePassword('Zzq@0616123');
      expect(result, null);
    });

    test('validatePassword returns error when do not haveuppercase', () {
      var result = validator.validatePassword('Zzq@0616123');
      expect(
        result,
        'Password must have a minimum of 1 lower case letter [a-z], a minimum of 1 upper case letter [A-Z], a minimum of 1 numeric character [0-9], a minimum of 1 special character: ~`!@#%^&*()-_+={}[]|:"<>,./?, and must be at least 10 characters',
      );
    });
  });

  group('SignUp Widget', () {
    void useLargeViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    Future<void> pumpSignUp(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            splashFactory: InkRipple.splashFactory,
          ),
          home: const SignUp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows mismatch snackbar when two passwords are different', (
      tester,
    ) async {
      useLargeViewport(tester);
      await pumpSignUp(tester);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'zzq@example.com');
      await tester.enterText(fields.at(2), 'Zzq@0616123');
      await tester.enterText(fields.at(3), 'Zzq@0616123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text("New password doesn't match"), findsOneWidget);
    });

    testWidgets('runs validators when submit with matching invalid values', (
      tester,
    ) async {
      useLargeViewport(tester);
      await pumpSignUp(tester);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'zzqemail123321');
      await tester.enterText(fields.at(2), 'Zzq@0616123');
      await tester.enterText(fields.at(3), 'Zzq@0616123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(
        find.text(
          'Password must have a minimum of 1 lower case letter [a-z], a minimum of 1 upper case letter [A-Z], a minimum of 1 numeric character [0-9], a minimum of 1 special character: ~`!@#%^&*()-_+={}[]|:"<>,./?, and must be at least 10 characters',
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('shows icons after input and toggles password visibility', (
      tester,
    ) async {
      useLargeViewport(tester);
      await pumpSignUp(tester);

      final fields = find.byType(TextFormField);
      final usernameField = fields.at(0);
      final emailField = fields.at(1);
      final firstPasswordField = fields.at(2);

      await tester.enterText(usernameField, 'zzq');
      await tester.enterText(emailField, 'zzq@example.com');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      expect(tester.widget<TextFormField>(usernameField).controller!.text, '');

      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      await tester.enterText(firstPasswordField, 'Zzq@0616123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
    });
  });
}
