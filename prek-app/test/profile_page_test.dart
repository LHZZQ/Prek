import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:_2025_prek/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late HttpServer mockServer;
  const userId = '4d2583da-8de4-49d3-9cd1-37a9a74f55bd';

  String buildSessionString() {
    final expiresAt = DateTime.now().add(const Duration(hours: 1));
    final expiresAtSeconds = expiresAt.millisecondsSinceEpoch ~/ 1000;
    final accessTokenPayload = base64.encode(
      utf8.encode(
        json.encode({
          'exp': expiresAtSeconds,
          'sub': userId,
          'role': 'authenticated',
        }),
      ),
    );
    final accessToken = 'any.$accessTokenPayload.any';

    return jsonEncode({
      'access_token': accessToken,
      'expires_in': expiresAt.difference(DateTime.now()).inSeconds,
      'refresh_token': 'test-refresh-token',
      'token_type': 'bearer',
      'provider_token': null,
      'provider_refresh_token': null,
      'user': {
        'id': userId,
        'app_metadata': {
          'provider': 'email',
          'providers': ['email'],
        },
        'user_metadata': {'name': 'Test User'},
        'aud': 'authenticated',
        'email': 'test@example.com',
        'phone': '',
        'created_at': '2025-01-01T00:00:00.000000Z',
        'email_confirmed_at': '2025-01-01T00:00:00.000000Z',
        'last_sign_in_at': '2026-04-01T00:00:00.000000Z',
        'role': 'authenticated',
        'updated_at': '2026-04-01T00:00:00.000000Z',
      },
    });
  }

  Future<void> handleRequest(HttpRequest request) async {
    final path = Uri.decodeComponent(request.uri.path);
    request.response.headers.contentType = ContentType.json;
    request.response.statusCode = HttpStatus.ok;

    if (path == '/rest/v1/Profiles') {
      final select = request.uri.queryParameters['select'];
      if (select == 'username') {
        request.response.write(jsonEncode([
          {'username': 'Test User'},
        ]));
      } else if (select == 'email') {
        request.response.write(jsonEncode([
          {'email': 'test@example.com'},
        ]));
      } else {
        request.response.write('[]');
      }
      await request.response.close();
      return;
    }

    if (path == '/rest/v1/Gratitude Entries') {
      final select = request.uri.queryParameters['select'];
      if (select == 'id') {
        request.response.write(jsonEncode([
          {'id': 1},
          {'id': 2},
          {'id': 3},
        ]));
      } else if (select == 'mood,created_at') {
        request.response.write(jsonEncode([
          {'mood': 'Frustrated', 'created_at': '2026-01-03T12:00:00Z'},
          {'mood': 'Overwhelmed', 'created_at': '2026-01-09T12:00:00Z'},
          {'mood': 'Confused', 'created_at': '2026-01-18T12:00:00Z'},
          {'mood': 'Angry', 'created_at': '2026-01-27T12:00:00Z'},
        ]));
      } else {
        request.response.write('[]');
      }
      await request.response.close();
      return;
    }

    request.response.write('[]');
    await request.response.close();
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    mockServer = await HttpServer.bind('127.0.0.1', 0);
    unawaited(mockServer.forEach(handleRequest));
    await Supabase.initialize(
      url: 'http://${mockServer.address.host}:${mockServer.port}',
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'test-anon-key',
      ),
    );
  });

  tearDownAll(() async {
    await mockServer.close(force: true);
  });

  setUp(() async {
    await Supabase.instance.client.auth.recoverSession(buildSessionString());
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Finder findMoodBoardSection() => find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == '_MoodBoardSection',
  );

  Future<void> seedMoodBoard(
    WidgetTester tester, {
    required DateTime shownMonth,
    required Map<String, String> moodsByDay,
  }) async {
    final moodBoardState = tester.state(findMoodBoardSection()) as dynamic;
    moodBoardState.setState(() {
      moodBoardState.shownMonth = DateTime(shownMonth.year, shownMonth.month);
      moodBoardState.moodByDay
        ..clear()
        ..addAll(moodsByDay);
    });
    await tester.pump();
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
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
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
    await seedMoodBoard(
      tester,
      shownMonth: DateTime(2026, 1),
      moodsByDay: const {
        '2026-01-03': 'Frustrated',
        '2026-01-09': 'Overwhelmed',
        '2026-01-18': 'Confused',
        '2026-01-27': 'Angry',
      },
    );

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
