import 'package:_2025_prek/mood_page.dart';
import 'package:_2025_prek/task_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpMoodPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(0.9)),
          child: MoodPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

// Will update the mood when we add more mood options
  testWidgets('render mood and greeting', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpMoodPage(tester);

    expect(find.text('How are you feeling\ntoday?'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsNWidgets(8));

    expect(find.text('Happy'), findsOneWidget);
    expect(find.text('Good'), findsOneWidget);
    expect(find.text('Neutral'), findsOneWidget);
    expect(find.text('Confused'), findsOneWidget);
    expect(find.text('Sad'), findsOneWidget);
    expect(find.text('Overwhelmed'), findsOneWidget);
    expect(find.text('Frustrated'), findsOneWidget);
    expect(find.text('Angry'), findsOneWidget);

// For now, we have 3 greetings
    final greetingCount = <String>[
      'Good morning',
      'Good afternoon',
      'Good evening',
    ].where((g) => find.text(g).evaluate().isNotEmpty).length;
    expect(greetingCount, 1);
  });

  testWidgets('Next button is disabled until a mood is selected', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpMoodPage(tester);

    final nextButton = find.widgetWithText(ElevatedButton, 'Next');
    expect(nextButton, findsOneWidget);
    expect(tester.widget<ElevatedButton>(nextButton).onPressed, isNull);
    // can't be pressed until a mood is selected

    final happyBefore = tester.widget<Text>(find.text('Happy'));
    expect(happyBefore.style?.fontWeight, FontWeight.w700);

    await tester.tap(find.text('Happy'));
    await tester.pumpAndSettle();

    final happyAfter = tester.widget<Text>(find.text('Happy'));
    expect(happyAfter.style?.fontWeight, FontWeight.w900);
    expect(tester.widget<ElevatedButton>(nextButton).onPressed, isNotNull);
  });

  testWidgets('navigates with the latest selected mood', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpMoodPage(tester);

    await tester.tap(find.text('Happy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Angry'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskSelectionPage), findsOneWidget);
    expect(find.text('You are feeling Angry today'), findsOneWidget);
  });

  testWidgets('use expected colors', (tester) async {
    useLargeViewport(tester);
    await pumpMoodPage(tester);

    const softWhite = Color(0xFFFFFFFF);
    const pink = Color(0xFFFB7DA8);
    const blue = Color(0xFF058CD7);
    const yellow = Color(0xFFFFC567);

    final warm = Color.lerp(softWhite, yellow, 0.55)!;
    final cool = Color.lerp(softWhite, blue, 0.40)!;
    final pinkish = Color.lerp(softWhite, pink, 0.45)!;

    final avatars = tester.widgetList<CircleAvatar>(find.byType(CircleAvatar));
    final warmCount = avatars.where((a) => a.backgroundColor == warm).length;
    final coolCount = avatars.where((a) => a.backgroundColor == cool).length;
    final pinkCount = avatars.where((a) => a.backgroundColor == pinkish).length;

    expect(warmCount, 2);
    expect(coolCount, 2);
    expect(pinkCount, 4);
  });
}
