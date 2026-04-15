import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_2025_prek/login.dart';

class ChangePW extends StatefulWidget {
  const ChangePW({super.key});
  @override
  State<ChangePW> createState() => _ChangePWState();
}

class _ChangePWState extends State<ChangePW> {
  final supabase = Supabase.instance.client;
  final TextEditingController currentPWController = TextEditingController();
  final TextEditingController newPWController = TextEditingController();
  final TextEditingController confirmPWController = TextEditingController();
  bool isPasswordVisible1 = true;
  bool isPasswordVisible2 = true;
  bool isPasswordVisible3 = true;
  bool loading = true;
  final validator = SignUpValidator();

  @override
  void initState() {
    super.initState();
    _checkPW();
    _updatePW();
  }

  Future<String?> _checkPW() async {
    final user = supabase.auth.currentUser;
    if (user == null) return 'User not logged in';

    try {
      await supabase.auth.signInWithPassword(
        email: user.email,
        password: currentPWController.text.trim(),
      );

      return null;
    } catch (e) {
      debugPrint('Wrong current password: $e');
      setState(() => loading = false);
      return 'Current password is wrong';
    }
  }

  Future<String?> _updatePW() async {
    final user = supabase.auth.currentUser;
    if (user == null) return 'User not logged in';

    try {
      await supabase.auth.updateUser(
        UserAttributes(password: newPWController.text.trim()),
      );
      return null;
    } catch (e) {
      debugPrint('Error changing password: $e');
      setState(() => loading = false);
      return 'Error changing password';
    }
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    const topBarColor = Color(0xFFFFF1F5);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: topBarColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        foregroundColor: textColor,
      ),
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //logo
                  Image(image: AssetImage('images/prek_logo.png')),

                  //current password
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: currentPWController,
                      decoration: InputDecoration(
                        hintText: "Current password",
                        contentPadding: const EdgeInsets.all(20),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: isPasswordVisible1
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Color(0xFFFB7DA8),
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Color(0xFFFB7DA8),
                                ),
                          onPressed: () => setState(
                            () => isPasswordVisible1 = !isPasswordVisible1,
                          ),
                        ),
                      ),
                      obscureText: isPasswordVisible1,
                    ),
                  ),

                  SizedBox(height: 20),

                  //new password
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: newPWController,
                      decoration: InputDecoration(
                        hintText: "New password",
                        contentPadding: const EdgeInsets.all(20),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: isPasswordVisible2
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Color(0xFFFB7DA8),
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Color(0xFFFB7DA8),
                                ),
                          onPressed: () => setState(
                            () => isPasswordVisible2 = !isPasswordVisible2,
                          ),
                        ),
                      ),
                      obscureText: isPasswordVisible2,
                    ),
                  ),

                  SizedBox(height: 20),

                  //confirm password
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: confirmPWController,
                      decoration: InputDecoration(
                        hintText: "Confirm new password",
                        contentPadding: const EdgeInsets.all(20),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: isPasswordVisible3
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Color(0xFFFB7DA8),
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Color(0xFFFB7DA8),
                                ),
                          onPressed: () => setState(
                            () => isPasswordVisible3 = !isPasswordVisible3,
                          ),
                        ),
                      ),
                      obscureText: isPasswordVisible3,
                    ),
                  ),

                  SizedBox(height: 50),

                  //save button
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
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        final checkNewPW = validator.validatePassword(
                          newPWController.text.trim(),
                        );
                        final checkConfirmPW = validator.validatePassword(
                          confirmPWController.text.trim(),
                        );

                        //check if checkPW fails
                        final checkError = await _checkPW();
                        if (checkError == null) {
                          if (newPWController.text.trim() ==
                              confirmPWController.text.trim()) {
                            if (checkNewPW == null && checkConfirmPW == null) {
                              //check if updatePW fails
                              final updateError = await _updatePW();
                              if (updateError != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error changing password"),
                                  ),
                                );
                              } else {
                                //update successful
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Password updated successfully!",
                                    ),
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
                              SnackBar(
                                content: Text("New password doesn't match"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Current password is wrong"),
                            ),
                          );
                        }
                      },

                      child: const Text(
                        "Save",
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
