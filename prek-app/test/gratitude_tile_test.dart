import 'dart:convert';
import 'package:_2025_prek/models/gratitude_entry.dart';
import 'package:_2025_prek/widgets/gratitude_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late MockClient mockHttpClient;
  final deletedEntryIds = <String>[];
  final removedAudioPaths = <String>[];

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/rest/v1/Gratitude Entries' && request.method == 'DELETE') {
      deletedEntryIds.add(request.url.queryParameters['id'] ?? '');
      return http.Response('[]', 200, headers: headers, request: request);
    }

    if (path.contains('/storage/v1/object/gratitude-audio') && request.method == 'DELETE') {
      final body = jsonDecode(request.body);
      if (body is List) {
        removedAudioPaths.addAll(body.cast<String>());
      } else if (body is Map<String, dynamic> && body['prefixes'] is List) {
        removedAudioPaths.addAll((body['prefixes'] as List).cast<String>());
      }
      return http.Response('[]', 200, headers: headers, request: request);
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
    );
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

  setUp(() {
    deletedEntryIds.clear();
    removedAudioPaths.clear();
  });

  Widget buildTestApp({
    required GratitudeEntry entry,
    VoidCallback? onDeleted,
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: GratitudeTile(entry: entry, onDeleted: onDeleted ?? () {}),
      ),
    );
  }

  GratitudeEntry makeEntry({String? mood = 'Happy', String? audioAssetPath}) {
    return GratitudeEntry(
      id: 'entry-1',
      userId: 'user-1',
      text: 'Grateful for sunshine',
      createdAt: DateTime.now(),
      mood: mood,
      audioAssetPath: audioAssetPath,
    );
  }

  testWidgets('renders mood and audio', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(entry: makeEntry(audioAssetPath: 'user-1/audio-1.m4a')),
    );

    expect(find.text('Grateful for sunshine'), findsOneWidget);
    expect(find.text('Happy'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('renders the expected icon for each mood', (tester) async {
    final moodCases = <(String, IconData)>[
      ('Happy', Icons.sentiment_very_satisfied_rounded),
      ('Good', Icons.sentiment_satisfied_rounded),
      ('Neutral', Icons.sentiment_neutral_rounded),
      ('Confused', Icons.psychology_alt_rounded),
      ('Sad', Icons.sentiment_dissatisfied_rounded),
      ('Overwhelmed', Icons.warning_amber_rounded),
      ('Frustrated', Icons.whatshot_rounded),
      ('Angry', Icons.mood_bad_rounded),
      ('Calm', Icons.emoji_emotions_outlined),
    ];

    for (final (mood, icon) in moodCases) {
      await tester.pumpWidget(buildTestApp(entry: makeEntry(mood: mood)));

      expect(find.text(mood), findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);
    }
  });

  testWidgets('dark theme', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(),
        theme: ThemeData.dark(),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.color, Colors.black);
  });

  testWidgets('hides UI and shows delete confirmation dialog', (tester) async {
    await tester.pumpWidget(buildTestApp(entry: makeEntry(mood: null)));

    expect(find.text('Happy'), findsNothing);
    expect(find.byType(Chip), findsNothing);
    expect(find.byType(Slider), findsNothing);
    expect(find.byIcon(Icons.play_circle), findsNothing);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete reflection?'), findsOneWidget);
    expect(find.text('This cannot be undone'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('closes delete dialog when cancel', (tester) async {
    await tester.pumpWidget(buildTestApp(entry: makeEntry()));

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Delete reflection?'), findsNothing);
    expect(deletedEntryIds, isEmpty);
  });

  testWidgets('deletes entry and calls onDeleted after confirmation', (
    tester,
  ) async {
    var onDeletedCalled = false;

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: 'assets/user-1/audio-1.m4a'),
        onDeleted: () {
          onDeletedCalled = true;
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(onDeletedCalled, isTrue);
    expect(deletedEntryIds, contains('eq.entry-1'));
    expect(removedAudioPaths, contains('assets/user-1/audio-1.m4a'));
  });
}
