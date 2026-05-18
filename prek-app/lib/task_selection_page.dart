import 'package:_2025_prek/picture_reflection_page.dart';
import 'package:flutter/material.dart';
import 'package:_2025_prek/home_page.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';
import 'package:_2025_prek/settings_page.dart';
//import 'picture_reflection_page.dart';
import 'reflection_page.dart';
import 'voice_reflection_page.dart';
import 'package:_2025_prek/memory_gallery_page.dart';
import 'package:_2025_prek/utils/ui_text.dart';

class TaskSelectionPage extends StatefulWidget {
  final String selectedMood;

  const TaskSelectionPage({super.key, required this.selectedMood});

  @override
  State<TaskSelectionPage> createState() => _TaskSelectionPageState();
}

class _TaskSelectionPageState extends State<TaskSelectionPage> {
  static const softWhite = Color(0xFFFFFFFF);
  static const pink = Color(0xFFFB7DA8);
  static const yellow = Color(0xFFFFC567);
  static const blue = Color(0xFF058CD7);

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
    final textColor = isDark ? Colors.white : const Color(0xFF94697E);
    final cardBg = isDark ? Color(0xFF1E1E2C) : softWhite.withOpacity(0.8);
    final currentTextColor = isDark ? Colors.white : textColor;
    final topBarColor = isDark
        ? const Color(0xFF1E1E2C)
        : const Color(0xFFFFF1F5);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: topBarColor,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1E1E2C), Color(0xFF2A2A3D)]
                : const [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "你今天的心情是：${moodLabelZh(widget.selectedMood)}",
                  style: TextStyle(
                    color: currentTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "想用哪种方式记录？",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: currentTextColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                _buildTaskCard(
                  context,
                  isDark: isDark,
                  cardBg: cardBg,
                  currentTextColor: currentTextColor,
                  icon: Icons.edit_note_rounded,
                  iconBg: isDark ? yellow : yellow.withOpacity(0.3),
                  title: "文字反思",
                  subtitle: "用文字写下此刻的想法",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ReflectionPage(selectedMood: widget.selectedMood),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildTaskCard(
                  context,
                  isDark: isDark,
                  cardBg: cardBg,
                  currentTextColor: currentTextColor,
                  icon: Icons.mic_rounded,
                  iconBg: isDark ? blue : blue.withOpacity(0.2),
                  title: "语音反思",
                  subtitle: "用声音记录你的想法",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VoiceReflectionPage(
                          selectedMood: widget.selectedMood,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildTaskCard(
                  context,
                  isDark: isDark,
                  cardBg: cardBg,
                  currentTextColor: currentTextColor,
                  icon: Icons.photo_library_rounded,
                  iconBg: isDark ? pink : pink.withOpacity(0.2),
                  title: "相册",
                  subtitle: "用照片保存你的旅程",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PictureReflectionPage(
                          selectedMood: widget.selectedMood,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
              label: homeLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: historyLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: profileLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_album_rounded),
              label: lookbookLabel,
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: settingsLabel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context, {
    required bool isDark,
    required Color cardBg,
    required Color currentTextColor,
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(
                icon,
                color: isDark ? Colors.white : Color(0xFF94697E),
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: currentTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: currentTextColor.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: currentTextColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
