import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _checkUser();
  }


  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true; // Default to dark mode if not set
    });
  }

  void _checkUser() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      await Firebase.initializeApp();
      User? user = FirebaseAuth.instance.currentUser;


      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const dashboard()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const loginScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      print('Error checking user: $e');
      // Handle error if needed
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const loginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 150,
              child: Lottie.asset(
                'animations/1.json',
              ),
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              ScaleAnimatedText(
                "Smartify",
                textStyle: TextStyle(
                  color: _isDarkMode ? Color.fromRGBO(234, 23, 99, 10) : Colors.pink,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
