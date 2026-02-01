import 'package:_2025_prek/change_pw.dart';
import 'package:_2025_prek/change_name.dart';
import 'package:_2025_prek/login.dart';
import 'package:_2025_prek/change_email.dart';
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
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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

        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //logo
                  Image(image: AssetImage('images/prek_logo.png')),

                  //change name
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFFC567),
                          Color(0xFFFB7DA8),
                          Color(0xFF058CD7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeName(),
                          ),
                        );
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.person, color: Colors.white, size: 30),

                          const SizedBox(width: 20),

                          const Text(
                            "Change Name",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),

                          Spacer(),

                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //Change Email
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFFC567),
                          Color(0xFFFB7DA8),
                          Color(0xFF058CD7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeEmail(),
                          ),
                        );
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.email, color: Colors.white, size: 30),

                          const SizedBox(width: 20),

                          const Text(
                            "Change Email",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),

                          Spacer(),

                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFFC567),
                          Color(0xFFFB7DA8),
                          Color(0xFF058CD7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePW(),
                          ),
                        );
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.lock, color: Colors.white, size: 30),

                          const SizedBox(width: 20),

                          const Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),

                          Spacer(),

                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 65),

                  //logout
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.pink, width: 2.5),
                    ),

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      //save button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
