import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});

  @override 
  Widget build(BuildContext context){
    const bgTop = Color(0xFFFFF6FB);
    const bgBottom = Color(0xFFFFF1E8);
    const textPrimary = Color(0xFF6D4C5B);
    
    return const Scaffold(
      body: Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}