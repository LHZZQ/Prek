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

  MemoryCard({required this.caption, required this.date, this.imagePath, this.imageBytes,});
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


  final List<MemoryCard> _memories = [
    MemoryCard(caption: 'Coffee with my friend', date: DateTime(2025, 1, 1)),

    MemoryCard(caption: 'Pretty sunset', date: DateTime(2025, 2, 2)),

    MemoryCard(caption: 'cute dog', date: DateTime(2025, 3, 3)),
  ];



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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(text: 'Capture\n'),
                        TextSpan(
                          text: 'Happy Moments',
                          style: TextStyle(color: pink),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Snap moments that make you smile, and revisit them anytime.',
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),

