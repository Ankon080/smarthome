import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'kitchenpage.dart';

class WaterLevel extends StatefulWidget {
  const WaterLevel({super.key});

  @override
  State<WaterLevel> createState() => _WaterLevelState();
}

class _WaterLevelState extends State<WaterLevel> {
  bool _isDarkMode = true;
  double _waterLevel = 75; // Default water level percentage (initially set to 75%)
  String _motorStatus = ''; // Motor status text

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _fetchWaterLevel(); // Fetch water level from Firebase
  }

  // Load theme preference (Dark mode or Light mode)
  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  // Fetch water level from Firebase Realtime Database
  Future<void> _fetchWaterLevel() async {
    DatabaseReference waterLevelRef = FirebaseDatabase.instance.ref('Water_level'); // Reference to the Water_Level node
    waterLevelRef.onValue.listen((event) {
      final data = event.snapshot.value; // Get the value of the Water_Level field

      print("Firebase Water Level Data: $data"); // Debugging: Check what is retrieved from Firebase

      if (data != null) {
        try {
          // Check if the data is an int or double
          if (data is int) {
            setState(() {
              _waterLevel = data.toDouble(); // Convert integer to double for rendering
            });
          } else if (data is double) {
            setState(() {
              _waterLevel = data; // Directly use the double value
            });
          } else {
            print("Unexpected data type. Expected int or double, got: $data");
          }

          // Update motor status text
          if (_waterLevel <= 0) {
            _motorStatus = 'Turn motor on';
          } else if (_waterLevel >= 100) {
            _motorStatus = 'Turn motor off';
          } else {
            _motorStatus = '';
          }
        } catch (e) {
          print("Error parsing water level: $e");
        }
      }
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
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.grey,
                          size: 42,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const KitchenPage()),
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
                      ? const Color.fromRGBO(174, 175, 175, 1)
                      : const Color.fromRGBO(100, 100, 100, 1),
                ),
              ),
              const SizedBox(height: 20),
              // Updated Water Tank Widget with Jar-like Shape and markers
              CustomPaint(
                size: const Size(200, 300), // Adjusted size
                painter: JarWaterTankPainter(_waterLevel, _isDarkMode),
              ),
              const SizedBox(height: 20),
              // Water level percentage displayed at the center
              Text(
                "${_waterLevel.toInt()}%", // Show water percentage
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Show motor status
              Text(
                _motorStatus,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // Highlighted in red
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JarWaterTankPainter extends CustomPainter {
  final double waterLevel; // Water level percentage (0 to 100)
  final bool isDarkMode;

  JarWaterTankPainter(this.waterLevel, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final tankBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = isDarkMode ? Colors.white : Colors.black;

    final waterPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.6);

    // Create a rounded jar-like shape (rectangular with rounded corners)
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20)); // Rounded corners

    // Draw the tank's border
    canvas.drawRRect(rRect, tankBorderPaint);

    // Calculate the height of the water based on the percentage
    final waterHeight = (size.height - 20) * (waterLevel / 100); // 20 is for padding
    final waterRect = Rect.fromLTRB(
      10, // Padding from the left
      size.height - waterHeight - 10, // Water starts from the bottom
      size.width - 10, // Padding from the right
      size.height - 10, // Water stops at the bottom
    );

    // Draw the water inside the tank
    canvas.drawRRect(
      RRect.fromRectAndRadius(waterRect, Radius.circular(15)),
      waterPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
