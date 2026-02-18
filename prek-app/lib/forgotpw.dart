import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPW extends StatefulWidget {
  const ForgotPW({super.key});
  @override
  State<ForgotPW> createState() => _ForgotPWState();
}

class _ForgotPWState extends State<ForgotPW> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstPasswordController = TextEditingController();
  final TextEditingController secondPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  String password = '';

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              children: [
                //image
                Image(image: AssetImage('images/prek_logo.png')),

                //email
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'hello@example.com',
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
                    decoration: InputDecoration(
                      hintText: 'Your Password',
                      labelText: 'Password',
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
                    decoration: InputDecoration(
                      hintText: 'Your Password',
                      labelText: 'Password',
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
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    obscureText: isPasswordVisible,
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
                    onPressed: () {},

                    child: const Text(
                      "Done",
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
