import 'package:_2025_prek/picture_reflection_page.dart';
import 'package:_2025_prek/reflection_page.dart';
import 'package:_2025_prek/task_selection_page.dart';
import 'package:_2025_prek/voice_reflection_page.dart';
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

  Future<void> pumpTaskSelectionPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: TaskSelectionPage(selectedMood: 'Happy')),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders task selection content', (tester) async {
    useLargeViewport(tester);
    await pumpTaskSelectionPage(tester);

    expect(find.text('You are feeling Happy today'), findsOneWidget);
    expect(find.text('What would you like to do?'), findsOneWidget);
    expect(find.text('Write a Reflection'), findsOneWidget);
    expect(find.text('Voice Reflection'), findsOneWidget);
    expect(find.text('Lookbook'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios_rounded), findsNWidgets(3));
  });

  testWidgets('navigates to reflection page', (tester) async {
    useLargeViewport(tester);
    await pumpTaskSelectionPage(tester);

    await tester.tap(find.text('Write a Reflection'));
    await tester.pumpAndSettle();

    expect(find.byType(ReflectionPage), findsOneWidget);
    expect(find.text('Reflection 🌸'), findsOneWidget);
  });

  testWidgets('navigates to voice reflection page', (tester) async {
    useLargeViewport(tester);
    await pumpTaskSelectionPage(tester);
    await tester.tap(find.text('Voice Reflection'));
    await tester.pumpAndSettle();
    expect(find.byType(VoiceReflectionPage), findsOneWidget);
    expect(find.byType(TaskSelectionPage), findsNothing);
  });

  testWidgets('lookbook opens picture reflection page', (tester) async {
    useLargeViewport(tester);
    await pumpTaskSelectionPage(tester);

    await tester.tap(find.text('Lookbook'));
    await tester.pumpAndSettle();

    expect(find.byType(PictureReflectionPage), findsOneWidget);
    expect(find.byType(TaskSelectionPage), findsNothing);
  });

  testWidgets('app bar back button pops to previous page', (tester) async {
    useLargeViewport(tester);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TaskSelectionPage(selectedMood: 'Happy'),
                      ),
                    );
                  },
                  child: const Text('Go to Task Selection'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go to Task Selection'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskSelectionPage), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Go to Task Selection'), findsOneWidget);
    expect(find.byType(TaskSelectionPage), findsNothing);
  });
}
