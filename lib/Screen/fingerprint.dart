import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:smarthome/Screen/deletefinger.dart';
import 'package:smarthome/Screen/unlock_door.dart';
import 'package:smarthome/style/ContainerStyle.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import '../style/simplecontainer.dart';
import 'enroll_finger.dart';
import 'signupScreen.dart';
import 'fingerprint.dart';

class FingerprintPage extends StatefulWidget {
  const FingerprintPage({super.key});

  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
}

class _FingerprintPageState extends State<FingerprintPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Firebase ref initialization
  bool _isDarkMode = true; // Default dark mode

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
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
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: _isDarkMode ? Colors.white : Colors.black,
                          size: 42,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => dashboard()),
                                (route) => false,
                          );
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 130,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Image.asset("assets/logo.png"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: IconButton(
                        icon: Icon(
                          Icons.person_pin,
                          color: _isDarkMode ? Colors.white : Colors.black,
                          size: 42,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                  ),
                ],
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
                  color: _isDarkMode
                      ? Color.fromRGBO(174, 175, 175, 1)
                      : Color.fromRGBO(100, 100, 100, 1),
                ),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const enrollfinger()),
                              (route) => false,
                        );
                      },
                      child: SimpleContainer(
                        containerText: "Enroll FingerPrint",
                        myicon: Icons.fingerprint,
                      )),
                  GestureDetector(
                      onTap: () async {
                        await _dbRef.child("Enroll_fingerprint").set(2);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const UnlockDoor()),
                              (route) => false,
                        );
                      },
                      child: SimpleContainer(
                          containerText: "Unlock Door",
                          myicon: Icons.lock_open_rounded)),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                      onTap: () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => deletefinger()),
                              (route) => false,
                        );
                      },
                      child: SimpleContainer(
                        containerText: "Delete Fingerprint",
                        myicon: Icons.fingerprint,
                      )),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
