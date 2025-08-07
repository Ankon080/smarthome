import 'dart:convert'; // Required for JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Added for Firebase DB
import 'package:smarthome/Screen/settings_page.dart';
import 'package:smarthome/style/SmallContainerStyle.dart';
import 'package:smarthome/style/colors.dart';
import 'package:smarthome/style/drawer.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'VoicePage.dart';
import 'bedroompage.dart';
import 'entranceroom.dart';
import 'kitchenpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  String? username;
  int _selectedIndex = 0;
  String? weatherTemperature = '30';
  bool _isDarkMode = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Firebase reference to the temperature field
  final DatabaseReference temperatureRef =
  FirebaseDatabase.instance.ref().child('temperature');

  String? indoorTemperature; // To hold fetched indoor temperature

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    fetchUsername();
    fetchWeather();
    _fetchIndoorTemperature();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _saveThemePreference(_isDarkMode);
    });
  }

  Future<void> fetchUsername() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? uid = user.uid;
        String? fetchedUsername = await _firebaseAuthService.getUsername(uid);
        setState(() {
          username = fetchedUsername;
        });
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  // Fetch weather data from OpenWeatherMap API
  Future<void> fetchWeather() async {
    try {
      String apiKey = '80aac1fd3034841064b18eb31755ad6d';
      String apiUrl =
          'http://api.openweathermap.org/data/2.5/weather?q=Sylhet,BD&units=metric&appid=$apiKey';
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          weatherTemperature = data['main']['temp'].toStringAsFixed(0);
        });
      } else {
        print('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  // Fetch indoor temperature from Firebase Realtime Database
  void _fetchIndoorTemperature() {
    temperatureRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        try {
          var value = snapshot.value;
          setState(() {
            if (value is num) {
              indoorTemperature = value.toStringAsFixed(0);
            } else if (value is String) {
              indoorTemperature = value;
            } else {
              indoorTemperature = "N/A";
            }
          });
        } catch (e) {
          print('Error fetching indoor temperature: $e');
          setState(() {
            indoorTemperature = "Error";
          });
        }
      } else {
        setState(() {
          indoorTemperature = "No data";
        });
      }
    }, onError: (error) {
      print('Error fetching indoor temperature: $error');
      setState(() {
        indoorTemperature = "Error";
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => dashboard()),
              (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => VoicePage()),
              (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
              (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:
      Mydrawer(context, username: username, email: _auth.currentUser?.email),
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: Container(
                            height: 75,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isDarkMode
                                  ? const Color.fromRGBO(37, 37, 37, 50)
                                  : Colors.grey[300],
                            ),
                            child: const Icon(Icons.menu, size: 32, color: lightPink),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: GestureDetector(
                          onTap: _toggleTheme,
                          child: Container(
                            height: 80,
                            width: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isDarkMode
                                  ? const Color.fromRGBO(37, 37, 37, 50)
                                  : Colors.grey[300],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.dark_mode,
                                  size: 32, color: lightPink),
                              onPressed: _toggleTheme,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        username != null ? "Hello $username 👋" : "Hello 👋",
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 20),
                        child: smallContainer(
                          Icons.cloud,
                          indoorTemperature != null
                              ? "${indoorTemperature}°C"
                              : "Loading...",
                          "Indoor",
                          "Temperature",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: smallContainer(
                          Icons.devices,
                          "4",
                          "Connected ",
                          "Sensors ",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: smallContainer(
                          Icons.cloud,
                          "$weatherTemperature°C",
                          "Sylhet",
                          "Bangladesh",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          height: 60,
                          width: 150,
                          child: Center(
                            child: Text(
                              "Total Room-3",
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white : Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 05, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KitchenPage()),
                                    (route) => false,
                              );
                            },
                            child: Container(
                              height: 210,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(29),
                                color: _isDarkMode
                                    ? const Color.fromRGBO(37, 37, 37, 50)
                                    : Colors.grey[200],
                                image: const DecorationImage(
                                  image: AssetImage("assets/kitchen.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 150),
                                  Icon(Icons.kitchen,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.grey),
                                  Text(
                                    "Kitchen",
                                    style: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white54
                                          : Colors.white70,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BedroomPage()),
                                    (route) => false,
                              );
                            },
                            child: Container(
                              height: 210,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(29),
                                color: _isDarkMode
                                    ? const Color.fromRGBO(37, 37, 37, 50)
                                    : Colors.grey[200],
                                image: const DecorationImage(
                                  image: AssetImage("assets/bed.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 150),
                                  Icon(Icons.bed_sharp,
                                      color: _isDarkMode
                                          ? Colors.white70
                                          : Colors.white70),
                                  Text(
                                    "Bed Room",
                                    style: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white54
                                          : Colors.white70,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => enterence()),
                                    (route) => false,
                              );
                            },
                            child: Container(
                              height: 210,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(29),
                                color: _isDarkMode
                                    ? const Color.fromRGBO(37, 37, 37, 50)
                                    : Colors.grey[200],
                                image: const DecorationImage(
                                  image: AssetImage("assets/gate.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 150),
                                  Icon(Icons.door_front_door_outlined,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.white70),
                                  Text(
                                    "Entrance",
                                    style: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white54
                                          : Colors.white70,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.white70 : Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mic),
                label: 'Voice',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.pink,
            unselectedItemColor: _isDarkMode ? Colors.white54 : Colors.black54,
            backgroundColor: _isDarkMode ? Colors.black : Colors.grey[300],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
