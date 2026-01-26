import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    const topBarColor = Color(0xFFFFF1F5);

    return Scaffold(
      backgroundColor: topBarColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: topBarColor,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),
      ),
    );
  }
}
