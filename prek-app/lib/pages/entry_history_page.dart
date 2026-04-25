import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/gratitude_entry.dart';
import '../utils/time_utils.dart';
import '../widgets/gratitude_tile.dart';
import 'package:_2025_prek/profile_page.dart';
import 'package:_2025_prek/settings_page.dart';
import 'package:_2025_prek/memory_gallery_page.dart';
import 'package:_2025_prek/home_page.dart';

class EntryHistoryPage extends StatefulWidget {
  const EntryHistoryPage({super.key});

  @override
  State<EntryHistoryPage> createState() => _EntryHistoryPageState();
}

class _EntryHistoryPageState extends State<EntryHistoryPage> {
  final supabase = Supabase.instance.client;
  List<GratitudeEntry> items = [];
  bool loading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
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

  Future<void> _loadEntries() async {
    final response = await supabase
        .from('Gratitude Entries')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      items = response
          .map<GratitudeEntry>((e) => GratitudeEntry.fromMap(e))
          .toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textColorOriginal = Color(0xFF94697E);
    const topBarColor = Color(0xFFFFF1F5);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : textColorOriginal;

    Widget buildBackground(Widget child) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1E1E2C), Color(0xFF2A2A3D)]
                : const [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),
        child: child,
      );
    }

    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF2A2A3D) : topBarColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: textColor),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),

          title: Text(
            "Gratitude History",
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
        ),
        body: buildBackground(
          Center(
            child: Text(
              "No entries yet.\nAdd your first gratitude today!",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: textColor),
            ),
          ),
        ),
        //bottomNavigationBar: _buildNavBar(isDark, navBarBg),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF2A2A3D) : topBarColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Gratitude History",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: buildBackground(
        ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final e = items[i];
            final showHeader =
                i == 0 || !sameDay(e.createdAt, items[i - 1].createdAt);
            String two(int n) => n.toString().padLeft(2, '0');
            final dateStr =
                '${e.createdAt.year}-${two(e.createdAt.month)}-${two(e.createdAt.day)}';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeader)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      dateStr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                GratitudeTile(
                  entry: e,
                  onDeleted: () {
                    setState(() {
                      items.removeWhere((item) => item.id == e.id);
                    });
                  },
                ),
              ],
            );
          },
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? Color(0xFF2A2A3D) : Color(0xFFFFF8EE),
          selectedItemColor: Color(0xFFFB7DA8),
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

  /*Widget _buildNavBar(bool isDark, Color navBarBg) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: navBarBg,
      selectedItemColor: const Color(0xFFFB7DA8),
      unselectedItemColor: isDark ? Colors.white70 : Colors.grey.shade400,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_rounded),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
  */
}
