import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Saves new gratitude entry to Supabase database
Future<void> saveGratitudeEntry({
  required String text,
  String? mood,
  String? audioPath,
}) async {
  final user = supabase.auth.currentUser;
  if (user == null) throw Exception('用户未登录');

  try {
    await supabase.from('Gratitude Entries').insert({
      'user_id': user.id,
      'text': text,
      'mood': mood,
      'audio_path': audioPath,
    });
  } catch (e) {
    throw Exception('保存感恩记录失败：$e');
  }
}
