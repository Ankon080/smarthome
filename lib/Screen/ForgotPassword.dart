import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/Screen/login_screen.dart';
import 'package:smarthome/style/colors.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  void _sendPasswordResetEmail(BuildContext context) async {
    String email = _emailController.text.trim();

    final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegExp.hasMatch(email)) {
      _showErrorDialog(context, "Invalid Email", "Please enter a valid email address.");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: lightPink,
            title: Text(
              "Password Reset Email Sent",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              "A password reset email has been sent to $email. Please check your email and click on the link to reset your password. Once you are finished, go to the login page to login with the new password.",
              style: TextStyle(color: Colors.white70),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK", style: TextStyle(color: Colors.white70)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage;

        switch (e.code) {
          case 'user-not-found':
            errorMessage = "Email is not registered.";
            break;
          case 'invalid-email':
            errorMessage = "Invalid email format.";
            break;
          default:
            errorMessage = "Failed to send password reset email. Please try again later.";
        }

        _showErrorDialog(context, "Error", errorMessage);
      } else {
        _showErrorDialog(context, "Error", "An unexpected error occurred. Please try again later.");
      }

      print("Error sending password reset email: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightPink,
          title: Text(
            title,
            style: TextStyle(color: Colors.white70),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Center(
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
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Smart Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Smart Way of Living",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(174, 175, 175, 1),
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
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(96, 96, 96, 40),
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Colors.white54,
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
                  child: ElevatedButton(
                    onPressed: () {
                      _sendPasswordResetEmail(context);
                    },
                    child: Text(
                      "Send Password Reset Email",
                      style: TextStyle(color: Colors.white70),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink, // Replace with your desired color
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Finished resetting your password?",
                        style: TextStyle(
                          color: Color.fromRGBO(174, 175, 175, 100),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => loginScreen()),
                                (route) => false,
                          );
                        },
                        child: Text(
                          "Login",
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
          ),
        ),
      ),
    );
  }
}
