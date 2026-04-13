import 'package:_2025_prek/settings_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:_2025_prek/mood_page.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';

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
    "I am super grateful for all the small joys that today brings.",
    "I am worthy of love, peace, and happiness.",
    "Each moment is a chance to start fresh.",
    "I choose to focus on what I can control.",
    "My heart is open to gratitude and kindness.",
    "I am exactly where I need to be right now.",
    "I trust the timing of my life.",
    "I strive to better myself every day.",
    "I am working towards becoming a better version of myself.",
    "I choose to give myself grace, even when faced with challenges.",
    "I will continue to grow into the best version of myself.",
    "I surround myself with people who make me laugh and appreciate my presence.",
    "I'm allowed to move at my own pace today.",
    "Nothing is wrong with taking things slowly.",
    "I can give myself grace and still grow.",
    "I don't need to have everything figured out.",
    "I'm being kinder to myself than I was before.",
    "It's okay if today feels a little heavy.",
    "This moment doesn't define the whole day.",
    "Tomorrow doesn't need to be planned yet.",
    "I can take today one decision at a time.",
    "I'm learning how to listen to myself.",
    "Today, showing up is enough.",
    "I'm allowed to change my mind.",
    "I can pause without falling behind.",
    "I can handle what comes next.",
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
                  "Welcome Back 🌞",
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
                        ? Colors.black87
                        : softWhite.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark
                          ? Colors.black
                          : Colors.white.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.1),
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
                      "Your next affirmation will appear tomorrow",
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
                      "Start Reflection",
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
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
