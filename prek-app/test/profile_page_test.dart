import 'package:_2025_prek/profile_page.dart';
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

  Future<void> pumpProfilePage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: false,
          splashFactory: InkRipple.splashFactory,
        ),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(0.85)),
          child: ProfilePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('profile page renders core content', (tester) async {
    useLargeViewport(tester);
    await pumpProfilePage(tester);

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Your wellness'), findsOneWidget);
    expect(find.text('Mood board'), findsOneWidget);
    expect(find.text('PREK'), findsOneWidget);
    expect(find.text('Member since 2025'), findsOneWidget);

    expect(find.text('Reflections saved'), findsOneWidget);
    expect(find.text('Reflection streak'), findsOneWidget);
    expect(find.text('Reflection goals'), findsOneWidget);
    expect(find.text('Memory Highlights'), findsOneWidget);
  });

  testWidgets('logout icon shows snackbar', (tester) async {
    useLargeViewport(tester);
    await pumpProfilePage(tester);

    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pump();
    // will update later
    expect(find.text('not available right now'), findsOneWidget);
  });

  testWidgets('back button pops to previous page', (tester) async {
    useLargeViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: false,
          splashFactory: InkRipple.splashFactory,
        ),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfilePage(),
                      ),
                    );
                  },
                  child: const Text('Open Profile'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsNothing);
    expect(find.text('Open Profile'), findsOneWidget);
  });

  testWidgets('mood board month buttons', (tester) async {
    useLargeViewport(tester);
    await pumpProfilePage(tester);

    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final currentTitle = '${months[now.month - 1]} ${now.year}';
    final prevMonth = DateTime(now.year, now.month - 1);
    final nextMonth = DateTime(now.year, now.month + 1);
    final prevTitle = '${months[prevMonth.month - 1]} ${prevMonth.year}';
    final nextTitle = '${months[nextMonth.month - 1]} ${nextMonth.year}';

    expect(find.text(currentTitle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.text(prevTitle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded).last);
    await tester.pumpAndSettle();
    expect(find.text(currentTitle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded).last);
    await tester.pumpAndSettle();
    expect(find.text(nextTitle), findsOneWidget);
  });

  testWidgets('mood board shows saved icons in Jan. 2026', (tester) async {
    useLargeViewport(tester);
    await pumpProfilePage(tester);

    int safeGuard = 0;
    while (find.text('January 2026').evaluate().isEmpty && safeGuard < 36) {
      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();
      safeGuard++;
    }

    expect(find.text('January 2026'), findsOneWidget);
    expect(find.byIcon(Icons.whatshot_rounded), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(find.byIcon(Icons.psychology_alt_rounded), findsOneWidget);
    expect(find.byIcon(Icons.mood_bad_rounded), findsOneWidget);
  });

  testWidgets('section rows can be tapped', (tester) async {
    useLargeViewport(tester);
    await pumpProfilePage(tester);

    await tester.tap(find.text('Reflections saved'));
    await tester.pump();

    await tester.tap(find.text('Reflection streak'));
    await tester.pump();

    await tester.tap(find.text('Reflection goals'));
    await tester.pump();

    await tester.tap(find.text('Memory Highlights'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
