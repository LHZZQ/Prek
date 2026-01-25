import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);

    const textColor = Color(0xFF94697E);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Form(
        key: _formKey,
        child: Container(
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
              child: Column(
                children: [
                  //image
                  Image(image: AssetImage('images/prek_logo.png')),

                  //create new account
                  Text(
                    'Create New Account',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  SizedBox(height: 30),

                  //email
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) => validator.validateEmail(value),
                      decoration: InputDecoration(
                        hintText: 'hello@example.com',
                        labelText: 'Email',
                        icon: Icon(
                          CupertinoIcons.envelope,
                          color: pink,
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
                      validator: (value) => validator.validatePassword(value),
                      decoration: InputDecoration(
                        hintText: 'Your Password',
                        labelText: 'Password',
                        //errorText: 'Password entered is wrong',
                        icon: Icon(
                          CupertinoIcons.padlock,
                          color: pink,
                          size: 40,
                        ),
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
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                      ),
                      obscureText: isPasswordVisible,
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
                      validator: (value) => validator.validatePassword(value),
                      decoration: InputDecoration(
                        hintText: 'Your Password',
                        labelText: 'Password',
                        //errorText: 'Password entered is wrong',
                        icon: Icon(
                          CupertinoIcons.padlock,
                          color: pink,
                          size: 40,
                        ),
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
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                      ),
                      obscureText: isPasswordVisible,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                  ),

                  SizedBox(height: 30),

                  //signup button
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: textColor,
                      backgroundColor: peach,
                      side: BorderSide(color: peach),
                    ),
                    child: Text('Sign Up', style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Success!");
                      }
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

class SignUpValidator {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple check: does it contain @?
    if (!value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 10) {
      return 'Password must have a minimum of 1 lower case letter [a-z], a minimum of 1 upper case letter [A-Z], a minimum of 1 numeric character [0-9], a minimum of 1 special character: ~`!@#%^&*()-_+={}[]|:"<>,./?, and must be at least 10 characters';
    }
    return null;
  }
}
