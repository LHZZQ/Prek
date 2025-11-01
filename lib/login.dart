import 'package:flutter/cupertino.dart';
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
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 60),
            ),

            //image
            Image(image: AssetImage('images/image1.png')),

            SizedBox(height: 30),

            //login
            Text(
              'Login',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 100, 62, 165),
              ),
            ),

            //sign in to continue
            Text(
              'Sign in to continue',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 100, 62, 165),
              ),
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
                    color: const Color.fromARGB(255, 100, 62, 165),
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
                  errorText: 'Password entered is wrong',
                  icon: Icon(
                    CupertinoIcons.padlock,
                    color: const Color.fromARGB(255, 100, 62, 165),
                    size: 40,
                  ),
                  suffixIcon: IconButton(
                    icon: isPasswordVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
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

            SizedBox(height: 40),

            //login button
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber[50],
                backgroundColor: const Color.fromARGB(255, 100, 62, 165),
                side: BorderSide(
                  color: const Color.fromARGB(255, 100, 62, 165),
                ),
              ),
              child: Text('Login', style: TextStyle(fontSize: 20)),
              onPressed: () {},
            ),

            SizedBox(height: 10),

            //sign in with google button
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber[50],
                backgroundColor: const Color.fromARGB(255, 181, 153, 230),

                side: BorderSide(
                  color: const Color.fromARGB(255, 181, 153, 230),
                ),
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
                color: const Color.fromARGB(255, 100, 62, 165),
                fontWeight: FontWeight.bold,
              ),
            ),

            //Sign up
            TextButton(
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: const Color.fromARGB(255, 92, 48, 169),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
