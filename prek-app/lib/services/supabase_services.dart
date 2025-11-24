import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> saveGratitudeEntry(String text) async {
  final response = await supabase.from('gratitude_entries').insert({
    'text': text,
    'created': DateTime.now().toIso8601String(),
  });

  if (response.error != null) {
    throw response.error!;
  }
}