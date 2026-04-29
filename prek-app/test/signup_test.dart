import 'dart:convert';
import 'package:_2025_prek/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_2025_prek/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final validator = SignUpValidator();
  late MockClient mockHttpClient;
  Map<String, dynamic>? lastSignUpPayload;
  Map<String, dynamic>? lastProfilePayload;
  bool failSignUp = false;
  bool failProfileInsert = false;

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/auth/v1/signup' && request.method == 'POST') {
      lastSignUpPayload = jsonDecode(request.body) as Map<String, dynamic>;

      if (failSignUp) {
        return http.Response(
          jsonEncode({'message': 'Email already registered'}),
          400,
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
          'email': lastSignUpPayload?['email'],
          'created_at': '2026-01-01T00:00:00.000000Z',
        }),
        200,
        headers: headers,
        request: request,
      );
    }

    if (path == '/rest/v1/Profiles' && request.method == 'POST') {
      lastProfilePayload = jsonDecode(request.body) as Map<String, dynamic>;

      if (failProfileInsert) {
        return http.Response(
          jsonEncode({'message': 'profile insert failed'}),
          500,
          headers: headers,
          request: request,
        );
      }

      return http.Response(
        jsonEncode([lastProfilePayload]),
        201,
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
      anonKey: 'test-anon-key',
      httpClient: mockHttpClient,
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );
  });

  setUp(() {
    lastSignUpPayload = null;
    lastProfilePayload = null;
    failSignUp = false;
    failProfileInsert = false;
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

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

    test('validatePassword returns error when no uppercase letter', () {
      var result = validator.validatePassword('zzq@0616123');
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

    Future<void> enterValidSignUpForm(WidgetTester tester) async {
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'zzq');
      await tester.enterText(fields.at(1), 'zzq@example.com');
      await tester.enterText(fields.at(2), 'Zzq@0616123');
      await tester.enterText(fields.at(3), 'Zzq@0616123');
      await tester.pumpAndSettle();
    }

    Future<void> submitSignUp(WidgetTester tester) async {
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
      );
      await tester.runAsync(() async {
        button.onPressed!.call();
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.idle();
      await tester.pumpAndSettle();
    }

    testWidgets('renders signup page', (tester) async {
      useLargeViewport(tester);
      await pumpSignUp(tester);

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('renders dark mode', (tester) async {
      useLargeViewport(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(useMaterial3: false),
          home: const SignUp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Username'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('back button pops signup route', (tester) async {
      useLargeViewport(tester);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUp()),
                );
              },
              child: const Text('Open Signup'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Signup'));
      await tester.pumpAndSettle();
      expect(find.byType(SignUp), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(SignUp), findsNothing);
      expect(find.text('Open Signup'), findsOneWidget);
    });

    testWidgets('shows mismatch snackbar when two passwords are different', (
      tester,
    ) async {
      useLargeViewport(tester);
      await pumpSignUp(tester);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'zzq@example.com');
      await tester.enterText(fields.at(2), 'Zzq@0616123');
      await tester.enterText(fields.at(3), 'Zzq@0616124');
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
      await tester.enterText(fields.at(2), '123');
      await tester.enterText(fields.at(3), '123');
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

      await tester.tap(find.byIcon(Icons.close).last);
      await tester.pumpAndSettle();

      expect(tester.widget<TextFormField>(emailField).controller!.text, '');

      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      await tester.enterText(firstPasswordField, 'Zzq@0616123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.enterText(fields.at(3), 'Zzq@0616123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
    });

    testWidgets('successful signup inserts profile and opens home', (
      tester,
    ) async {
      useLargeViewport(tester);
      await pumpSignUp(tester);
      await enterValidSignUpForm(tester);

      await submitSignUp(tester);

      expect(lastSignUpPayload?['email'], 'zzq@example.com');
      expect(lastSignUpPayload?['password'], 'Zzq@0616123');
      expect(lastProfilePayload?['id'], '00000000-0000-0000-0000-000000000001');
      expect(lastProfilePayload?['username'], 'zzq');
      expect(lastProfilePayload?['email'], 'zzq@example.com');
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('signup failure', (tester) async {
      failSignUp = true;
      useLargeViewport(tester);
      await pumpSignUp(tester);
      await enterValidSignUpForm(tester);

      await submitSignUp(tester);

      expect(find.text('Email already registered'), findsOneWidget);
      expect(find.byType(SignUp), findsOneWidget);
      expect(lastProfilePayload, isNull);
    });

    testWidgets('profile insert fail', (tester) async {
      failProfileInsert = true;
      useLargeViewport(tester);
      await pumpSignUp(tester);
      await enterValidSignUpForm(tester);

      await submitSignUp(tester);

      expect(find.text('Error'), findsOneWidget);
      expect(find.byType(SignUp), findsOneWidget);
      expect(lastProfilePayload?['email'], 'zzq@example.com');
    });
  });
}
