import 'package:_2025_prek/reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlc3QiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTUxNjIzOTAyMn0.signature',
    );
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

  testWidgets('renders reflection page UI', (tester) async {
    useLargeViewport(tester);
    await pumpReflectionPage(tester);

    expect(find.text('Reflection 🌸'), findsOneWidget);
    expect(
      find.text(
        "Take a moment to reflect on something you're grateful for today 💭",
      ),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Write your reflection here...'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save Reflection'), findsOneWidget);
  });

  testWidgets('does nothing when save is tapped with empty input', (tester) async {
    useLargeViewport(tester);
    await pumpReflectionPage(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Reflection'));
    await tester.pumpAndSettle();

    expect(find.byType(ReflectionPage), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('shows error snackbar when saving fails', (tester) async {
    useLargeViewport(tester);
    await pumpReflectionPage(tester);

    await tester.enterText(find.byType(TextField), 'I am grateful for sunshine');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Reflection'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Error saving reflection:'), findsOneWidget);
  });
}
