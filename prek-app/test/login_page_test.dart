// import 'package:_2025_prek/home_page.dart';
import 'package:_2025_prek/login.dart';
import 'package:_2025_prek/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_2025_prek/forgotpw.dart';

void main() {
  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(0.85)),
          child: Login(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders login page', (tester) async {
    useLargeViewport(tester);
    await pumpLoginPage(tester);

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.text('Forgot Password'), findsOneWidget);
    //expect(find.text('Sign in with google'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('display error when login clicked with empty', (tester) async {
    useLargeViewport(tester);
    await pumpLoginPage(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter email and password.'), findsOneWidget);
  });

  testWidgets('email clear icon appears and clears input', (tester) async {
    useLargeViewport(tester);
    await pumpLoginPage(tester);

    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'zzq@gmail.com');
    await tester.pump();

    final clearIcon = find.byIcon(Icons.close);
    expect(clearIcon, findsOneWidget);

    await tester.tap(clearIcon);
    await tester.pump();

    final widget = tester.widget<TextFormField>(emailField);
    expect(widget.controller!.text, isEmpty);
  });

  testWidgets('password visibility eyes icon', (tester) async {
    useLargeViewport(tester);
    await pumpLoginPage(tester);

    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsNothing);

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  // This test assumes that tapping the "Forgot Password" button navigates to the HomePage
  // When these two bottons are implemented to navigate to the correct pages
  // I will update the tests to reflect the correct navigation targets
  // updated the test to navigate to the correct page
  testWidgets('forgot password button navigates to ForgotPW', (tester) async {
    useLargeViewport(tester);
    await pumpLoginPage(tester);

    await tester.tap(find.text('Forgot Password'));
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPW), findsOneWidget);
  });

  // testWidgets('google sign in button navigates to //HomePage', (tester) async {
  //   useLargeViewport(tester);
  //   await pumpLoginPage(tester);

  //   await tester.tap(
  //     find.widgetWithText(ElevatedButton, 'Sign in with google'),
  //   );
  //   await tester.pumpAndSettle();

  //   expect(find.byType(HomePage), findsOneWidget);
  // });

  testWidgets('sign up button navigates to SignUp page', (tester) async {
    useLargeViewport(tester);
    await pumpLoginPage(tester);

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUp), findsOneWidget);
  });
}
