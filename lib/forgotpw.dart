import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPW extends StatefulWidget {
  const ForgotPW({super.key});
  @override
  State<ForgotPW> createState() => _ForgotPWState();
}

class _ForgotPWState extends State<ForgotPW> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(backgroundColor: Colors.yellow[50]),
      body: Center(
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
                  color: Color(0xFFFF66C4),
                ),
              ),

              //new password
              Text(
                'New Password',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 20, color: Color(0xFFFF66C4)),
              ),

              SizedBox(height: 30),

              //email
              SizedBox(
                width: 400,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'hello@example.com',
                    labelText: 'Email',
                    icon: Icon(
                      CupertinoIcons.envelope,
                      color: Color(0xFFFFDE59),
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
                child: TextField(
                  onChanged: (value) => setState(() => password = value),
                  onSubmitted: (value) => setState(() => password = value),
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Your Password',
                    labelText: 'Password',
                    //errorText: 'Password entered is wrong',
                    icon: Icon(
                      CupertinoIcons.padlock,
                      color: Color(0xFFFFDE59),
                      size: 40,
                    ),
                    suffixIcon: IconButton(
                      icon: isPasswordVisible
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
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
                child: TextField(
                  onChanged: (value) => setState(() => password = value),
                  onSubmitted: (value) => setState(() => password = value),
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Your Password',
                    labelText: 'Password',
                    //errorText: 'Password entered is wrong',
                    icon: Icon(
                      CupertinoIcons.padlock,
                      color: Color(0xFFFFDE59),
                      size: 40,
                    ),
                    suffixIcon: IconButton(
                      icon: isPasswordVisible
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
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
                  foregroundColor: Colors.amber[50],
                  backgroundColor: Color(0xFFFF66C4),
                  side: BorderSide(color: Color(0xFFFF66C4)),
                ),
                child: Text('Done', style: TextStyle(fontSize: 20)),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
