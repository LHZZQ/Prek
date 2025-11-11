import 'package:_2025_prek/forgotpw.dart';
import 'package:_2025_prek/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    const pink = Color(0xFFFFC7E0);
    const peach = Color(0xFFFFE4B5);
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(backgroundColor: Colors.yellow[50]),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
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
                    color: Color(0xFFFF66C4),
                  ),
                ),

                //sign in to continue
                Text(
                  'Sign in to continue',
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
                        Icons.mail_outline,
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
                        Icons.lock,
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

                //Forgot Password
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: Colors.black87,
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
                    foregroundColor: Colors.amber[50],
                    backgroundColor: Color(0xFFFF66C4),
                    side: BorderSide(color: Color(0xFFFF66C4)),
                  ),
                  child: Text('Login', style: TextStyle(fontSize: 20)),
                  onPressed: () {},
                ),

                SizedBox(height: 10),

                //sign in with google button
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber[50],
                    backgroundColor: Color.fromARGB(255, 243, 134, 201),

                    side: BorderSide(color: Color.fromARGB(255, 243, 134, 201)),
                  ),

                  icon: Image(
                    image: AssetImage('images/google_logo.png'),
                    height: 24,
                  ),

                  label: Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 20),
                  ),

                  onPressed: () {},
                ),

                SizedBox(height: 20),

                //Dont have an account
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                //Sign up
                TextButton(
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.black87,
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
