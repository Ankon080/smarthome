import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Screen/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
      "AIzaSyBZrTCwNCpEABrw3N0xsGDsSnOHdPdcCm8", // paste your api key here
      appId:
      "1:530215667411:android:9c67f9cc5976380276b626", //paste your app id here
      messagingSenderId: "530215667411", //paste your messagingSenderId here
      projectId: "smarthome-3dd44", //paste your project id here
    ),
  );
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
