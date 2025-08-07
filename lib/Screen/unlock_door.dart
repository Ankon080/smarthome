import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:smarthome/Screen/fingerprint.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences
import 'enroll_finger.dart';

class UnlockDoor extends StatefulWidget {
  const UnlockDoor({super.key});
  @override
  State<UnlockDoor> createState() => _UnlockDoorState();
}

class _UnlockDoorState extends State<UnlockDoor> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String statusMessage = "Hold Your Finger onto the Fingerprint Sensor";
  String lottieAnimation = 'animations/scanfinger.json';

  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _detectFinger();
  }


  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }


  void _detectFinger() {
    _dbRef.child('detect_finger').onValue.listen((event) {
      final detectStatus = event.snapshot.value;
      setState(() {
        if (detectStatus == 1) {
          statusMessage = "Place Your Finger on the Fingerprint Sensor";
          lottieAnimation = 'animations/scanfinger.json';
        } else if (detectStatus == 2) {
          statusMessage = "Fingerprint Enrollment Successful";
          lottieAnimation = 'animations/successFinger.json';
        } else if (detectStatus == 3) {
          statusMessage = "Fingerprint Did Not Match";
          lottieAnimation = 'animations/failedFingerprint.json';
        } else {
          statusMessage = "Hold Your Finger onto the Fingerprint Sensor";
          lottieAnimation = 'animations/scanfinger.json';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _dbRef.child('detect_finger').set(0);
                      _dbRef.child('Enroll_fingerprint').set(6);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FingerprintPage(),
                        ),
                            (route) => false,
                      ); // Navigate back
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: _isDarkMode ? Colors.white : Colors.black,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 45),
                  Text(
                    "Biometric Fingerprint System",
                    style: TextStyle(
                      fontSize: 20,
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 250),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 170,
                    width: 170,
                    child: Lottie.asset(
                      lottieAnimation,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    statusMessage,
                    style: TextStyle(
                      fontSize: 19,
                      color: _isDarkMode ? Colors.grey : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
