import 'package:flutter/material.dart';
import 'reflection_page.dart';
import 'voice_reflection_page.dart';

class TaskSelectionPage extends StatelessWidget {
  final String selectedMood;

  const TaskSelectionPage({super.key, required this.selectedMood});

  static const textColor = Color(0xFF94697E);
  static const softWhite = Color(0xFFFFFFFF);
  static const pink = Color(0xFFFB7DA8);
  static const yellow = Color(0xFFFFC567);
  static const blue = Color(0xFF058CD7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "You are feeling $selectedMood today",
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "What would you like to do?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 40),

                _buildTaskCard(
                  context,
                  icon: Icons.edit_note_rounded,
                  iconBg: yellow.withValues(alpha: 0.3),
                  title: "Write a Reflection",
                  subtitle: "Express your thoughts in words",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ReflectionPage(selectedMood: selectedMood),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                _buildTaskCard(
                  context,
                  icon: Icons.mic_rounded,
                  iconBg: blue.withValues(alpha: 0.2),
                  title: "Voice Reflection",
                  subtitle: "Record your thoughts with audio",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VoiceReflectionPage(selectedMood: selectedMood),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                _buildTaskCard(
                  context,
                  icon: Icons.photo_library_rounded,
                  iconBg: pink.withValues(alpha: 0.2),
                  title: "Lookbook",
                  subtitle: "Visualize your journey through photos",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context, {
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
          color: softWhite.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
              child: Icon(icon, color: textColor, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: textColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
