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
    PathProviderPlatform.instance = _FakePathProviderPlatform();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, (call) async {
          switch (call.method) {
            case 'create':
            case 'start':
            case 'dispose':
              return null;
            case 'hasPermission':
              return true;
            case 'stop':
              return '/tmp/fake_recording.m4a';
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

    expect(find.text('Voice Reflection'), findsOneWidget);
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
}
