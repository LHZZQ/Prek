import 'package:_2025_prek/forgotpw.dart';
import 'package:_2025_prek/signup.dart';
import 'package:flutter/material.dart';
import 'package:_2025_prek/home_page.dart';
//import 'package:_2025_prek/services/auth_service.dart';

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

  /*Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => authError = 'Please enter email and password.');
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
  */

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0
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
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //image
                  Image(image: AssetImage('images/prek_logo.png')),

                  //login
                  Text(
                    'Login',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  //sign in to continue
                  Text(
                    'Sign in to continue',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 20, color: textColor),
                  ),

                  SizedBox(height: 30),

                  //email
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'hello@example.com',

                        labelText: 'Email',
                        icon: Icon(Icons.mail_outline, color: pink, size: 40),

                        suffixIcon: emailController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => emailController.clear(),
                              ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: textColor),
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
                        hintText: 'Your Password',
                        labelText: 'Password',
                        //errorText: 'Password entered is wrong',
                        icon: Icon(Icons.lock, color: pink, size: 40),
                        suffixIcon: IconButton(
                          icon: isPasswordVisible
                              ? Icon(Icons.visibility_off, color: pink)
                              : Icon(Icons.visibility, color: pink),
                          onPressed: () => setState(
                            () => isPasswordVisible = !isPasswordVisible,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: softWhite),
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

                  //Forgot Password
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPW(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  //login button
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: textColor,
                      backgroundColor: peach,
                      side: BorderSide(color: peach),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: textColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Login', style: TextStyle(fontSize: 18)),
                  ),

                  SizedBox(height: 10),

                  //sign in with google button
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: textColor,
                      backgroundColor: peach,

                      side: BorderSide(color: peach),
                    ),

                    icon: Image(
                      image: AssetImage('images/google_logo.png'),
                      height: 24,
                    ),

                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 18),
                    ),

                    onPressed: () {},
                  ),

                  SizedBox(height: 20),

                  //Dont have an account
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  //Sign up
                  TextButton(
                    child: Text(
                      "Sign up",
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
      ),
    );
  }
}
