import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_2025_prek/login.dart';

class UpdatePW extends StatefulWidget {
  const UpdatePW({super.key});
  @override
  State<UpdatePW> createState() => _UpdatePWState();
}

class _UpdatePWState extends State<UpdatePW> {
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstPasswordController = TextEditingController();
  final TextEditingController secondPasswordController =
      TextEditingController();
  bool isPasswordVisible1 = true;
  bool isPasswordVisible2 = true;
  String password = '';
  bool loading = true;
  final validator = SignUpValidator();

  @override
  void initState() {
    super.initState();

    setState(() => loading = false);
  }

  Future<String?> _updatePW() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return 'Session expired. Please request reset again.';
    }
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: firstPasswordController.text.trim()),
      );

      return null;
    } catch (e) {
      debugPrint('Error changing password: $e');
      return 'Error changing password, $e';
    }
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
                      labelText: 'New Password',
                      //errorText: 'Password entered is wrong',
                      icon: Icon(Icons.lock, color: Colors.pink[200], size: 40),
                      suffixIcon: IconButton(
                        icon: isPasswordVisible1
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.pink,
                              )
                            : const Icon(Icons.visibility, color: Colors.pink),
                        onPressed: () => setState(
                          () => isPasswordVisible1 = !isPasswordVisible1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    obscureText: isPasswordVisible1,
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
                      labelText: 'Confirm New Password',
                      //errorText: 'Password entered is wrong',
                      icon: Icon(Icons.lock, color: Colors.pink[200], size: 40),
                      suffixIcon: IconButton(
                        icon: isPasswordVisible2
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.pink,
                              )
                            : const Icon(Icons.visibility, color: Colors.pink),
                        onPressed: () => setState(
                          () => isPasswordVisible2 = !isPasswordVisible2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    obscureText: isPasswordVisible2,
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
                    onPressed: () async {
                      final checkNewPW = validator.validatePassword(
                        firstPasswordController.text.trim(),
                      );
                      final checkConfirmPW = validator.validatePassword(
                        secondPasswordController.text.trim(),
                      );

                      if (firstPasswordController.text.trim() ==
                          secondPasswordController.text.trim()) {
                        if (checkNewPW == null && checkConfirmPW == null) {
                          //check if updatePW fails
                          final updateError = await _updatePW();
                          if (updateError != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Error changing password, $updateError",
                                ),
                              ),
                            );
                          } else {
                            //update successful
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Password updated successfully!"),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          }
                        } else {
                          //one of the two new password fields doesn't follow the password requirement
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $checkNewPW")),
                          );
                        }
                      } else {
                        //the two new password fields doesn't match
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("New password doesn't match")),
                        );
                      }
                    },

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

class SignUpValidator {
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
