import 'dart:convert';
import 'package:_2025_prek/memory_gallery_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockClient mockHttpClient;
  const userId = '00000000-0000-0000-0000-000000000001';
  List<Map<String, dynamic>> mockMemories = [];

  String buildSessionString() {
    return jsonEncode({
      'access_token': 'test-token',
      'refresh_token': 'test-refresh-token',
      'token_type': 'bearer',
      'user': {
        'id': userId,
        'aud': 'authenticated',
        'app_metadata': {'provider': 'email'},
        'user_metadata': {},
        'email': 'zzq@gmail.com',
        'created_at': '2025-01-01T00:00:00.000000Z',
      },
    });
  }

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/rest/v1/Gratitude Entries') {
      return http.Response(
        jsonEncode(mockMemories),
        200,
        headers: headers,
        request: request,
      );
    }

    if (path.contains('/storage/v1/object/sign/memories')) {
      return http.Response(
        jsonEncode({'message': 'sign failed'}),
        500,
        headers: headers,
        request: request,
      );
    }

    return http.Response('[]', 200, headers: headers, request: request);
  }

  setUpAll(() async {
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
    );
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

  setUp(() {
    mockMemories = [];
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpMemoryGalleryPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: const MemoryGalleryPage(),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('shows empty', (tester) async {
    useLargeViewport(tester);
    await pumpMemoryGalleryPage(tester);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Your\nLookbook'),
      ),
      findsOneWidget,
    );
    expect(find.text('Every moment worth keeping.'), findsOneWidget);
    expect(find.text('All memories'), findsOneWidget);
    expect(find.text('0 saved'), findsOneWidget);
    expect(find.text('No memories yet'), findsOneWidget);
    expect(find.text('Add one from the reflection flow'), findsOneWidget);
    expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
  });

  testWidgets('renders one memory tile', (tester) async {
    mockMemories = [
      {
        'id': 'memory-1',
        'text': 'Grateful for sunshine',
        'image_path': 'user-1/memory-1.png',
        'created_at': '2026-04-25T09:30:00Z',
      },
    ];
    useLargeViewport(tester);
    await Supabase.instance.client.auth.setInitialSession(buildSessionString());

    await pumpMemoryGalleryPage(tester);

    expect(find.text('1 saved'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Grateful for sunshine'), findsOneWidget);
    expect(find.text('Apr 25'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.text('No memories yet'), findsNothing);
  });

  testWidgets('tap memory open details', (tester) async {
    mockMemories = [
      {
        'id': 'memory-1',
        'text': 'Grateful for sunshine',
        'image_path': 'user-1/memory-1.png',
        'created_at': '2026-04-25T09:30:00Z',
      },
    ];
    useLargeViewport(tester);
    await Supabase.instance.client.auth.setInitialSession(buildSessionString());

    await pumpMemoryGalleryPage(tester);

    await tester.tap(find.text('Grateful for sunshine'));
    await tester.pumpAndSettle();

    expect(find.text('Grateful for sunshine'), findsWidgets);
    expect(find.text('April 25, 2026'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
  });
}
