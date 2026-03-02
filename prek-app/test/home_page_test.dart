import 'package:_2025_prek/home_page.dart';
import 'package:_2025_prek/mood_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpHomePage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(0.85),
          ), //Reduce the size of the text to reduce the overflow
          child: HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('homepage core content', (tester) async {
    useLargeViewport(tester);
    await pumpHomePage(tester);

    //expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    expect(find.textContaining('Welcome Back'), findsOneWidget);
    expect(
      find.text('Your next affirmation will appear tomorrow'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, 'Start Reflection'),
      findsOneWidget,
    );
  });

  testWidgets('tapping Start Reflection navigates to mood page', (
    tester,
  ) async {
    useLargeViewport(tester);
    await pumpHomePage(tester);

    final startReflection = find.text('Start Reflection');
    await tester.ensureVisible(startReflection);
    await tester.tap(startReflection);
    await tester.pumpAndSettle();

    expect(find.byType(MoodPage), findsOneWidget);
  });

  // testWidgets('menu shows all items', (tester) async {
  //   useLargeViewport(tester);
  //   await pumpHomePage(tester);

  //   await tester.tap(find.byIcon(Icons.menu));
  //   await tester.pumpAndSettle();

  //   expect(find.text('Profile'), findsOneWidget);
  //   expect(find.text('Settings'), findsOneWidget);
  //   expect(find.text('History'), findsOneWidget);
  // });

  // testWidgets('menu onSelected handles settings branch', (tester) async {
  //   useLargeViewport(tester);
  //   await pumpHomePage(tester);

  //   final popup = tester.widget<PopupMenuButton<String>>(
  //     find.byType(PopupMenuButton<String>),
  //   );
  //   popup.onSelected?.call('settings');
  //   await tester.pump();

  //   expect(tester.takeException(), isNull);
  // });

  test('Affirmation is stable within the same day', () {
    final state = HomePageState();

    final first = state.getAffirmationForToday();
    final second = state.getAffirmationForToday();

    expect(first, second);
    expect(state.affirmations, contains(first));
  });
}
