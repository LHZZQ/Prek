import 'dart:async';
import 'dart:convert';
import 'package:_2025_prek/models/gratitude_entry.dart';
import 'package:_2025_prek/widgets/gratitude_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeGratitudeAudioController implements GratitudeAudioController {
  final positionController = StreamController<Duration>.broadcast();
  final durationController = StreamController<Duration>.broadcast();
  final stateController = StreamController<PlayerState>.broadcast();

  final calls = <String>[];
  String? lastPlayedUrl;
  Duration? lastSeekPosition;
  bool failOnPlay = false;

  @override
  Stream<Duration> get onPositionChanged => positionController.stream;

  @override
  Stream<Duration> get onDurationChanged => durationController.stream;

  @override
  Stream<PlayerState> get onPlayerStateChanged => stateController.stream;

  @override
  Future<void> play(String publicUrl) async {
    calls.add('play');
    lastPlayedUrl = publicUrl;
    if (failOnPlay) {
      throw Exception('play failed');
    }
  }

  @override
  Future<void> pause() async {
    calls.add('pause');
  }

  @override
  Future<void> stop() async {
    calls.add('stop');
  }

  @override
  Future<void> seek(Duration position) async {
    calls.add('seek');
    lastSeekPosition = position;
  }

  Future<void> dispose() async {
    await positionController.close();
    await durationController.close();
    await stateController.close();
  }
}

void main() {
  late MockClient mockHttpClient;
  final deletedEntryIds = <String>[];
  final removedAudioPaths = <String>[];
  final audioControllers = <FakeGratitudeAudioController>[];
  var failDeleteRequests = false;

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/rest/v1/Gratitude Entries' && request.method == 'DELETE') {
      if (failDeleteRequests) {
        return http.Response(
          jsonEncode({'message': 'delete failed'}),
          500,
          headers: headers,
          request: request,
        );
      }

      deletedEntryIds.add(request.url.queryParameters['id'] ?? '');
      return http.Response('[]', 200, headers: headers, request: request);
    }

    if (path.contains('/storage/v1/object/gratitude-audio') &&
        request.method == 'DELETE') {
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

  tearDown(() async {
    for (final controller in audioControllers) {
      await controller.dispose();
    }
    audioControllers.clear();
  });

  setUp(() {
    deletedEntryIds.clear();
    removedAudioPaths.clear();
    failDeleteRequests = false;
  });

  Widget buildTestApp({
    required GratitudeEntry entry,
    VoidCallback? onDeleted,
    ThemeData? theme,
    GratitudeAudioController? audioController,
  }) {
    return MaterialApp(
      theme: theme ?? ThemeData(useMaterial3: false),
      home: Scaffold(
        body: GratitudeTile(
          entry: entry,
          onDeleted: onDeleted ?? () {},
          audioController:
              audioController ?? SharedGratitudeAudioController.instance,
        ),
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

  FakeGratitudeAudioController makeAudioController() {
    final controller = FakeGratitudeAudioController();
    audioControllers.add(controller);
    return controller;
  }

  test('normalize path removes prefixes and spaces', () {
    expect(
      normalizeGratitudeStoragePath(' /assets/user-1/audio-1.m4a '),
      'user-1/audio-1.m4a',
    );
    expect(
      normalizeGratitudeStoragePath('assets/user-1/audio-2.m4a'),
      'user-1/audio-2.m4a',
    );
    expect(
      normalizeGratitudeStoragePath('/user-1/audio-3.m4a'),
      'user-1/audio-3.m4a',
    );
  });

  testWidgets('renders text mood time and audio controls', (tester) async {
    await tester.pumpWidget(
      buildTestApp(entry: makeEntry(audioAssetPath: 'user-1/audio-1.m4a')),
    );

    expect(find.text('Happy'), findsOneWidget);
    expect(find.textContaining('Today'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('renders expected icon for each mood branch', (tester) async {
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

  testWidgets('uses dark theme and hides optional UI', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(mood: null),
        theme: ThemeData.dark(useMaterial3: false),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.color, Colors.black);
    expect(find.byType(Chip), findsNothing);
    expect(find.byIcon(Icons.play_circle), findsNothing);
    expect(find.byType(Slider), findsNothing);
  });

  testWidgets('renders dark mood chip colors', (tester) async {
    final moodCases = <(String, Color)>[
      ('Happy', const Color(0xFFFFC567)),
      ('Good', const Color(0xFFFFC567)),
      ('Neutral', const Color(0xFF058CD7)),
      ('Confused', const Color(0xFF058CD7)),
      ('Sad', const Color(0xFFFB7DA8)),
      ('Overwhelmed', const Color(0xFFFB7DA8)),
      ('Frustrated', const Color(0xFFFB7DA8)),
      ('Angry', const Color(0xFFFB7DA8)),
      ('Calm', Colors.grey),
    ];

    for (final (mood, expectedColor) in moodCases) {
      await tester.pumpWidget(
        buildTestApp(
          entry: makeEntry(mood: mood),
          theme: ThemeData.dark(useMaterial3: false),
        ),
      );

      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(find.text(mood), findsOneWidget);
      if (mood == 'Calm') {
        expect(chip.backgroundColor, Colors.grey.shade300);
      } else {
        expect(chip.backgroundColor, expectedColor);
      }
    }
  });

  testWidgets('shows delete dialog and cancel', (tester) async {
    await tester.pumpWidget(buildTestApp(entry: makeEntry()));

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete reflection?'), findsOneWidget);
    expect(find.text('This cannot be undone'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Delete reflection?'), findsNothing);
    expect(deletedEntryIds, isEmpty);
  });

  testWidgets('deletes audio and calls onDeleted', (tester) async {
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

  testWidgets('deletes text without removing audio', (tester) async {
    var onDeletedCalled = false;

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: null),
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
    expect(removedAudioPaths, isEmpty);
  });

  testWidgets('shows snackbar when delete fails', (tester) async {
    failDeleteRequests = true;
    var onDeletedCalled = false;

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(),
        onDeleted: () {
          onDeletedCalled = true;
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(onDeletedCalled, isFalse);
    expect(find.textContaining('Failed to delete:'), findsOneWidget);
  });

  testWidgets('play button stops previous audio and plays normalized url', (
    tester,
  ) async {
    final controller = makeAudioController();

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: ' /assets/user-1/audio-9.m4a '),
        audioController: controller,
      ),
    );

    await tester.tap(find.byIcon(Icons.play_circle));
    await tester.pumpAndSettle();

    expect(controller.calls, ['stop', 'play']);
    expect(
      controller.lastPlayedUrl,
      'http://localhost/storage/v1/object/public/gratitude-audio/user-1/audio-9.m4a',
    );
  });

  testWidgets('pause button', (tester) async {
    final controller = makeAudioController();

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: 'user-1/audio-2.m4a'),
        audioController: controller,
      ),
    );

    await tester.tap(find.byIcon(Icons.play_circle));
    await tester.pump();
    controller.stateController.add(PlayerState.playing);
    await tester.pump();

    expect(find.byIcon(Icons.pause_circle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.pause_circle));
    await tester.pumpAndSettle();

    expect(controller.calls, ['stop', 'play', 'pause']);
  });

  testWidgets('updates timer', (tester) async {
    final controller = makeAudioController();

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: 'user-1/audio-3.m4a'),
        audioController: controller,
      ),
    );

    await tester.tap(find.byIcon(Icons.play_circle));
    await tester.pump();
    controller.stateController.add(PlayerState.playing);
    controller.durationController.add(const Duration(seconds: 40));
    controller.positionController.add(const Duration(seconds: 10));
    await tester.pump();

    expect(find.text('00:10'), findsOneWidget);

    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(0.5);
    await tester.pumpAndSettle();

    expect(controller.lastSeekPosition, const Duration(seconds: 20));
  });

  testWidgets('resets playback UI when finished', (tester) async {
    final controller = makeAudioController();

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: 'user-1/audio-4.m4a'),
        audioController: controller,
      ),
    );

    await tester.tap(find.byIcon(Icons.play_circle));
    await tester.pump();
    controller.stateController.add(PlayerState.playing);
    controller.durationController.add(const Duration(seconds: 20));
    controller.positionController.add(const Duration(seconds: 8));
    await tester.pump();

    expect(find.text('00:08'), findsOneWidget);

    controller.stateController.add(PlayerState.completed);
    await tester.pump();

    expect(find.byIcon(Icons.play_circle), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('shows snackbar when fails', (tester) async {
    final controller = makeAudioController()..failOnPlay = true;

    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: 'assets/user-1/audio-error.m4a'),
        audioController: controller,
      ),
    );

    await tester.tap(find.byIcon(Icons.play_circle));
    await tester.pumpAndSettle();

    expect(find.text('Could not play audio'), findsOneWidget);
  });
}
