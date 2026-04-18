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

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path == '/auth/v1/token') {
      return http.Response(
        jsonEncode({'msg': 'Invalid login credentials'}),
        400,
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

  group('auth_service.login', () {
    test('error when sign in fails', () async {
      expect(
        () => auth_service.login('zzq@gmail.com', 'zzq123'),
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
  });
}
