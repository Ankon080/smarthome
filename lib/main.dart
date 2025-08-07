import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Screen/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
      "AIzaSyBZrTCwNCpEABrw3N0xsGDsSnOHdPdcCm8",
      appId:
      "1:530215667411:android:9c67f9cc5976380276b626",
      messagingSenderId: "530215667411",
      projectId: "smarthome-3dd44",
      authDomain: 'smarthome-3dd44.firebaseapp.com',
      databaseURL: "https://smarthome-3dd44-default-rtdb.firebaseio.com",
      storageBucket: 'smarthome-3dd44.appspot.com',
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