import 'package:flutter/material.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  static const softWhite = Color(0xFFFFFFFF);
  static const textColor = Color(0xFF94697E);
  static const pink = Color(0xFFFB7DA8);
  //static const blue = Color(0xFF058CD7);
  static const yellow = Color(0xFFFFC567);

  String? selectedLabel;

  final moods = const [
    ('😊', 'Happy'),
    ('🙂', 'Good'),
    ('😐', 'Neutral'),
    ('😕', 'Confused'),
    ('😔', 'Sad'),
    ('😣', 'Overwhelmed'),
    ('😤', 'Frustrated'),
    ('😡', 'Angry'),
  ];

  @override
  Widget build(BuildContext) {
    final bgTop = Color.lerp(softWhite, pink, 0.12)!;
    final bgBottom = Color.lerp(softWhite, yellow, 0.14)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                const SizedBox(height: 18),

                Container(
                  padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: softWhite.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),

                ),
                child: Text(
                  _greeting(),
                  style: const TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ]
            )

          )
        )
      )
    );
  
  }
  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 18) return "Good afternoon";
    return "Good evening";
  }
}
