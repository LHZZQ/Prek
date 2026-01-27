import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});

  @override 
  Widget build(BuildContext context){
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);
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
                const SnackBar(content: Text("Action not available")),
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