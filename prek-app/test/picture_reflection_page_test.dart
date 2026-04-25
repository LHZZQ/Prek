import 'dart:convert';
import 'dart:typed_data';
import 'package:_2025_prek/picture_reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeImagePickerPlatform extends ImagePickerPlatform {
  XFile? pickedFile;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    return pickedFile;
  }

  @override
  Future<LostDataResponse> getLostData() async {
    return LostDataResponse.empty();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeImagePickerPlatform fakeImagePicker;
  late Uint8List imageBytes;
  late MockClient mockHttpClient;
  Map<String, dynamic>? lastInsertPayload;
  String? lastUploadPath;

  Future<http.Response> handleRequest(http.Request request) async {
    final path = Uri.decodeComponent(request.url.path);
    final headers = {'content-type': 'application/json'};

    if (path.startsWith('/storage/v1/object/memories/') &&
        request.method == 'POST') {
      lastUploadPath = path.replaceFirst('/storage/v1/object/memories/', '');
      return http.Response(
        jsonEncode({'Key': 'memories/$lastUploadPath'}),
        200,
        headers: headers,
        request: request,
      );
    }

    if (path == '/rest/v1/Gratitude Entries' && request.method == 'POST') {
      lastInsertPayload = jsonDecode(request.body) as Map<String, dynamic>;
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
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );

    imageBytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Wn8qS0AAAAASUVORK5CYII=',
    );
  });

  setUp(() {
    fakeImagePicker = _FakeImagePickerPlatform();
    fakeImagePicker.pickedFile = null;
    ImagePickerPlatform.instance = fakeImagePicker;
    lastInsertPayload = null;
    lastUploadPath = null;
  });

  tearDownAll(() {
    mockHttpClient.close();
  });

  void useLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpPictureReflectionPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: const PictureReflectionPage(selectedMood: 'Happy'),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> setLoggedInSession() async {
    await Supabase.instance.client.auth.setInitialSession(
      jsonEncode({
        'access_token': 'test-token',
        'refresh_token': 'test-refresh-token',
        'token_type': 'bearer',
        'user': {
          'id': '00000000-0000-0000-0000-000000000001',
          'aud': 'authenticated',
          'app_metadata': {'provider': 'email'},
          'user_metadata': {},
          'email': 'zzq@gmail.com',
          'created_at': '2026-01-01T00:00:00.000000Z',
        },
      }),
    );
  }

  Finder addMemoryCardFinder() {
    return find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector &&
          widget.onTap != null &&
          find
              .descendant(
                of: find.byWidget(widget),
                matching: find.text('Add a new memory'),
              )
              .evaluate()
              .isNotEmpty,
    );
  }

  Finder choosePhotoAreaFinder() {
    return find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector &&
          widget.onTap != null &&
          find
              .descendant(
                of: find.byWidget(widget),
                matching: find.text('Tap to choose a photo'),
              )
              .evaluate()
              .isNotEmpty,
    );
  }

  testWidgets('renders picture reflection UI', (tester) async {
    useLargeViewport(tester);
    await pumpPictureReflectionPage(tester);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Happy Moments'),
      ),
      findsOneWidget,
    );
    expect(
      find.text('What made you smile today? Save it here.'),
      findsOneWidget,
    );
    expect(find.text('Add a new memory'), findsOneWidget);
    expect(find.text('Tap to choose a photo & add a caption'), findsOneWidget);
    expect(find.byIcon(Icons.add_photo_alternate_rounded), findsOneWidget);
  });

  testWidgets('tapping add memory opens the page', (tester) async {
    useLargeViewport(tester);
    await pumpPictureReflectionPage(tester);

    await tester.tap(addMemoryCardFinder());
    await tester.pumpAndSettle();

    expect(find.text('Save a moment'), findsOneWidget);
    expect(find.text('Add a photo and a short note'), findsOneWidget);
    expect(find.text('Tap to choose a photo'), findsOneWidget);
    expect(find.text('What made this moment special?'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Save to album'),
      findsOneWidget,
    );
  });

  testWidgets('image is shown in preview', (tester) async {
    useLargeViewport(tester);
    fakeImagePicker.pickedFile = XFile.fromData(
      imageBytes,
      name: 'picture_reflection_test_image.png',
      mimeType: 'image/png',
    );
    await pumpPictureReflectionPage(tester);

    await tester.tap(addMemoryCardFinder());
    await tester.pumpAndSettle();

    await tester.tap(choosePhotoAreaFinder());
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Change'), findsOneWidget);
    expect(find.text('Tap to choose a photo'), findsNothing);
  });

  testWidgets('save with empty keeps openning', (tester) async {
    useLargeViewport(tester);
    await pumpPictureReflectionPage(tester);

    await tester.tap(addMemoryCardFinder());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save to album'));
    await tester.pumpAndSettle();

    expect(find.text('Save a moment'), findsOneWidget);
    expect(find.byType(PictureReflectionPage), findsOneWidget);
    expect(find.textContaining('Failed to save:'), findsNothing);
  });

  testWidgets('save with image succeeds and returns to home page', (tester) async {
    useLargeViewport(tester);
    await setLoggedInSession();
    fakeImagePicker.pickedFile = XFile.fromData(
      imageBytes,
      name: 'picture_reflection_test_image.png',
      mimeType: 'image/png',
    );
    await pumpPictureReflectionPage(tester);

    await tester.tap(addMemoryCardFinder());
    await tester.pumpAndSettle();

    await tester.tap(choosePhotoAreaFinder());
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'A happy moment from today',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save to album'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome Back'), findsOneWidget);
    expect(lastUploadPath, isNotNull);
    expect(lastUploadPath, startsWith('00000000-0000-0000-0000-000000000001/'));
    expect(lastUploadPath, endsWith('.jpg'));
    expect(lastInsertPayload?['text'], 'A happy moment from today');
    expect(lastInsertPayload?['mood'], 'Happy');
    expect(
      lastInsertPayload?['user_id'],
      '00000000-0000-0000-0000-000000000001',
    );
    expect(lastInsertPayload?['image_path'], lastUploadPath);
  });
}
