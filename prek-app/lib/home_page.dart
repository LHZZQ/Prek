import 'package:_2025_prek/settings_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:_2025_prek/mood_page.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';
import 'package:_2025_prek/memory_gallery_page.dart';
import 'package:_2025_prek/utils/ui_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final affirmations = [
    "我感恩今天带来的每一个小小快乐。",
    "我值得拥有爱、平静和幸福。",
    "每一刻都是重新开始的机会。",
    "我选择专注于自己能掌控的事情。",
    "我的心愿意接纳感恩与善意。",
    "此刻的我正走在属于自己的位置上。",
    "我相信人生有自己的节奏。",
    "我每天都在努力成为更好的自己。",
    "我正在靠近更好的自己。",
    "即使遇到挑战，我也愿意温柔地对待自己。",
    "我会继续成长，成为更好的自己。",
    "我愿意靠近那些让我欢笑、珍惜我存在的人。",
    "今天，我可以按照自己的节奏前进。",
    "慢一点也没有关系。",
    "我可以温柔待己，也可以继续成长。",
    "我不需要马上弄清楚所有事情。",
    "我正在比从前更善待自己。",
    "如果今天有点沉重，也没关系。",
    "这一刻不能定义一整天。",
    "明天不必现在就规划好。",
    "我可以一次只做一个决定。",
    "我正在学习倾听自己的声音。",
    "今天，愿意出现就已经足够。",
    "我允许自己改变想法。",
    "我可以停下来休息，而不是落后。",
    "我能应对接下来发生的事。",
  ];

  late String dailyAffirmation;

  @override
  void initState() {
    super.initState();
    dailyAffirmation = getAffirmationForToday();
  }

  String getAffirmationForToday() {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final random = Random(seed);
    return affirmations[random.nextInt(affirmations.length)];
  }

  void _onItemTapped(int index) {
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
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);
    const activeColor = Color(0xFFFB7DA8);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1E1E2C), Color(0xFF2A2A3D)]
                : const [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage('images/prek_logo.png')),

                Text(
                  "欢迎回来 🌞",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : textColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 40,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Color(0xFF161622)
                        : softWhite.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark
                          ? Color(0xFF1E1E2C)
                          : Colors.white.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.1)
                            : Colors.pink.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    '"$dailyAffirmation"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      color: isDark ? Colors.white : textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_florist_outlined,
                      color: isDark ? Colors.white : textColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "明天会为你送上新激励",
                      style: TextStyle(
                        color: isDark ? Colors.white : textColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.local_florist_outlined,
                      color: isDark ? Colors.white : textColor,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFFC567),
                        Color(0xFFFB7DA8),
                        Color(0xFF058CD7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MoodPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "开始反思",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
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
}
