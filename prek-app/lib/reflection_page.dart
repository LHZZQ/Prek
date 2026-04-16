import 'package:_2025_prek/home_page.dart';
import 'package:_2025_prek/services/gratitude_service.dart';
import 'package:flutter/material.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';
import 'package:_2025_prek/settings_page.dart';

class ReflectionPage extends StatefulWidget {
  final String selectedMood;
  const ReflectionPage({super.key, required this.selectedMood});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final _controller = TextEditingController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EntryHistoryPage()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarBg = isDark ? const Color(0xFF2A2A3D) : Colors.white;
    final currentTextColor = isDark ? Colors.white : textColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Reflection 🌸",
          style: TextStyle(color: currentTextColor, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: currentTextColor),
      ),
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
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "Take a moment to reflect on something you're grateful for today 💭",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: currentTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pinkAccent.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _controller,
                              maxLines: 9,
                              style: TextStyle(color: currentTextColor),
                              decoration: InputDecoration(
                                hintText: "Write your reflection here...",
                                hintStyle: TextStyle(color: currentTextColor.withOpacity(0.5)),
                                contentPadding: const EdgeInsets.all(20),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            height: 62,
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
                                  color: Colors.pinkAccent.withOpacity(0.25),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () async {
                                final text = _controller.text.trim();
                                if (text.isEmpty) return;
                                try {
                                  await saveGratitudeEntry(
                                    text: text,
                                    mood: widget.selectedMood,
                                  );
                                  if (!mounted) return;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                    (route) => false,
                                  );
                                  _controller.clear();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error saving reflection: $e"),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Save Reflection",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBarBg,
        selectedItemColor: const Color(0xFFFB7DA8),
        unselectedItemColor: isDark ? Colors.white70 : Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}
