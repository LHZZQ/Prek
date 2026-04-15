import 'package:_2025_prek/home_page.dart';
import 'package:_2025_prek/services/gratitude_service.dart';
import 'package:flutter/material.dart';

class ReflectionPage extends StatefulWidget {
  final String selectedMood;
  const ReflectionPage({super.key, required this.selectedMood});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final _controller = TextEditingController(); //text controller for inputs

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                            "Take a moment to reflect on something you're grateful for today 💭", //header text
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : textColor,
                              fontSize: 18,
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
                                  color: Colors.pinkAccent.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _controller,
                              maxLines: 9, //enough space for a short reflection
                              decoration: const InputDecoration(
                                hintText: "Write your reflection here...",
                                contentPadding: EdgeInsets.all(20),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          Container(
                            width: double.infinity,
                            height: 62,
                            //gradient wrapper for button
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFFC567), // yellow
                                  Color(0xFFFB7DA8), // pink
                                  Color(0xFF058CD7), // blue
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pinkAccent.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),

                            child: ElevatedButton(
                              //save button
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

                                  _controller.clear(); //clears input
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Error saving reflection: $e",
                                      ),
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
    );
  }
}
