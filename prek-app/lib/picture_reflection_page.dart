import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

const Color pink = Color(0xFFFB7DA8);
const Color textColor = Color(0xFF94697E);
const Color bgColor = Color(0xFFFFF1F5);

class MemoryCard {
  final String caption;
  final DateTime date;
  final String? imagePath;

  MemoryCard({required this.caption, required this.date, this.imagePath});
}

class PictureReflectionPage extends StatefulWidget {
  final String selectedMood;

  const PictureReflectionPage({super.key, required this.selectedMood});

  @override
  State<PictureReflectionPage> createState() => _PictureReflectionPageState();
}

class _PictureReflectionPageState extends State<PictureReflectionPage> {
  //with TickerProviderStateMixin {
  //static const Color pink = Color(0xFFFB7DA8);
  //static const Color yellow = Color(0xFFFFC567);
  //static const Color blue = Color(0xFF058CD7);
  //static const Color softWhite = Color(0xFFFFFFFF);
  //static const Color textColor = Color(0xFF94697E);
  //static const Color bgTop = Color(0xFFFFF1F5);
  //static const Color bgBottom = Color(0xFFFFF8EE);
  //static const Color cardBg = Color(0xFFFFFFFF);
  //static const Color pinkLight = Color(0xFFFFE4EF);

  final List<MemoryCard> _memories = [
    MemoryCard(caption: 'Coffee with my friend', date: DateTime(2025, 1, 1)),

    MemoryCard(caption: 'Pretty sunset', date: DateTime(2025, 2, 2)),

    MemoryCard(caption: 'cute dog', date: DateTime(2025, 3, 3)),
  ];

  void _openAddMemorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddMemorySheet(
        onAdd: (caption, imagePath) {
          setState(() {
            _memories.insert(
              0,
              MemoryCard(
                caption: caption,
                date: DateTime.now(),
                imagePath: imagePath,
              ),
            );
          });
        },
      ),
    );
  }

  void _openMemory(MemoryCard memory) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _MemoryFullScreen(memory: memory)),
    );
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

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  const Text(
                    'Your happy moments',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_memories.length} saved',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _memories.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 100),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 200,
                          ),
                      itemCount: _memories.length,
                      itemBuilder: (context, index) => _MemoryTile(
                        memory: _memories[index],
                        index: index,
                        onTap: () => _openMemory(_memories[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddMemorySheet,
        backgroundColor: pink,
        elevation: 4,
        icon: const Icon(
          Icons.add_photo_alternate_rounded,
          color: Colors.white,
        ),
        label: const Text(
          'Add a memory',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4EF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: pink,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No memories yet',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your first happy moment',
            style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}

class _MemoryTile extends StatelessWidget {
  final MemoryCard memory;
  final int index;
  final VoidCallback onTap;

  const _MemoryTile({
    required this.memory,
    required this.index,
    required this.onTap,
  });

  static const List<List<Color>> palettes = [
    [Color(0xFFFFD6E8), Color(0xFFF9A8C9)],
    [Color(0xFFFFEAB0), Color(0xFFFAC95C)],
    [Color(0xFFB8DAFF), Color(0xFF79B8F5)],
    [Color(0xFFD4EED0), Color(0xFF9FD49A)],
  ];

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = palettes[index % palettes.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: pink.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 110,
                width: double.infinity,
                child: memory.imagePath != null
                    ? Image.network(memory.imagePath!, fit: BoxFit.cover)
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.caption,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatDate(memory.date),
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddMemorySheet extends StatefulWidget {
  final void Function(String caption, String? imagePath) onAdd;

  const _AddMemorySheet({required this.onAdd});

  @override
  State<_AddMemorySheet> createState() => _AddMemorySheetState();
}

class _AddMemorySheetState extends State<_AddMemorySheet> {
  final TextEditingController _captionCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _pickedImagePath;

  //static const Color pink = Color(0xFFFB7DA8);

  //static const Color yellow = Color(0xFFFFC567);

  //static const Color textColor = Color(0xFF94697E);

  //static const Color bgTop = Color(0xFFFFF1F5);

  //static const Color pinkLight = Color(0xFFFFE4EF);

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Shows a bottom sheet letting the user choose camera or gallery
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: pink),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                if (image != null) {
                  setState(() => _pickedImagePath = image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: pink),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                );
                if (image != null) {
                  setState(() => _pickedImagePath = image.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final caption = _captionCtrl.text.trim();
    if (caption.isEmpty) return;
    widget.onAdd(caption, _pickedImagePath);
    Navigator.of(context).pop();
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
            onTap: _pickImage,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4EF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pink.withOpacity(0.2)),
              ),
              clipBehavior: Clip.hardEdge,
              child: _pickedImagePath != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(_pickedImagePath!, fit: BoxFit.cover),

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
              onPressed: _submit,
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

class _MemoryFullScreen extends StatelessWidget {
  final MemoryCard memory;

  //static const Color pink = Color(0xFFFB7DA8);
  //static const Color textColor = Color(0xFF94697E);
  //static const Color bgBottom = Color(0xFFFFF8EE);

  const _MemoryFullScreen({required this.memory});

  String _formatDate(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: memory.imagePath != null
                ? Image.network(memory.imagePath!, fit: BoxFit.cover)
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD6E8), Color(0xFFF9A8C9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 260,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 14,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory.caption,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: Colors.white.withOpacity(0.55),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(memory.date),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
