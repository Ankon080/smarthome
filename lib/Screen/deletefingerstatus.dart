import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smarthome/Screen/fingerprint.dart';
import 'enroll_finger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteFingerStatus extends StatefulWidget {
  const DeleteFingerStatus({super.key});
  @override
  State<DeleteFingerStatus> createState() => _DeleteFingerStatusState();
}

class _DeleteFingerStatusState extends State<DeleteFingerStatus> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String statusMessage = "Hold Your Finger onto the Fingerprint Sensor";
  String lottieAnimation = 'animations/scanfinger.json';

  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _checkEnrollmentStatus();
  }


  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }


  void _checkEnrollmentStatus() {
    _dbRef.child('Delete_fingerprint_status').onValue.listen((event) {
      final deletefingerprintstatus = event.snapshot.value;
      setState(() {
        if (deletefingerprintstatus == 1) {
          statusMessage = "Deleted Fingerprint Successful";
          lottieAnimation = 'animations/successFinger.json';
        } else if (deletefingerprintstatus == 2) {
          statusMessage = "Fingerprint Id was not found";
          lottieAnimation = 'animations/failedFingerprint.json';
        } else {
          statusMessage = "Loading!";
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
                    "Biometric Enroll System",
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
                      color: _isDarkMode ? Colors.grey : Colors.black,
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
