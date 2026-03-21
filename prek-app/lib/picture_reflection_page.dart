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
  }

