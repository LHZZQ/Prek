import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});

  @override 
  Widget build(BuildContext context){
    const pink = Color(0xFFFB7DA8);
    const yellow = Color(0xFFFFC567);
    const retroBlue = Color(0xFF058CD7);
    const softWhite = Color(0xFFFFFFFF); 
    const textColor = Color(0xFF94697E); 
    const bgTop = Color(0xFFFFF1F5);
    const bgBottom = Color(0xFFFFF8EE);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar( 
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        centerTitle: true,
        leading: IconButton(icon: const
        Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
        onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("not available right now")),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: textColor),
          ),
        ],
     ),
     body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [bgTop, bgBottom],
        ),
      ),
     )
    ); 
  }
}