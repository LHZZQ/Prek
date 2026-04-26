import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_2025_prek/home_page.dart';
import 'package:_2025_prek/settings_page.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';

const Color _pink = Color(0xFFFB7DA8);

class MemoryGalleryPage extends StatefulWidget {
  const MemoryGalleryPage({super.key});

  @override
  State<MemoryGalleryPage> createState() => _MemoryGalleryPageState();
}

class _MemoryGalleryPageState extends State<MemoryGalleryPage> {
  final _client = Supabase.instance.client;
  List<Map<String, dynamic>> _memories = [];
  bool _isLoading = true;
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
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
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    setState(() => _isLoading = true);

    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      final data = await _client
          .from('Gratitude Entries')
          .select('id, text, image_path, created_at')
          .eq('user_id', user.id)
          .not('image_path', 'is', null)
          .order('created_at', ascending: false);

      final enriched = await Future.wait(
        (data as List<dynamic>).map((entry) async {
          final map = Map<String, dynamic>.from(entry);

          try {
            map['signed_url'] = await _client.storage
                .from('memories')
                .createSignedUrl(map['image_path'] as String, 3600);
          } catch (_) {
            map['signed_url'] = null;
          }
          return map;
        }),
      );

      if (mounted) setState(() => _memories = enriched);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load memories: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteMemory(String id, String imagePath) async {
    try {
      await _client.storage.from('memories').remove([imagePath]);
      await _client.from('Gratitude Entries').delete().eq('id', id);

      setState(() => _memories.removeWhere((m) => m['id'] == id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }

  void _openMemory(Map<String, dynamic> memory) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _MemoryFullScreen(memory: memory)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final _bgColor = isDark ? const Color(0xFF1E1E2C) : const Color(0xFFFFF1F5);
    final _textColor = isDark ? Colors.white : const Color(0xFF94697E);
    const activeColor = Color(0xFFFB7DA8);
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text(
          'Lookbook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _bgColor,
        elevation: 0,
        foregroundColor: _textColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(text: 'Your\n'),
                      TextSpan(
                        text: 'Lookbook',
                        style: TextStyle(color: _pink),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Every moment worth keeping.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? _textColor.withOpacity(0.8)
                        : _textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
            child: Row(
              children: [
                Text(
                  'All memories',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_memories.length} saved',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? _textColor.withOpacity(0.8)
                        : _textColor.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: _pink))
                : _memories.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    color: _pink,
                    onRefresh: _loadMemories,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 200,
                          ),
                      itemCount: _memories.length,
                      itemBuilder: (context, index) => _MemoryTile(
                        memory: _memories[index],
                        index: index,
                        onTap: () => _openMemory(_memories[index]),
                        onDelete: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete memory?'),
                              content: const Text(
                                  'This will permanently remove the memory.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: _pink,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            _deleteMemory(_memories[index]['id'] as String,
                              _memories[index]['image_path'] as String,);
                          }
                        },
                      ),
                    ),
                  ),
          ),
        ],
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? Color(0xFF2A2A3D) : Color(0xFFFFF8EE),
          selectedItemColor: activeColor,
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

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final _textColor = isDark ? Colors.white : const Color(0xFF94697E);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4EF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: _pink,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No memories yet',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add one from the reflection flow',
            style: TextStyle(fontSize: 13, color: _textColor.withOpacity(0.45)),
          ),
        ],
      ),
    );
  }
}

class _MemoryTile extends StatelessWidget {
  final Map<String, dynamic> memory;

  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _MemoryTile({
    required this.memory,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  static const List<List<Color>> palettes = [
    [Color(0xFFFFD6E8), Color(0xFFF9A8C9)],
    [Color(0xFFFFEAB0), Color(0xFFFAC95C)],
    [Color(0xFFB8DAFF), Color(0xFF79B8F5)],
    [Color(0xFFD4EED0), Color(0xFF9FD49A)],
  ];

  String _formatDate(String isoDate) {
    final d = DateTime.parse(isoDate).toLocal();

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final _textColor = isDark ? Colors.white : const Color(0xFF94697E);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF161622) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.7)
                  : _pink.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: memory['signed_url'] != null
                        ? Image.network(
                            memory['signed_url'] as String,
                            fit: BoxFit.cover,
                          )
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
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory['text'] as String? ?? '',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatDate(memory['created_at'] as String),
                    style: TextStyle(
                      fontSize: 10,
                      color: _textColor.withOpacity(0.4),
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

class _MemoryFullScreen extends StatelessWidget {
  final Map<String, dynamic> memory;

  const _MemoryFullScreen({required this.memory});

  String _formatDate(String isoDate) {
    final d = DateTime.parse(isoDate).toLocal();
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
            child: memory['signed_url'] != null
                ? Image.network(
                    memory['signed_url'] as String,
                    fit: BoxFit.cover,
                  )
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
                  memory['text'] as String? ?? '',
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
                      _formatDate(memory['created_at'] as String),
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
