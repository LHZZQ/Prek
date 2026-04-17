import 'package:_2025_prek/models/gratitude_entry.dart';
import 'package:_2025_prek/widgets/gratitude_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp({
    required GratitudeEntry entry,
    VoidCallback? onDeleted,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: GratitudeTile(
          entry: entry,
          onDeleted: onDeleted ?? () {},
        ),
      ),
    );
  }

  GratitudeEntry makeEntry({
    String? mood = 'Happy',
    String? audioAssetPath,
  }) {
    return GratitudeEntry(
      id: 'entry-1',
      userId: 'user-1',
      text: 'I am grateful for sunshine',
      createdAt: DateTime.now(),
      mood: mood,
      audioAssetPath: audioAssetPath,
    );
  }

  testWidgets('renders mood and audio controls when optional fields exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(audioAssetPath: 'user-1/audio-1.m4a'),
      ),
    );

    expect(find.text('I am grateful for sunshine'), findsOneWidget);
    expect(find.text('Happy'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('hides UI and shows delete confirmation dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        entry: makeEntry(mood: null),
      ),
    );

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
}
