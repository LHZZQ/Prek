import 'dart:convert';
import 'dart:typed_data';
import 'package:_2025_prek/picture_reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
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

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    try {
      if (Supabase.instance.isInitialized) {
        await Supabase.instance.dispose();
      }
    } catch (_) {}

    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'test-anon-key',
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
    expect(find.widgetWithText(ElevatedButton, 'Save to album'), findsOneWidget);
  });

  testWidgets('image is shown in preview', (
    tester,
  ) async {
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
}
