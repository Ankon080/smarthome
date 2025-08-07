import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:smarthome/style/ContainerStyle.dart';

import '../style/AutomationContainer.dart';
import '../style/simplecontainer.dart'; // Assuming SimpleContainer is here
//import '../style/automation_container.dart'; // Your AutomationContainer code file

class BedroomPage extends StatefulWidget {
  const BedroomPage({super.key});

  @override
  State<BedroomPage> createState() => _BedroomPageState();
}

class _BedroomPageState extends State<BedroomPage> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child('smoke_detection/smokestatus');
  final DatabaseReference lightDetectionRefer =
  FirebaseDatabase.instance.ref().child('bedroom_light');
  final DatabaseReference fanDetectionRefer =
  FirebaseDatabase.instance.ref().child('bedroom_fan');

  final DatabaseReference tempReference =
  FirebaseDatabase.instance.ref().child('temperature');
  final DatabaseReference humidityReference =
  FirebaseDatabase.instance.ref().child('humidity');

  bool _isLight2On = false;
  bool _isFan2On = false;
  bool _isDarkMode = true;
  String _smokeStatus = "Fetching gas status..";

  String _temperature = "Loading...";
  String _humidity = "Loading...";

  bool _isAutomationOn = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _fetchSmokeStatus();
    _fetchTemperature();
    _fetchHumidity();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  void _fetchSmokeStatus() {
    _databaseReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        try {
          var value = snapshot.value;
          if (value is int) {
            setState(() {
              _smokeStatus = value == 1
                  ? "Gas is leaking"
                  : value == 0
                  ? "Gas is not leaking"
                  : "Invalid data type";
            });
          } else {
            setState(() {
              _smokeStatus = "Invalid data type";
            });
          }
        } catch (e) {
          print('Error processing data: $e');
          setState(() {
            _smokeStatus = "Error processing data";
          });
        }
      } else {
        setState(() {
          _smokeStatus = "Fetching gas status...";
        });
      }
    }).onError((error) {
      print('Error fetching data: $error');
      setState(() {
        _smokeStatus = "Error fetching data";
      });
    });
  }

  void _fetchTemperature() {
    tempReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        final tempStr = snapshot.value.toString();
        print('Fetched temperature: $tempStr');

        setState(() {
          _temperature = tempStr;
        });

        if (_isAutomationOn) {
          double? tempDouble = double.tryParse(tempStr);
          if (tempDouble != null) {
            bool shouldTurnFanOn = tempDouble > 28;
            print('Automation is ON. Temp check: $tempDouble > 28 = $shouldTurnFanOn');
            if (shouldTurnFanOn != _isFan2On) {
              print('Toggling fan to: $shouldTurnFanOn');
              _toggleFan2(shouldTurnFanOn);
            } else {
              print('Fan state already correct, no change needed');
            }
          } else {
            print('Failed to parse temperature to double');
          }
        } else {
          print('Automation is OFF, skipping fan toggle');
        }
      } else {
        setState(() {
          _temperature = "No data";
        });
      }
    });
  }

  void _fetchHumidity() {
    humidityReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        setState(() {
          _humidity = snapshot.value.toString();
        });
      } else {
        setState(() {
          _humidity = "No data";
        });
      }
    });
  }

  Future<void> _updateLight2Detection(bool isLight2On) async {
    int status = isLight2On ? 1 : 0;
    try {
      await lightDetectionRefer.set(status);
      print('Light detection updated to $status');
    } catch (e) {
      print('Failed to update light detection: $e');
    }
  }

  Future<void> _updateFan2Detection(bool isFan2On) async {
    int status = isFan2On ? 1 : 0;
    try {
      print('Writing fan status $status to Firebase...');
      await fanDetectionRefer.set(status);
      print('Fan detection updated to $status');
    } catch (e) {
      print('Failed to update fan detection: $e');
    }
  }

  void _toggleLight2(bool isLight2On) {
    setState(() {
      _isLight2On = isLight2On;
    });
    _updateLight2Detection(isLight2On);
  }

  void _toggleFan2(bool isFan2On) {
    setState(() {
      _isFan2On = isFan2On;
    });
    _updateFan2Detection(isFan2On);
  }

  void _toggleAutomation(bool newValue) {
    setState(() {
      _isAutomationOn = newValue;
    });
    print('Automation toggled: $_isAutomationOn');
    // Optionally run temperature check immediately on toggle on
    if (_isAutomationOn) {
      double? tempDouble = double.tryParse(_temperature);
      if (tempDouble != null) {
        bool shouldTurnFanOn = tempDouble > 28;
        if (shouldTurnFanOn != _isFan2On) {
          _toggleFan2(shouldTurnFanOn);
        }
      }
    }
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
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  Mycontainer(
                    myicon: Icons.lightbulb_outline,
                    containerText: 'Light',
                    pageName: 'BedroomPage',
                    isActive: _isLight2On,
                    onSwitchChanged: (bool value) {
                      _toggleLight2(value);
                    },
                  ),

                  AutomationContainer(
                    icon: Icons.wind_power,
                    label: "Fan",
                    isAutomationOn: _isAutomationOn,
                    isManualOn: _isFan2On,
                    onAutomationChanged: (bool value) {
                      _toggleAutomation(value);
                    },
                    onManualChanged: (bool value) {
                      _toggleFan2(value);
                    },
                  ),

                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              // Single SimpleContainer showing both Temperature and Humidity
              SimpleContainer(
                myicon: Icons.thermostat_outlined,
                containerText: "Temp: $_temperature°C\nHumidity: $_humidity%",
              ),
              const SizedBox(height: 40),
              Text(
                'Gas Status: $_smokeStatus',
                style: TextStyle(
                  fontSize: 24,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
