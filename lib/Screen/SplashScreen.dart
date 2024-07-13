//import 'dart:js';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    goToLogin(context);
  }

  void goToLogin(BuildContext context){
    Future.delayed(const Duration(seconds: 2)).then((value){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context)=>const loginScreen()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
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
                ScaleAnimatedText("Smart Home",textStyle: TextStyle(
                  color: Color.fromRGBO(234, 23, 99, 10),
                  fontSize: 28,
                )),
              ]
          ),

        ],
      ),
    );
  }
}
