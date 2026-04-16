import 'package:_2025_prek/models/gratitude_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GratitudeEntry.fromMap', () {
    test('parses all fields from a complete map', () {
      final entry = GratitudeEntry.fromMap({
        'id': 'entry-1',
        'user_id': 'user-1',
        'text': 'grateful for sunshine',
        'created_at': '2026-04-16T08:30:00.000Z',
        'mood': 'Happy',
        'audio_path': 'user-1/audio-1.m4a',
      });

      expect(entry.id, 'entry-1');
      expect(entry.userId, 'user-1');
      expect(entry.text, 'grateful for sunshine');
      expect(entry.createdAt, DateTime.parse('2026-04-16T08:30:00.000Z'));
      expect(entry.mood, 'Happy');
      expect(entry.audioAssetPath, 'user-1/audio-1.m4a');
    });

    test('keeps optional fields null when they are missing', () {
      final entry = GratitudeEntry.fromMap({
        'id': 'entry-2',
        'user_id': 'user-2',
        'text': 'I am grateful for lunch.',
        'created_at': '2026-04-15T12:00:00.000Z',
        'mood': null,
        'audio_path': null,
      });

      expect(entry.id, 'entry-2');
      expect(entry.userId, 'user-2');
      expect(entry.text, 'I am grateful for lunch.');
      expect(entry.createdAt, DateTime.parse('2026-04-15T12:00:00.000Z'));
      expect(entry.mood, isNull);
      expect(entry.audioAssetPath, isNull);
    });
  });
}
