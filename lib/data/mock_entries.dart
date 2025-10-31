import '../models/gratitude_entry.dart';

final List<GratitudeEntry> mockEntries = [
  GratitudeEntry(
    text: 'Grateful for sunshine',
    mood: 'happy',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    audioAssetPath: 'assets/audio/gratitude1.m4a', // can relplay
  ),
  GratitudeEntry(
    text: 'Had a nice walk',
    mood: 'calm',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    // no sound just display the time
  ),
  GratitudeEntry(
    text: 'Good chat with a friend',
    mood: 'warm',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    audioAssetPath: 'assets/audio/gratitude2.m4a',
  ),
];
