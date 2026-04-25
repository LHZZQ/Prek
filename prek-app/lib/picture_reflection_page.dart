import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_2025_prek/home_page.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';
import 'package:_2025_prek/settings_page.dart';
import 'package:_2025_prek/memory_gallery_page.dart';

const Color pink = Color(0xFFFB7DA8);
const Color textColor = Color(0xFF94697E);
const Color bgColor = Color(0xFFFFF1F5);

class PictureReflectionPage extends StatefulWidget {
  final String selectedMood;
  const PictureReflectionPage({super.key, required this.selectedMood});

  @override
  State<PictureReflectionPage> createState() => _PictureReflectionPageState();
}

class _PictureReflectionPageState extends State<PictureReflectionPage> {
  void _openAddMemorySheet(BuildContext context) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddMemorySheet(selectedMood: widget.selectedMood),
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

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EntryHistoryPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MemoryGalleryPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? Color(0xFF2A2A3D) : Color(0xFFFFF8EE),
          selectedItemColor: isDark ? Colors.white : Colors.grey.shade400,
          unselectedItemColor: isDark ? Colors.white : Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_album_rounded),
              label: 'Lookbook',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _AddMemorySheet extends StatefulWidget {
  final String selectedMood;
  const _AddMemorySheet({required this.selectedMood});

  @override
  State<_AddMemorySheet> createState() => _AddMemorySheetState();
}

class _AddMemorySheetState extends State<_AddMemorySheet> {
  final TextEditingController _captionCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _isSaving = false;

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

  Future<void> _submit() async {
    final caption = _captionCtrl.text.trim();
    if (caption.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      String? imagePath;

      if (_imageBytes != null) {
        final fileName =
            '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        await client.storage
            .from('memories')
            .uploadBinary(
              fileName,
              _imageBytes!,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        imagePath = fileName;
      }

      await client.from('Gratitude Entries').insert({
        'user_id': user.id,
        'text': caption,
        'mood': widget.selectedMood,
        'image_path': imagePath,
        'created_at': DateTime.now().toLocal().toIso8601String(),
      });

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    }
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

          const SizedBox(height: 18),
          const Text(
            'Save a moment',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Add a photo and a short note',
            style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: _isSaving ? null : _pickImage,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4EF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pink.withOpacity(0.2)),
              ),
              clipBehavior: Clip.hardEdge,
              child: _imageBytes != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(_imageBytes!, fit: BoxFit.cover),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Change',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: pink,
                          size: 30,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap to choose a photo',
                          style: TextStyle(
                            color: pink.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: pink.withOpacity(0.18)),
            ),
            child: TextField(
              controller: _captionCtrl,
              maxLines: 2,
              maxLength: 100,
              style: const TextStyle(
                color: textColor,
                fontSize: 14,
                fontFamily: 'Georgia',
              ),
              decoration: InputDecoration(
                hintText: 'What made this moment special?',
                hintStyle: TextStyle(
                  color: textColor.withOpacity(0.35),
                  fontSize: 13,
                ),
                contentPadding: const EdgeInsets.all(12),
                border: InputBorder.none,
                counterStyle: TextStyle(
                  color: textColor.withOpacity(0.3),
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Save to album',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
