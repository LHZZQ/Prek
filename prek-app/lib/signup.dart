import 'package:_2025_prek/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstPasswordController = TextEditingController();
  final TextEditingController secondPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  String password = '';
  final validator = SignUpValidator();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
  }

  Future<void> signUp() async {
    final supabase = Supabase.instance.client;

    try {
      final res = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: firstPasswordController.text.trim(),
      );

      final user = res.user;

      if (user == null) {
        throw Exception('Signup failed');
      }

      //Create profiles row
      await supabase.from('Profiles').insert({
        'id': user.id,
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error')));
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
      body: Form(
        key: _formKey,
        child: Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //image
                  Image(image: AssetImage('images/prek_logo.png')),

                  //username
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        icon: Icon(
                          Icons.person,
                          color: Colors.pink[200],
                          size: 40,
                        ),

                        suffixIcon: usernameController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => usernameController.clear(),
                              ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),

                  SizedBox(height: 20),

                  //email
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) => validator.validateEmail(value),
                      decoration: InputDecoration(
                        labelText: 'Email',
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

                  SizedBox(height: 20),

                  //password
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      onChanged: (value) => setState(() => password = value),
                      onFieldSubmitted: (value) =>
                          setState(() => password = value),
                      controller: firstPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validator.validatePassword(value),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorMaxLines: 10,
                        icon: Icon(
                          Icons.lock,
                          color: Colors.pink[200],
                          size: 40,
                        ),
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
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                      ),
                      obscureText: !isPasswordVisible,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                  ),

                  SizedBox(height: 20),

                  //password
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      onChanged: (value) => setState(() => password = value),
                      onFieldSubmitted: (value) =>
                          setState(() => password = value),
                      controller: secondPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validator.validatePassword(value),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorMaxLines: 10,
                        icon: Icon(
                          Icons.lock,
                          color: Colors.pink[200],
                          size: 40,
                        ),
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
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                      ),
                      obscureText: !isPasswordVisible,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                  ),

                  SizedBox(height: 30),

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
                        minimumSize: const Size(420, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (firstPasswordController.text.trim() ==
                            secondPasswordController.text.trim()) {
                          if (_formKey.currentState!.validate()) {
                            signUp();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("New password doesn't match"),
                            ),
                          );
                        }
                      },

                      child: const Text(
                        "Sign Up",
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

class SignUpValidator {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    if (!email.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[~`!@#%^&*()-_+={}[]|:"<>,./?]).+$',
    );
    if (value.length < 10 || !regex.hasMatch(value)) {
      return 'Password must have a minimum of 1 lower case letter [a-z], a minimum of 1 upper case letter [A-Z], a minimum of 1 numeric character [0-9], a minimum of 1 special character: ~`!@#%^&*()-_+={}[]|:"<>,./?, and must be at least 10 characters';
    }
    return null;
  }
}
