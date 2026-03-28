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



