import 'package:flutter/material.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  //static const softWhite = Color(0xFFFFFFFF);
  //static const textColor = Color(0xFF94697E);
  //static const pink = Color(0xFFFB7DA8);
  //static const blue = Color(0xFF058CD7);
  //static const yellow = Color(0xFFFFC567);

  String? selectedLabel;

  final moods = const [
    ('😊', 'Happy'),
    ('🙂', 'Good'),
    ('😐', 'Neutral'),
    ('😕', 'Confused'),
    ('😔', 'Sad'),
    ('😣', 'Overwhelmed'),
    ('😤', 'Frustrated'),
    ('😡', 'Angry'),
  ];
}
