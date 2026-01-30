import 'package:_2025_prek/services/gratitude_service.dart';
import 'package:flutter/material.dart';


class ReflectionPage extends StatefulWidget { 
  final String selectedMood;
  const ReflectionPage({
  super.key, 
  required this.selectedMood,});
 
  @override 
  State<ReflectionPage> createState() => _ReflectionPageState(); 
} 
 
class _ReflectionPageState extends State<ReflectionPage> { 
  final _controller = TextEditingController(); //text controller for inputs
 
  @override 
  Widget build(BuildContext context) {
    //colors 
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);
    const textColor = Color(0xFF94697E);

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Reflection 🌸", //title
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: textColor),
      ),

      body: Container(
        // spacing issue
        padding: const EdgeInsets.only(left: 20, right: 20, top: 90),

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // background gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Take a moment to reflect on something you're grateful for today 💭", //header text
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            Container(
              decoration: BoxDecoration(
                //input box
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                maxLines: 6, //enough space for a short reflection
                decoration: const InputDecoration(
                  hintText: "Write your reflection here...",
                  contentPadding: EdgeInsets.all(20),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              //gradient wrapper for button
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  colors: [pink, peach],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),

              child: ElevatedButton(
                //save button
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),

                onPressed: () async {
                  final text = _controller.text.trim();

                  if (text.isEmpty) return;

                  try {
                    await saveGratitudeEntry(text);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "🌸 Reflection saved (will link to history later)!",
                        ),
                        backgroundColor: pink.withValues(alpha: 0.9),
                      ),
                    );

                    _controller.clear(); //clears input
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error saving reflection: $e"),
                      backgroundColor: Colors.redAccent,
                      )
                    );
                  }
                }, 

                child: const Text(
                  "Save Reflection",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
