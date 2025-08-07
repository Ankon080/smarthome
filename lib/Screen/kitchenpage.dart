import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:smarthome/Screen/waterlevel.dart';
import '../style/ContainerStyle.dart';
import '../style/simplecontainer.dart';
import '../style/status_container.dart';
 // Import your new container widget here

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final DatabaseReference _smokeStatusRef =
  FirebaseDatabase.instance.ref().child('smoke_detection/smokestatus');
  final DatabaseReference _fireStatusRef =
  FirebaseDatabase.instance.ref().child('firestatus');
  final DatabaseReference _lightDetectionRef =
  FirebaseDatabase.instance.ref().child('light_detection');
  final DatabaseReference _fanDetectionRef =
  FirebaseDatabase.instance.ref().child('kitchen_fan');

  bool _isDarkMode = true;

  int _smokeStatus = 0; // 0 = no gas, 1 = gas leaking
  int _fireStatus = 0;  // 0 = no fire, 1 = fire detected
  bool _isLightOn = false;
  bool _isFanOn = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _listenSmokeStatus();
    _listenFireStatus();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  void _listenSmokeStatus() {
    _smokeStatusRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        var value = snapshot.value;
        if (value is int) {
          setState(() {
            _smokeStatus = value;
          });
        }
      }
    });
  }

  void _listenFireStatus() {
    _fireStatusRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        var value = snapshot.value;
        if (value is int) {
          setState(() {
            _fireStatus = value;
          });
        }
      }
    });
  }

  Future<void> _updateLightDetection(bool isOn) async {
    try {
      await _lightDetectionRef.set(isOn ? 1 : 0);
      setState(() {
        _isLightOn = isOn;
      });
    } catch (e) {
      print('Failed to update light detection: $e');
    }
  }

  Future<void> _updateFanDetection(bool isOn) async {
    try {
      await _fanDetectionRef.set(isOn ? 1 : 0);
      setState(() {
        _isFanOn = isOn;
      });
    } catch (e) {
      print('Failed to update fan detection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              // Top bar with back button and logo
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.grey,
                          size: 42,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const dashboard()),
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
                        icon: const Icon(
                          Icons.person_pin,
                          color: Colors.white,
                          size: 42,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Title
              Text(
                "Smartify",
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
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

              const SizedBox(height: 70),

              // Controls row: Light and Water Level
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Light switch container (reuse your existing Mycontainer widget)
                  Mycontainer(
                    myicon: Icons.lightbulb_outline,
                    containerText: 'Light',
                    pageName: 'kitchen',
                    isActive: _isLightOn,
                    onSwitchChanged: (bool value) {
                      _updateLightDetection(value);
                    },
                  ),
                  const SizedBox(width: 10),
                  // Water Level container (simple container, navigate on tap)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WaterLevel()),
                            (route) => false,
                      );
                    },
                    child: SimpleContainer(
                      myicon: Icons.water_drop,
                      containerText: "Water Level",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Status containers: Gas Alert and Fire Alert
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusContainer(
                    myicon: Icons.add_alert_rounded,
                    containerText: _smokeStatus == 1 ? "Gas Detected" : "No Gas Detected",
                    isActive: _smokeStatus == 1,
                    onTap: () {
                      // Optional: add action on tap
                    },
                  ),
                  const SizedBox(width: 10),
                  StatusContainer(
                    myicon: Icons.local_fire_department,
                    containerText: _fireStatus == 1 ? "Fire Detected" : "No Fire Detected",
                    isActive: _fireStatus == 1,
                    onTap: () {
                      // Optional: add action on tap
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
