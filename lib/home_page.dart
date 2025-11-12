import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
 final affirmations = [
   "I am super grateful for all the small joys that today brings.",
   "I am worthy of love, peace, and happiness.",
   "Each moment is a chance to start fresh.",
   "I choose to focus on what I can control.",
   "My heart is open to gratitude and kindness.",
   "I am exactly where I need to be right now.",
   "I trust the timing of my life.",
   "I strive to better myself every day.",
   "I am working towards becoming a better version of myself.",
   "I choose to give myself grace, even when faced with challenges.",
   "I will continue to grow into the best version of myself.",
   "I surround myself with people who make me laugh and appreciate my presence.",
 ];

 late String dailyAffirmation;

 @override
 void initState() {
   super.initState();
   dailyAffirmation = getAffirmationForToday();
 }

 String getAffirmationForToday() {
   final today = DateTime.now();
   final seed = today.year * 10000 + today.month * 100 + today.day;
   final random = Random(seed);
   return affirmations[random.nextInt(affirmations.length)];
 }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF1F5),
              Color(0xFFFFF8EE),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                //logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/images/prek-logo2.png',
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 50),

                //welcome text when you open homepage
                const Text(
                  "Welcome Back 🌞",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: 0.5,
                  ),
                ),

                //affirmation box
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 40,
                  ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: softWhite.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 1.5,
                ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  child: Text(
                    '"$dailyAffirmation"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      color: textColor,
                    ),
                  ),
                ),

            const SizedBox(height: 30),

            //info row (using Row to stylistically place the icon flowers on either side of the text)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_florist_outlined,
                    color: textColor, size: 18),
                SizedBox(width: 8),
                Text(
                  "Your next affirmation will appear tomorrow",
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
                SizedBox(width: 8),
                Icon(Icons.local_florist_outlined,
                    color: textColor, size: 18),
              ],
            ),

            const SizedBox(height: 50),

            //reflection button
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    colors: [pink, peach],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  onPressed: () {
                    // reflection page not added yet, will link later
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reflection feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                    child: const Text(
                      "Start Reflection",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
