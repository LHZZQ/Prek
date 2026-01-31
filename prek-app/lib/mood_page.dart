import 'package:flutter/material.dart';
import 'package:_2025_prek/reflection_page.dart';



class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {

  static const softWhite = Color(0xFFFFFFFF);
  static const textColor = Color(0xFF94697E);
  static const pink = Color(0xFFFB7DA8);
  static const blue = Color(0xFF058CD7);
  static const yellow = Color(0xFFFFC567);


  String? selectedLabel;

  final moods = const [
  (Icons.sentiment_very_satisfied_rounded, 'Happy'),
  (Icons.sentiment_satisfied_rounded, 'Good'),
  (Icons.sentiment_neutral_rounded, 'Neutral'),
  (Icons.psychology_alt_rounded, 'Confused'),
  (Icons.sentiment_dissatisfied_rounded, 'Sad'),
  (Icons.warning_amber_rounded, 'Overwhelmed'),
  (Icons.whatshot_rounded, 'Frustrated'),
  (Icons.mood_bad_rounded, 'Angry'),
];



  @override

  Widget build(BuildContext context) {

    final bgTop = Color.lerp(softWhite, pink, 0.12)!;
    final bgBottom = Color.lerp(softWhite, yellow, 0.14)!;

    return Scaffold(
      backgroundColor: bgTop,
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
                    fontSize: 33,
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

                        final icon = m.$1;
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

                            child: Column(

                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(

                                  radius: 40,
                                  backgroundColor: _moodBg(label),
                                  child: Icon(

                                    icon,
                                    size: 38,
                                    color: textColor,

                                  ),


                                ),
                                const SizedBox(height: 8),

                                Text(

                                  label,
                                  style: TextStyle(
                                  color: textColor,
                                  fontWeight: isSelected

                                    ? FontWeight.w900

                                    : FontWeight.w700,

                                  ),


                                ),


                              ],


                            ),

                          ),
                          
                        );
                    
                    
                      }).toList(),


                    ),


                  ),


                ),


                const SizedBox(height: 14),
                SizedBox(

                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(

                    onPressed: selectedLabel == null

                      ? null
                      : () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(

                            builder: (_) => ReflectionPage(
                              selectedMood: selectedLabel!,

                            ),

                          ),


                        );                     

                      },

                      style: ElevatedButton.styleFrom(

                        backgroundColor: pink,
                        disabledBackgroundColor:
                        pink.withValues(alpha: 0.25),
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(999),

                        ),
                        elevation: 0,

                      ),

                      child: const Text(

                        "Next",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,

                        ),

                      ),


                  ),

                ),
                const SizedBox(height: 18),

              ],

            ),


          ),

        ),


      ),

    );

  
  }

  String _greeting() {

    final hour = DateTime.now().hour;

    if (hour < 12) return "Good morning";
    if (hour < 18) return "Good afternoon";
    return "Good evening";

  }




  Color _moodBg(String label) {

    switch (label) {

      case "Happy":
      case "Good":

      return Color.lerp(softWhite, yellow, 0.55)!;

      case "Neutral":
      case "Confused":

      return Color.lerp(softWhite, blue, 0.40)!;

      default:

      return Color.lerp(softWhite, pink, 0.45)!;

    }

  }

}





