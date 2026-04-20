import 'package:_2025_prek/picture_reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpPictureReflectionPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: false,
          splashFactory: InkRipple.splashFactory,
        ),
        home: const PictureReflectionPage(selectedMood: 'Happy'),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders default memories', (tester) async {
    useLargeViewport(tester);
    await pumpPictureReflectionPage(tester);

    expect(find.text('Your happy moments'), findsOneWidget);
    expect(
      find.text('Snap moments that make you smile, and revisit them anytime.'),
      findsOneWidget,
    );
    expect(find.text('3 saved'), findsOneWidget);
    expect(find.text('Coffee with my friend'), findsOneWidget);
    expect(find.text('Pretty sunset'), findsOneWidget);
    expect(find.text('cute dog'), findsOneWidget);
    expect(
      find.widgetWithText(FloatingActionButton, 'Add a memory'),
      findsOneWidget,
    );
  });

  testWidgets('adds a memory', (tester) async {
    useLargeViewport(tester);
    await pumpPictureReflectionPage(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add a memory'));
    await tester.pumpAndSettle();

    expect(find.text('Save a moment'), findsOneWidget);
    expect(find.text('Save to album'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField),
      'Grateful for sunshine',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save to album'));
    await tester.pumpAndSettle();

    expect(find.text('Grateful for sunshine'), findsOneWidget);
    expect(find.text('4 saved'), findsOneWidget);
  });

  testWidgets('opens memory detail', (tester) async {
    useLargeViewport(tester);
    await pumpPictureReflectionPage(tester);

    await tester.tap(find.text('Pretty sunset'));
    await tester.pumpAndSettle();

    expect(find.text('Pretty sunset'), findsOneWidget);
    expect(find.text('February 2, 2025'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Your happy moments'), findsOneWidget);
  });
}
