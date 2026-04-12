import 'package:_2025_prek/voice_reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey:
          'sample',
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
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

  Future<void> pumpVoicePage(WidgetTester tester, {String mood = 'Happy'}) async {
    await tester.pumpWidget(
      MaterialApp(home: VoiceReflectionPage(selectedMood: mood)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders basic UI', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    expect(find.text('Voice Reflection'), findsOneWidget);
    expect(find.text('Reflecting on: Happy'), findsOneWidget);
    expect(find.text('Tap or Hold to record'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('SAVE REFLECTION'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
  });

  testWidgets('save button is disabled before recording', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester);

    final saveButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'SAVE REFLECTION'),
    );

    expect(saveButton.onPressed, isNull);
  });

  testWidgets('shows selected mood text', (tester) async {
    useLargeViewport(tester);
    await pumpVoicePage(tester, mood: 'Calm');
    expect(find.text('Reflecting on: Calm'), findsOneWidget);
  });
}
