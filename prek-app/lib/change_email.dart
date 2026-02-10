import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_2025_prek/home_page.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});
  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  String profileEmail = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadEmail();
    _updateEmail();
  }

  Future<void> _loadEmail() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      final response = await supabase
          .from('Profiles')
          .select('email')
          .eq('id', user.id);

      if (response.isNotEmpty) {
        setState(() {
          profileEmail = response[0]['email'] as String;
          loading = false;
        });
      }
    } catch (e) {
      profileEmail = "error";
      debugPrint('Error loading email: $e');
      setState(() => loading = false);
    }
  }

  Future<void> _updateEmail() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final newEmail = emailController.text.trim();
    if (newEmail.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Email cannot be empty")));
      return;
    }

    try {
      await supabase
          .from('Profiles')
          .update({'email': newEmail})
          .eq('id', user.id);

      await supabase.auth.updateUser(UserAttributes(email: newEmail));
    } catch (e) {
      debugPrint('Error updating email: $e');
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

                  //new email
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
                      controller: emailController,

                      decoration: const InputDecoration(
                        hintText: "Enter your new email",
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
                        await _updateEmail();
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
