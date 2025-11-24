import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> saveGratitudeEntry(String text) async {
  try {
    await supabase.from('Gratitude Entries').insert({
      'text': text,
      'created_at': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    throw Exception('Error saving gratitude entry: $e');
  }
}
