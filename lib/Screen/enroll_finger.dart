import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smarthome/Screen/ForgotPassword.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:smarthome/Screen/enrollfingertwo.dart';
import 'package:smarthome/Screen/entranceroom.dart';
import 'package:smarthome/Screen/fingerprint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'signupScreen.dart';
import 'package:smarthome/style/colors.dart';

class enrollfinger extends StatefulWidget {
  const enrollfinger({super.key});

  @override
  State<enrollfinger> createState() => _enrollfingerState();
}

class _enrollfingerState extends State<enrollfinger> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

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
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void enrollFingerprint() async {
    try {
      final idText = _idController.text;
      final id = int.tryParse(idText);

       if (id != null && id > 0 && id <= 127) {
        await _dbRef.child("CurrentID").set(id);
        await _dbRef.child("Enroll_fingerprint").set(1);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EnrollFingerTwo()),
              (route) => false,
        );
      } else if (id == null || id <= 0 || id > 127) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter a valid integer ID"),
          ),
        );
      }
    } catch (error) {
      print('Error updating fingerprint enrollment: $error');
    }
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => FingerprintPage()),
                              (route) => false,
                        );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: _isDarkMode ? Colors.white : Colors.black,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 40),
                    Text(
                      "Biometric Enrollment system!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
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
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "Smart Home",
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
                    SizedBox(
                      height: 50,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 327,
                      height: 57,
                      child: TextFormField(
                        controller: _idController,
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _isDarkMode ? Color.fromRGBO(96, 96, 96, 40) : Color.fromRGBO(200, 200, 200, 0.4),
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
                        onPressed: enrollFingerprint,
                        child: Text(
                          "Enroll Fingerprint",
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightPink,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
