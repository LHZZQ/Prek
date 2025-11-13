import 'package:flutter/material.dart';
import 'dart:math';
import 'package:_2025_prek/reflection_page.dart';
import 'package:_2025_prek/pages/entry_history_page.dart';


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
   final seed = today.year * 10000 + today.month * 100 + today.day; //picks a new one each day based on date
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: const Icon(
              Icons.menu,
              color: textColor,
              size: 30,
          ),
          color: Colors.white,
          onSelected: (value) {
            if (value == 'history') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EntryHistoryPage(),
                ),
              );
            }
            // leave profile/settings empty for now
          },

          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
              value: 'history',
              child: Text('History'),
              ),
            ];
          },
        ),
      ),
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
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: const DecorationImage(
                      image: AssetImage('images/prek-logo2.png'), //showing logo and i added rounded corners so it would reflect the app icon look
                      fit: BoxFit.cover,
                    ),
                  ),
                ),


                const SizedBox(height: 50),

                //welcome text when you open homepage
                const Text(
                  "Welcome Back 🌞", //emoji to match our style
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ReflectionPage();
                        },
                      ),
                    );
                    // reflection page not added yet, will link later
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
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
