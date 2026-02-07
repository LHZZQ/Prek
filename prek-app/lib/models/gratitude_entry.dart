class GratitudeEntry {
  final String id;  // unique identifier for entry
  final String userId; //profile
  final String text; //text content
  final DateTime createdAt; // timestamp
  final String? mood; // mood
  final String? audioAssetPath; // audio

  GratitudeEntry({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.mood,
    this.audioAssetPath,
  });

  factory GratitudeEntry.fromMap(Map<String, dynamic> map) {
    return GratitudeEntry(
      id: map['id'],
      userId: map['user_id'],
      text: map['text'],
      createdAt: DateTime.parse(map['created_at']),
      mood: map['mood'],
      audioAssetPath: map['audio_url']
    );
  }
}
