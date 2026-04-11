import 'package:flutter/material.dart';
import 'dart:io';

class MemoryCard {
  final String imagePath;
  final String caption;
  final DateTime date;

  const MemoryCard({
  required this.imagePath,
  required this.caption,
  required this.date,
  });
}

class PictureReflectionPage extends StatefulWidget {
  const PictureReflectionPage({super.key});

  @override
  State<PictureReflectionPage> createState() => _PictureReflectionPageState();
}

class _PictureReflectionPageState extends State<PictureReflectionPage>
    with TickerProviderStateMixin {
  static const Color pink = Color(0xFFFB7DA8);
  static const Color yellow = Color(0xFFFFC567);
  static const Color blue = Color(0xFF058CD7);
  static const Color softWhite = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF94697E);
  static const Color bgTop = Color(0xFFFFF1F5);
  static const Color bgBottom = Color(0xFFFFF8EE);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color pinkLight = Color(0xFFFFE4EF);

  final List<MemoryCard> _memories = [
  MemoryCard(
    imagePath: 'placeholder',
    caption: 'N/A',
    date: DateTime(2025, 1, 1),
  ),
  MemoryCard(
    imagePath: 'placeholder',
    caption: 'N/A',
    date: DateTime(2025, 2, 2),
  ),
  MemoryCard(
    imagePath: 'placeholder',
    caption: 'N/a',
    date: DateTime(2025, 3, 3),
  ),
  ];

  late final AnimationController _fabController;
  late final Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fabScale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }
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
                imagePath: imagePath,
                caption: caption,
                date: DateTime.now(),
              ),
            );
          });
        },
      ),
    );
  }

  void _openMemory(MemoryCard memory) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: _MemoryFullScreen(memory: memory),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgTop,
        body: CustomScrollView(
            slivers: [
          SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: bgTop,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: _Header(),
          ),
          leading: const SizedBox.shrink(),
          actions: const [SizedBox.shrink()],
        ),

        SliverToBoxAdapter(child: _SparkBanner(memories: _memories)),

        SliverToBoxAdapter(
            child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                  Text(
                  'Your happy moments',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                    const Spacer(),
                    Text(
                      '${_memories.length} memories',
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
            ),
        ),

        _memories.isEmpty
            ? SliverFillRemaining(child: _EmptyState())
            : SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverGrid(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _MemoryTile(
                  memory: _memories[index],
                  index: index,
                  onTap: () => _openMemory(_memories[index]),
                ),
                childCount: _memories.length,
              ),
            ),
        ),
            ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ScaleTransition(
            scale: _fabScale,
            child: GestureDetector(
                onTapDown: (_) => _fabController.forward(),
                onTapUp: (_) {
                  _fabController.reverse();
                  _openAddMemorySheet();
                },
                onTapCancel: () => _fabController.reverse(),
                child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [pink, Color(0xFFFF9BC0)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: pink.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_photo_alternate_rounded,
                          color: softWhite, size: 22),
                      const SizedBox(width: 10),
                      const Text(
                        'Add a memory',
                        style: TextStyle(
                          color: softWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ),
        ),
    );
  }
}

class _Header extends StatelessWidget {
  static const Color pink = Color(0xFFFB7DA8);
  static const Color yellow = Color(0xFFFFC567);
  static const Color bgTop = Color(0xFFFFF1F5);
  static const Color textColor = Color(0xFF94697E);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, Color(0xFFFFF8EE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // decorative dots row
              Row(
              children: List.generate(
              5,
                    (i) => Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i % 2 == 0
                        ? pink.withOpacity(0.35)
                        : yellow.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 28,
                      height: 1.25,
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  children: [
                    const TextSpan(text: 'Your smile\n'),
                    TextSpan(
                      text: 'album',
                      style: TextStyle(
                        color: pink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
            ),
                  const SizedBox(height: 6),
                  Text(
                    'Peek back at moments that made you glow',
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}

class _SparkBanner extends StatelessWidget {
  final List<MemoryCard> memories;

  static const Color pink = Color(0xFFFB7DA8);
  static const Color yellow = Color(0xFFFFC567);
  static const Color textColor = Color(0xFF94697E);
  static const Color softWhite = Color(0xFFFFFFFF);

  const _SparkBanner({required this.memories});

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) return const SizedBox.shrink();

    final pick = memories[DateTime.now().millisecondsSinceEpoch % memories.length];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC567), Color(0xFFFFD98C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: yellow.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        child: Row(
          children: [
          // sparkle icon
          Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: softWhite.withOpacity(0.45),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text('✨', style: TextStyle(fontSize: 22)),
          ),
        ),

        const SizedBox(width: 14),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const Text(
              'A moment to smile about',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: softWhite,
              ),
            ),
                const SizedBox(height: 3),
                Text(
                  '"${pick.caption}"',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A4F00),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
           ),
          ],
        ),
    );
  }
}

class _MemoryTile extends StatefulWidget {
  final MemoryCard memory;
  final int index;
  final VoidCallback onTap;

  const _MemoryTile({
    required this.memory,
    required this.index,
    required this.onTap,
  });

  @override
  State<_MemoryTile> createState() => _MemoryTileState();
}
class _MemoryTileState extends State<_MemoryTile>
    with SingleTickerProviderStateMixin {
  static const Color pink = Color(0xFFFB7DA8);
  static const Color textColor = Color(0xFF94697E);
  static const Color cardBg = Color(0xFFFFFFFF);

  late final AnimationController _ctrl;
  late final Animation<double> _fadeSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.index * 80),
    )..forward();
    _fadeSlide = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _fadeSlide,
        child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.12),
              end: Offset.zero,
            ).animate(_fadeSlide),
            child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: pink.withOpacity(0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    Expanded(
                    child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                ),
              child: _buildImage(),
            ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
              widget.memory.caption,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
                children: [
                Icon(Icons.calendar_today_rounded,
                size: 10,
                color: textColor.withOpacity(0.45)),
            const SizedBox(width: 4),
            Text(
                _formatDate(widget.memory.date),
                style: TextStyle(
                  fontSize: 10.5,
                  color: textColor.withOpacity(0.5),
                ),
            ),
                ],
            ),
              ],
            ),
        ),
                        ],
                    ),
                ),
            ),
        ),
    );
  }

  Widget _buildImage() {
    if (widget.memory.imagePath == 'placeholder') {
      // Warm gradient placeholder until real images are picked
      final List<List<Color>> palettes = [
        [const Color(0xFFFFD6E8), const Color(0xFFFFA8CC)],
        [const Color(0xFFFFEAB0), const Color(0xFFFFC567)],
        [const Color(0xFFB3DEFF), const Color(0xFF6BB8F7)],
        [const Color(0xFFD7F5D0), const Color(0xFF8ADBA0)],
      ];
      final p = palettes[widget.index % palettes.length];
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: p,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text('🌸', style: TextStyle(fontSize: 36)),
        ),
      );
    }

    return Image.file(
      File(widget.memory.imagePath),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class _EmptyState extends StatelessWidget {
  static const Color pink = Color(0xFFFB7DA8);
  static const Color textColor = Color(0xFF94697E);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Text('📷', style: const TextStyle(fontSize: 52)),
      const SizedBox(height: 16),
      Text(
        'No memories yet',
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),

            const SizedBox(height: 8),
            Text(
              'Tap the button below to add your\nfirst happy moment!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.55),
                height: 1.5,
              ),
            ),
          ],
      ),
    );
  }
}

class _AddMemorySheet extends StatefulWidget {
  final void Function(String caption, String imagePath) onAdd;

  const _AddMemorySheet({required this.onAdd});

  @override
  State<_AddMemorySheet> createState() => _AddMemorySheetState();
}

class _AddMemorySheetState extends State<_AddMemorySheet> {
  static const Color pink = Color(0xFFFB7DA8);
  static const Color yellow = Color(0xFFFFC567);
  static const Color textColor = Color(0xFF94697E);
  static const Color bgTop = Color(0xFFFFF1F5);
  static const Color pinkLight = Color(0xFFFFE4EF);

  String? _pickedPath;
  final TextEditingController _captionCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      setState(() => _pickedPath = file.path);
    }
  }

  void _submit() {
    final caption = _captionCtrl.text.trim();
    if (caption.isEmpty) return;
    widget.onAdd(caption, _pickedPath ?? 'placeholder');
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: bgTop,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      // drag handle
      Center(
      child: Container(
      width: 38,
        height: 4,
        decoration: BoxDecoration(
          color: pink.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    const SizedBox(height: 20),

    Text(
    'Capture a happy moment',
    style: const TextStyle(
    fontFamily: 'Georgia',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textColor,
    ),
    ),
    const SizedBox(height: 4),
    Text(
    'Pick a photo that makes you smile',
    style: TextStyle(
    fontSize: 13, color: textColor.withOpacity(0.55)),
    ),
    const SizedBox(height: 20),
    GestureDetector(
    onTap: () => _showImageSourceDialog(),
    child: Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: pinkLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: pink.withOpacity(0.25), width: 1.5),
      ),
      child: _pickedPath != null
        ? ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Image.file(
        File(_pickedPath!),
        fit: BoxFit.cover,
        ),
      )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
              color: pink, size: 36),
          const SizedBox(height: 8),
          Text(
            'Tap to add a photo',
            style: TextStyle(
              color: pink,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
    ),
        const SizedBox(height: 18),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
          Border.all(color: pink.withOpacity(0.2), width: 1.5),
    ),
    child: TextField(
      controller: _captionCtrl,
      maxLines: 3,
      maxLength: 140,
      style: const TextStyle(
        color: textColor,
        fontSize: 14,
        fontFamily: 'Georgia',
    ),
    decoration: InputDecoration(
    hintText:
    'What made this moment special?',
      hintStyle: TextStyle(
        color: textColor.withOpacity(0.4), fontSize: 13),
      contentPadding: const EdgeInsets.all(14),
      border: InputBorder.none,
      counterStyle:
        TextStyle(color: textColor.withOpacity(0.35)),
        ),
      ),
    ),
    const SizedBox(height: 20),

    SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: pink,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
         ),
        child: const Text(
          'Save to my album',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    ),
      ],
    ),
  );
}
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
        ListTile(
        leading:
        const Icon(Icons.camera_alt_rounded, color: Color(0xFFFB7DA8)),
        title: const Text('Take a photo'),
        onTap: () {
          Navigator.pop(context);
          _pickImage(ImageSource.camera);
        },
      ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded,
                    color: Color(0xFFFB7DA8)),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
        ),
      ),
    );
  }
}







