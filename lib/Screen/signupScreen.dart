import 'package:flutter/material.dart';
import 'package:smarthome/Screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signupscreen extends StatefulWidget {
  const signupscreen({super.key});

  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _UserNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  @override
  void dispose() {
    _UserNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 175,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                    child: Image.asset("assets/logo.png"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Smartify",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  "Smart Way of Living",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(174, 175, 175, 1),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 327,
                        child: TextFormField(
                          controller: _UserNameController,
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white54 : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _isDarkMode
                                ? const Color.fromRGBO(96, 96, 96, 40)
                                : Colors.grey[200],
                            hintText: "User Name",
                            hintStyle: TextStyle(
                              color: _isDarkMode ? Colors.white54 : Colors.black54, // Hint color based on mode
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid username';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 327,
                        child: TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white54 : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _isDarkMode
                                ? const Color.fromRGBO(96, 96, 96, 40)
                                : Colors.grey[200],
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: _isDarkMode ? Colors.white54 : Colors.black54,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 327,
                        child: TextFormField(
                          controller: _passwordController,
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white54 : Colors.black54, // Text color based on mode
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _isDarkMode
                                ? const Color.fromRGBO(96, 96, 96, 40)
                                : Colors.grey[200], // Fill color based on mode
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: _isDarkMode ? Colors.white54 : Colors.black54, // Hint color based on mode
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 327,
                        child: TextFormField(
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white54 : Colors.black54, // Text color based on mode
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _isDarkMode
                                ? const Color.fromRGBO(96, 96, 96, 40)
                                : Colors.grey[200], // Fill color based on mode
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              color: _isDarkMode ? Colors.white54 : Colors.black54, // Hint color based on mode
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 327,
                        height: 57,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _signup();
                            }
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87), // Button text color based on mode
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(234, 23, 99, 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already Have an account?",
                            style: TextStyle(
                              color: _isDarkMode ? Color.fromRGBO(174, 175, 175, 100) : Colors.black54, // Text color based on mode
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => loginScreen(),
                                ),
                                    (route) => false,
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: const Color.fromRGBO(234, 23, 99, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signup() async {
    String username = _UserNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signUpWithEmailandPassword(email, password, username);

      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => loginScreen()),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already registered';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak';
      } else {
        errorMessage = 'An unknown error occurred';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('An unknown error occurred');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
