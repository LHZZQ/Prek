import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color pink = Color(0xFFFB7DA8);
const Color textColor = Color(0xFF94697E);
const Color bgColor = Color(0xFFFFF1F5);

class MemoryCard {
  final String caption;
  final DateTime date;
  final String? imagePath;
  final dynamic imageBytes;

  MemoryCard({
    required this.caption,
    required this.date,
    this.imagePath,
    this.imageBytes,
  });
}

class MemoryStore {
  static final List<MemoryCard> memories = [];
}

Widget memoryImage({
  dynamic imageBytes,
  String? imagePath,
  BoxFit fit = BoxFit.cover,
}) {
  if (imageBytes != null) {
    return Image.memory(imageBytes as dynamic, fit: fit);
  }
  return const SizedBox.shrink();
}

class PictureReflectionPage extends StatelessWidget {
  final String selectedMood;

  const PictureReflectionPage({super.key, required this.selectedMood});

  void _openAddMemorySheet(BuildContext context) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddMemorySheet(
        selectedMood: selectedMood,
        onAdd: (caption, imageBytes) {
          MemoryStore.memories.insert(
            0,
            MemoryCard(
              caption: caption,
              date: DateTime.now(),
              imageBytes: imageBytes,
            ),
          );
        },
      ),
    ).then((saved) {
      if (saved == true && context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(text: 'Capture\na '),
                    TextSpan(
                      text: 'Happy Moments',
                      style: TextStyle(color: pink),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'What made you smile today? Save it here.',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.55),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => _openAddMemorySheet(context),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: pink,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: pink.withOpacity(0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Add a new memory',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to choose a photo & add a caption',
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddMemorySheet extends StatefulWidget {
  final String selectedMood;
  final void Function(String caption, dynamic imageBytes) onAdd;

  const _AddMemorySheet({required this.selectedMood, required this.onAdd});

  @override
  State<_AddMemorySheet> createState() => _AddMemorySheetState();
}

class _AddMemorySheetState extends State<_AddMemorySheet> {
  final TextEditingController _captionCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  dynamic _imageBytes;

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  void _submit() {
    final caption = _captionCtrl.text.trim();
    if (caption.isEmpty) return;
    widget.onAdd(caption, _imageBytes);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Center(
      child: Container(
      width: 34,
        height: 4,
        decoration: BoxDecoration(
          color: pink.withOpacity(0.25),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),






