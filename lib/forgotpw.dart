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
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);
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
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                //image
                Image(image: AssetImage('images/prek_logo.png')),

                //forgot password
                Text(
                  'Forgot Password',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                //new password
                Text(
                  'New Password',
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
                    decoration: InputDecoration(
                      hintText: 'Your Password',
                      labelText: 'Password',
                      //errorText: 'Password entered is wrong',
                      icon: Icon(CupertinoIcons.padlock, color: pink, size: 40),
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
                    decoration: InputDecoration(
                      hintText: 'Your Password',
                      labelText: 'Password',
                      //errorText: 'Password entered is wrong',
                      icon: Icon(CupertinoIcons.padlock, color: pink, size: 40),
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

                //done button
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                    backgroundColor: peach,
                    side: BorderSide(color: peach),
                  ),
                  child: Text('Done', style: TextStyle(fontSize: 20)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
