import '../models/gratitude_entry.dart';

final List<GratitudeEntry> mockEntries = [
  GratitudeEntry(
    id: 'entry1',
    userId: 'user123',
    text: 'Grateful for sunshine',
    mood: 'happy',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    audioAssetPath: 'user123/gratitude1.m4a', // can relplay
  ),
  GratitudeEntry(
    id: 'entry2',
    userId: 'user123',
    text: 'Had a nice walk',
    mood: 'calm',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    // no sound just display the time
  ),
  GratitudeEntry(
    id: 'entry3',
    userId: 'user123',
    text: 'Good chat with a friend',
    mood: 'warm',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    audioAssetPath: 'user123/gratitude2.m4a',
  ),
];
