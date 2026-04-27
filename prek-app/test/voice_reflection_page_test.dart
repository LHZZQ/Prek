import 'package:_2025_prek/voice_reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async => '/tmp';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const recordChannel = MethodChannel('com.llfbandit.record/messages');
  bool mockHasPermission = true;
  String? mockStopPath = '/tmp/fake_recording.m4a';

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'sample',
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );
  });

  setUp(() {
    mockHasPermission = true;
    mockStopPath = '/tmp/fake_recording.m4a';
    PathProviderPlatform.instance = _FakePathProviderPlatform();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, (call) async {
          switch (call.method) {
            case 'create':
            case 'start':
            case 'dispose':
              return null;
            case 'hasPermission':
              return mockHasPermission;
            case 'stop':
              return mockStopPath;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, null);
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpVoicePage(
    WidgetTester tester, {
    String mood = 'Happy',
  }) async {
    await tester.pumpWidget(
      MaterialApp(home: VoiceReflectionPage(selectedMood: mood)),
    );
    await tester.pumpAndSettle();
  }

  Future<_RecordingNavigatorObserver> pumpVoicePageWithObserver(
    WidgetTester tester,
  ) async {
    final observer = _RecordingNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [observer],
        home: const VoiceReflectionPage(selectedMood: 'Happy'),
      ),
    );
    await tester.pumpAndSettle();
    observer.pushed.clear();
    return observer;
  }

  Future<void> openVoiceRoute(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const VoiceReflectionPage(selectedMood: 'Happy'),
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

  Finder recordButtonFinder() {
    return find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector &&
          widget.onTap != null &&
          widget.onLongPressStart != null &&
          widget.onLongPressMoveUpdate != null &&
          widget.onLongPressEnd != null,
    );
  }

  testWidgets('renders basic UI', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Relection'),
      ),
      findsOneWidget,
    );
    expect(find.text('Reflecting on: Happy'), findsOneWidget);
    expect(find.text('Tap or Hold to record'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Save Reflection'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
  });

  testWidgets('save button is disabled before recording', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    final saveButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Save Reflection'),
    );

    expect(saveButton.onPressed, isNull);
  });

  testWidgets('shows selected mood text', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester, mood: 'Calm');
    expect(find.text('Reflecting on: Calm'), findsOneWidget);
  });

  testWidgets('back button pops voice reflection route', (tester) async {
    useLargeViewport(tester);
    await openVoiceRoute(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(VoiceReflectionPage), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('renders dark mode', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: false),
        home: const VoiceReflectionPage(selectedMood: 'Happy'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tap or Hold to record'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
  });

  testWidgets('tap start/stop enables preview and redo can reset', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    final detector = tester.widget<GestureDetector>(recordButtonFinder());
    detector.onTap!.call();
    await tester.idle();
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('01:00'), findsNothing);
    expect(find.text('00:01'), findsOneWidget);

    final detectorAfterStart = tester.widget<GestureDetector>(
      recordButtonFinder(),
    );
    detectorAfterStart.onTap!.call();
    await tester.idle();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Redo'), findsOneWidget);

    final saveEnabledButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Save Reflection'),
    );
    expect(saveEnabledButton.onPressed, isNotNull);

    final redoChip = tester.widget<ActionChip>(
      find.widgetWithText(ActionChip, 'Redo'),
    );
    redoChip.onPressed!.call();
    await tester.pumpAndSettle();

    expect(find.text('00:00'), findsOneWidget);
    final saveDisabledButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Save Reflection'),
    );
    expect(saveDisabledButton.onPressed, isNull);
  });

  testWidgets('long press and slide up shows cancel', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);
    final detector = tester.widget<GestureDetector>(recordButtonFinder());
    detector.onLongPressStart!.call(const LongPressStartDetails());
    await tester.idle();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);

    detector.onLongPressMoveUpdate!.call(
      const LongPressMoveUpdateDetails(localOffsetFromOrigin: Offset(0, -100)),
    );
    await tester.pump();

    expect(find.text('Release to cancel 🗑️'), findsOneWidget);
    expect(find.byIcon(Icons.delete_forever_rounded), findsOneWidget);
  });

  testWidgets('long press slide up cancel', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    final detector = tester.widget<GestureDetector>(recordButtonFinder());
    detector.onLongPressStart!.call(const LongPressStartDetails());
    await tester.idle();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    detector.onLongPressMoveUpdate!.call(
      const LongPressMoveUpdateDetails(localOffsetFromOrigin: Offset(0, -100)),
    );
    await tester.pump();

    detector.onLongPressEnd!.call(const LongPressEndDetails());
    await tester.idle();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'shows permission denied snackbar when do not have mic permission',
    (tester) async {
      mockHasPermission = false;
      useLargeViewport(tester);
      await pumpVoicePage(tester);

      final detector = tester.widget<GestureDetector>(recordButtonFinder());
      detector.onTap!.call();
      await tester.idle();
      await tester.pumpAndSettle();

      expect(find.text('Microphone permission denied'), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsNothing);
    },
  );

  testWidgets('long press end without cancel stops and keeps recording', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    final detector = tester.widget<GestureDetector>(recordButtonFinder());
    detector.onLongPressStart!.call(const LongPressStartDetails());
    await tester.idle();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:01'), findsOneWidget);

    detector.onLongPressEnd!.call(const LongPressEndDetails());
    await tester.idle();
    await tester.pumpAndSettle();

    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Redo'), findsOneWidget);
  });

  testWidgets('save reflection failure shows snackbar and exit', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    final detector = tester.widget<GestureDetector>(recordButtonFinder());
    detector.onTap!.call();
    await tester.idle();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final detectorAfterStart = tester.widget<GestureDetector>(
      recordButtonFinder(),
    );
    detectorAfterStart.onTap!.call();
    await tester.idle();
    await tester.pumpAndSettle();

    final saveButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Save Reflection'),
    );
    expect(saveButton.onPressed, isNotNull);

    saveButton.onPressed!.call();
    await tester.idle();
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to save:'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  final navCases = ['Home', 'History', 'Profile', 'Lookbook', 'Settings'];

  for (final label in navCases) {
    testWidgets('bottom nav pushes $label route', (tester) async {
      useLargeViewport(tester);
      final observer = await pumpVoicePageWithObserver(tester);

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
