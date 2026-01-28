import 'package:flutter/material.dart';

class ChangePW extends StatefulWidget {
  const ChangePW({super.key});
  @override
  State<ChangePW> createState() => _ChangePWState();
}

class _ChangePWState extends State<ChangePW> {
  final TextEditingController currentPWController = TextEditingController();
  final TextEditingController newPWController = TextEditingController();
  final TextEditingController confirmPWController = TextEditingController();

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

                  //current password
                  Container(
                    decoration: BoxDecoration(
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
                      controller: currentPWController,

                      decoration: const InputDecoration(
                        hintText: "Current password",
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //new password
                  Container(
                    decoration: BoxDecoration(
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
                      controller: newPWController,

                      decoration: const InputDecoration(
                        hintText: "New password",
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //confirm password
                  Container(
                    decoration: BoxDecoration(
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
                      controller: confirmPWController,

                      decoration: const InputDecoration(
                        hintText: "Confirm new password ",
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 50),

                  //save button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 199, 224, 1),
                          Color.fromRGBO(255, 228, 181, 1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),

                    child: ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
