//import 'package:_2025_prek/forgotpw.dart';
import 'package:_2025_prek/forgotpw.dart';
import 'package:_2025_prek/signup.dart';
import 'package:flutter/material.dart';
import 'package:_2025_prek/home_page.dart';
//import 'package:_2025_prek/mood_page.dart';
import 'package:_2025_prek/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? authError;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
  }

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => authError = '请输入邮箱和密码。');
      return;
    }
    setState(() {
      isLoading = true;
      authError = null;
    });

    try {
      //Calling login function from auth_services
      await login(emailController.text, passwordController.text);
      // Navigate to homepage if successful
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() => authError = e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const textColorOriginal = Color(0xFF94697E);
    final Color textColor = isDark ? Colors.white : textColorOriginal;
    return Scaffold(
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
                        Icons.mail_outline,
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
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                ),

                SizedBox(height: 20),

                //password
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: '密码',
                      //errorText: 'Password entered is wrong',
                      icon: Icon(Icons.lock, color: Colors.pink[200], size: 40),
                      suffixIcon: IconButton(
                        icon: isPasswordVisible
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.pink[200],
                              )
                            : Icon(Icons.visibility, color: Colors.pink[200]),
                        onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                ),

                if (authError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      authError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                SizedBox(height: 10),

                //Forgot Password
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.only(left: 5),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "忘记密码",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPW()),
                    );
                  },
                ),

                SizedBox(height: 10),

                //login button
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
                      minimumSize: const Size(400, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: isLoading ? null : _login,

                    child: const Text(
                      "登录",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

                ///sign in with google button
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(40),
                //     gradient: const LinearGradient(
                //       begin: Alignment.centerLeft,
                //       end: Alignment.centerRight,
                //       colors: [
                //         Color(0xFFFFC567),
                //         Color(0xFFFB7DA8),
                //         Color(0xFF058CD7),
                //       ],
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.pinkAccent.withValues(alpha: 0.25),
                //         blurRadius: 15,
                //         offset: const Offset(0, 6),
                //       ),
                //     ],
                //   ),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.transparent,
                //       shadowColor: Colors.transparent,
                //       minimumSize: const Size(400, 50),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //     ),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const HomePage(),
                //         ),
                //       );
                //     },

                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(
                //           'images/google_logo.png',
                //           height: 24,
                //           width: 24,
                //         ),

                //         const SizedBox(width: 20),

                //         const Text(
                //           "Sign in with google",
                //           style: TextStyle(
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //             letterSpacing: 0.3,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),

                //Dont have an account
                Text(
                  "还没有账号？",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                //Sign up
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "注册",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
