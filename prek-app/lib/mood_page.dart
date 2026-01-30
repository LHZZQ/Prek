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
                const Text(
                  "How are you feeling\ntoday?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 22),

                Expanded(
                  child: Center(
                    child: Wrap(
                      spacing: 22,
                      runSpacing: 22,
                      alignment: WrapAlignment.center,
                      children: moods.map((m) {
                        //final emoji = m.$1;
                        final label = m.$2;
                        final isSelected = selectedLabel == label;

                        return GestureDetector(
                          onTap: () => setState(() => selectedLabel = label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: softWhite.withValues(
                                alpha: isSelected ? 0.95 : 0.78),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isSelected
                                  ? pink.withValues(alpha: 0.6)
                                  : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.07),
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),

                          ),
                          
                        );
                      
                      }).toList(),
                    )
                  )
                )
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
