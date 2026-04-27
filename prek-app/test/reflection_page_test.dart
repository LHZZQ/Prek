import 'dart:convert';
import 'package:_2025_prek/reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockClient mockHttpClient;

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/rest/v1/Gratitude Entries' && request.method == 'GET') {
      return http.Response('[]', 200, headers: headers, request: request);
    }

    if (path == '/rest/v1/Gratitude Entries' && request.method == 'POST') {
      return http.Response(
        jsonEncode({'message': 'save failed'}),
        400,
        headers: headers,
        request: request,
      );
    }

    return http.Response('{}', 200, headers: headers, request: request);
  }

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    mockHttpClient = MockClient(handleRequest);

    await Supabase.initialize(
      url: 'http://localhost',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlc3QiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTUxNjIzOTAyMn0.signature',
      httpClient: mockHttpClient,
      authOptions: const FlutterAuthClientOptions(
        localStorage: const EmptyLocalStorage(),
      ),
    );
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpReflectionPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ReflectionPage(selectedMood: 'Happy')),
    );
    await tester.pumpAndSettle();
  }

  Future<_RecordingNavigatorObserver> pumpReflectionPageWithObserver(
    WidgetTester tester,
  ) async {
    final observer = _RecordingNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [observer],
        home: const ReflectionPage(selectedMood: 'Happy'),
      ),
    );
    await tester.pumpAndSettle();
    observer.pushed.clear();
    return observer;
  }

  Future<void> openReflectionRoute(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReflectionPage(selectedMood: 'Happy'),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders reflection page UI', (tester) async {
    useLargeViewport(tester);
    await pumpReflectionPage(tester);

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Reflection'),
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        "Take a moment to reflect on something you're grateful for today 💭",
      ),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Write your reflection here...'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Save Reflection'),
      findsOneWidget,
    );
  });

  // stay for now but maybe change later to show the error message
  testWidgets('stays on reflection page when save is tapped with empty input', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpReflectionPage(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Reflection'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(ReflectionPage), findsOneWidget);
  });

  testWidgets('stays on reflection page when saving fails', (tester) async {
    useLargeViewport(tester);
    await pumpReflectionPage(tester);

    await tester.enterText(
      find.byType(TextField),
      'I am grateful for sunshine',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Reflection'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ReflectionPage), findsOneWidget);
  });

  testWidgets('back button pops reflection', (tester) async {
    useLargeViewport(tester);
    await openReflectionRoute(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ReflectionPage), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('renders dark mode', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: false),
        home: const ReflectionPage(selectedMood: 'Happy'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Write your reflection here...'), findsOneWidget);
  });

  final navCases = ['Home', 'History', 'Profile', 'Lookbook', 'Settings'];

  for (final label in navCases) {
    testWidgets('bottom nav pushes $label route', (tester) async {
      useLargeViewport(tester);
      final observer = await pumpReflectionPageWithObserver(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text(label),
        ),
      );

      expect(observer.pushed, hasLength(1));
    });
  }
}

class _RecordingNavigatorObserver extends NavigatorObserver {
  final pushed = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    super.didPush(route, previousRoute);
  }
}
