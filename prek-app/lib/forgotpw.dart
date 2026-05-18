import 'package:_2025_prek/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPW extends StatefulWidget {
  const ForgotPW({super.key});
  @override
  State<ForgotPW> createState() => _ForgotPWState();
}

class _ForgotPWState extends State<ForgotPW> {
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
  }

  Future<String?> _updatePW() async {
    try {
      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
        redirectTo: 'https://d28sobbmdqyycw.cloudfront.net/#/update-password',
      );

      return null;
    } catch (e) {
      debugPrint('Error sending reset password link: $e');
      setState(() => loading = false);
      return '发送重置密码链接失败';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const textColorOriginal = Color(0xFF94697E);
    final Color textColor = isDark ? Colors.white : textColorOriginal;
    final Color bgTop = isDark
        ? const Color(0xFF1E1E2C)
        : const Color(0xFFFFF1F5);
    return Scaffold(
      backgroundColor: bgTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1E1E2C), Color(0xFF2A2A3D)]
                : const [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //image
                Image(image: AssetImage('images/prek_logo.png')),

                //email
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: '邮箱',
                      icon: Icon(
                        CupertinoIcons.envelope,
                        color: Colors.pink[200],
                        size: 40,
                      ),

                      suffixIcon: emailController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => emailController.clear(),
                            ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                ),

                SizedBox(height: 30),

                //done button
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
                      minimumSize: const Size(420, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("邮箱确认"),
                            content: const Text('如果该邮箱已注册，密码重置链接会发送到这个邮箱。'),

                            actions: <Widget>[
                              TextButton(
                                child: const Text('好的'),
                                onPressed: () async {
                                  await _updatePW();
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },

                    child: const Text(
                      "完成",
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
    );
  }
}
