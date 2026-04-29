import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_2025_prek/services/auth_service.dart' deferred as auth_service;
import 'package:_2025_prek/services/gratitude_service.dart'
    deferred as gratitude_service;

void main() {
  late MockClient mockHttpClient;
  Map<String, dynamic>? lastInsertPayload;

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/auth/v1/token') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final email = body['email'] as String?;

      if (email == 'mock@gmail.com') {
        return http.Response(
          jsonEncode({
            'id': 'user-1',
            'aud': 'authenticated',
            'email': email,
            'created_at': '2026-04-18T10:00:00.000Z',
          }),
          200,
          headers: headers,
          request: request,
        );
      }

      return http.Response(
        jsonEncode({'msg': 'Invalid login credentials'}),
        400,
        headers: headers,
        request: request,
      );
    }

    if (path == '/rest/v1/Gratitude Entries' && request.method == 'POST') {
      lastInsertPayload = jsonDecode(request.body) as Map<String, dynamic>;

      if (lastInsertPayload!['text'] == 'force insert failure') {
        return http.Response(
          jsonEncode({'message': 'insert failed'}),
          500,
          headers: headers,
          request: request,
        );
      }

      return http.Response(
        jsonEncode([lastInsertPayload]),
        201,
        headers: headers,
        request: request,
      );
    }

    return http.Response('{}', 200, headers: headers, request: request);
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    try {
      if (Supabase.instance.isInitialized) {
        await Supabase.instance.dispose();
      }
    } catch (_) {}

    mockHttpClient = MockClient(handleRequest);
    await Supabase.initialize(
      url: 'http://localhost',
      anonKey: 'test-anon-key',
      httpClient: mockHttpClient,
    );

    await auth_service.loadLibrary();
    await gratitude_service.loadLibrary();
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

  setUp(() async {
    lastInsertPayload = null;
    await Supabase.instance.client.auth.signOut();
  });

  Future<void> signInTestUser() async {
    await Supabase.instance.client.auth.recoverSession(
      jsonEncode({
        'access_token': 'test-access-token',
        'token_type': 'bearer',
        'expires_in': 3600,
        'refresh_token': 'test-refresh-token',
        'user': {
          'id': 'user-1',
          'aud': 'authenticated',
          'email': 'zzq123@gmail.com',
          'app_metadata': {'provider': 'email'},
          'user_metadata': null,
          'created_at': '2026-04-18T10:00:00.000Z',
        },
      }),
    );
  }

  group('auth_service.login', () {
    test('error when sign in fails', () async {
      expect(
        () => auth_service.login('zzq@gmail.com', 'zzq123'),
        throwsA(equals('Email or password incorrect')),
      );
    });

    test('error when auth has no session', () async {
      expect(
        () => auth_service.login('mock@gmail.com', 'wrong-password'),
        throwsA(equals('Email or password incorrect')),
      );
    });
  });

  group('gratitude_service.saveGratitudeEntry', () {
    test('no logged in user', () async {
      expect(
        () => gratitude_service.saveGratitudeEntry(text: 'Test entry'),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            'Exception: User not logged in',
          ),
        ),
      );
    });

    test('saves entry for logged in user', () async {
      await signInTestUser();

      await gratitude_service.saveGratitudeEntry(
        text: 'Gratful for sunshine',
        mood: 'Happy',
        audioPath: 'audio/test.m4a',
      );

      expect(lastInsertPayload, isNotNull);
      expect(lastInsertPayload!['user_id'], 'user-1');
      expect(lastInsertPayload!['text'], 'Gratful for sunshine');
      expect(lastInsertPayload!['mood'], 'Happy');
      expect(lastInsertPayload!['audio_path'], 'audio/test.m4a');
      expect(lastInsertPayload!['created_at'], isA<String>());
    });

    test('insert errors for logged in user', () async {
      await signInTestUser();

      expect(
        () =>
            gratitude_service.saveGratitudeEntry(text: 'force insert failure'),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            contains('Error saving gratitude entry'),
          ),
        ),
      );
    });
  });
}
