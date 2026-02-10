import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_2025_prek/home_page.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({super.key});
  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final supabase = Supabase.instance.client;
  final TextEditingController nameController = TextEditingController();
  String profileName = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _updateUsername();
  }

  Future<void> _loadUsername() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      final response = await supabase
          .from('Profiles')
          .select('username')
          .eq('id', user.id);

      if (response.isNotEmpty) {
        setState(() {
          profileName = response[0]['username'] as String;
          loading = false;
        });
      }
    } catch (e) {
      profileName = "error";
      debugPrint('Error loading username: $e');
      setState(() => loading = false);
    }
  }

  Future<void> _updateUsername() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final newUsername = nameController.text.trim();
    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Username cannot be empty")));
      return;
    }

    try {
      await supabase
          .from('Profiles')
          .update({'username': newUsername})
          .eq('id', user.id);
    } catch (e) {
      debugPrint('Error updating username: $e');
      setState(() => loading = false);
    }
  }

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

                  //new name
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
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your new name",
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
                      onPressed: () async {
                        await _updateUsername();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 20,
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
      ),
    );
  }
}
