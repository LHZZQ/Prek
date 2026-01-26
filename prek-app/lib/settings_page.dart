import 'package:flutter/material.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';
import 'package:_2025_prek/profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: textColor, size: 30),
          color: Colors.white,
          onSelected: (value) {
            if (value == 'profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            } else if (value == 'history') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EntryHistoryPage(),
                ),
              );
            } else if (value == 'settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            }
          },

          itemBuilder: (context) {
            return const [
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'history', child: Text('History')),
            ];
          },
        ),
      ),
    );
  }
}
