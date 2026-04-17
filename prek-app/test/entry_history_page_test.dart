import 'dart:convert';

import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late MockClient mockHttpClient;
  List<Map<String, dynamic>> mockEntries = [];

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/rest/v1/Gratitude Entries') {
      return http.Response(
        jsonEncode(mockEntries),
        200,
        headers: headers,
        request: request,
      );
    }

    return http.Response('[]', 200, headers: headers, request: request);
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

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpEntryHistoryPage(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EntryHistoryPage()));
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('shows empty state when no entries', (tester) async {
    mockEntries = [];
    useLargeViewport(tester);

    await pumpEntryHistoryPage(tester);

    expect(find.text('Gratitude History'), findsOneWidget);
    expect(
      find.text('No entries yet.\nAdd your first gratitude today!'),
      findsOneWidget,
    );
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('renders entries and date headers', (tester) async {
    mockEntries = [
      {
        'id': 'entry-1',
        'user_id': 'user-1',
        'text': 'I am grateful for sunshine.',
        'created_at': '2026-04-17T09:30:00Z',
        'mood': 'Happy',
        'audio_path': null,
      },
      {
        'id': 'entry-2',
        'user_id': 'user-1',
        'text': 'I am grateful for a good book.',
        'created_at': '2026-04-17T08:00:00Z',
        'mood': 'Neutral',
        'audio_path': null,
      },
      {
        'id': 'entry-3',
        'user_id': 'user-1',
        'text': 'I am grateful for a quiet walk.',
        'created_at': '2026-04-16T18:15:00Z',
        'mood': 'Calm',
        'audio_path': null,
      },
    ];
    useLargeViewport(tester);

    await pumpEntryHistoryPage(tester);

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('I am grateful for sunshine.'), findsOneWidget);
    expect(find.text('I am grateful for a good book.'), findsOneWidget);
    expect(find.text('I am grateful for a quiet walk.'), findsOneWidget);
    expect(find.text('2026-04-17'), findsOneWidget);
    expect(find.text('2026-04-16'), findsOneWidget);
    expect(find.text('Happy'), findsOneWidget);
    expect(find.text('Neutral'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
  });
}
