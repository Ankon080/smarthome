import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Screen/ForgotPassword.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'signupScreen.dart';
import 'package:smarthome/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();

  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  @override
  void dispose() {
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
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        child: SizedBox(
                            height: 190,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                              child: Image.asset("assets/logo.png"),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "Smartify",
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Smart Way of Living",
                      style: TextStyle(
                        fontSize: 20,
                        color: _isDarkMode ? Color.fromRGBO(174, 175, 175, 1) : Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 327,
                      height: 57,
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _isDarkMode
                              ? Color.fromRGBO(96, 96, 96, 40)
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
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 327,
                      height: 57,
                      child: TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _isDarkMode
                              ? Color.fromRGBO(96, 96, 96, 40)
                              : Colors.grey[200],
                          hintText: "Password",
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
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 327,
                      height: 57,
                      child: ElevatedButton(
                        onPressed: () => _signin(),
                        child: Text(
                          "Login",
                          style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: lightPink,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            )),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Have an account?",
                            style: TextStyle(
                              color: _isDarkMode ? Color.fromRGBO(174, 175, 175, 100) : Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => signupscreen()),
                                    (route) => false,
                              );
                            },
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                color: Color.fromRGBO(234, 23, 99, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgotten Your Password??",
                            style: TextStyle(
                              color: _isDarkMode ? Color.fromRGBO(174, 175, 175, 100) : Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                    (route) => false,
                              );
                            },
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                color: Color.fromRGBO(234, 23, 99, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signInWithEmailandPassword(email, password);

      if (user != null) {
        print("Login Successful");
        _emailController.clear();
        _passwordController.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => dashboard()),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address format.';
      } else {
        errorMessage = 'An unknown error occurred: ${e.message}';
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('An unknown error occurred');
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
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
}
