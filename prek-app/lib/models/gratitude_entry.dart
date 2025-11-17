class GratitudeEntry {
  final String text;            // text content
  final DateTime createdAt;     // timestamp
  final String? mood;           //  mood
  final String? audioAssetPath; // audio (local asset, web URL)

  GratitudeEntry({
    required this.text,
    required this.createdAt,
    this.mood,
    this.audioAssetPath,
  });

  // from supabase
  // GratitudeEntry.fromMap(Map<String, dynamic> m)
  //   : text = m['text'],
  //     createdAt = DateTime.parse(m['created_at']),
  //     mood = m['mood'],
  //     audioAssetPath = m['audio_url'];
}
