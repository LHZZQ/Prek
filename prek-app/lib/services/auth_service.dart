import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Login existing user with email and password
Future<void> login(String email, String password) async {
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    if (response.session == null) {
      throw Exception('Login failed. Check email and password.');
    }
  } catch (e) {
    throw Exception('Error logging in: $e');
  }
}
