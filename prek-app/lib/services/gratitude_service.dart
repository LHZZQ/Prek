import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Saves new gratitude entry to Supabase database
Future<void> saveGratitudeEntry({required String text, String? mood, String? audioPath}) async {
  final user = supabase.auth.currentUser;
  if (user == null) throw Exception('User not logged in');

  try {
    await supabase.from('Gratitude Entries').insert({
      'user_id': user.id,
      'text': text,
      'mood': mood,
      'audio_path': audioPath,
      'created_at': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    throw Exception('Error saving gratitude entry: $e');
  }
}
