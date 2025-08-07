import 'package:flutter/material.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences for theme toggling

class VoicePage extends StatefulWidget {
  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = "Press and hold to speak";
  String _status = "";

  // Firebase reference
  final DatabaseReference lightDetectionRef = FirebaseDatabase.instance.ref().child('light_detection');
  final DatabaseReference lightDetectionRef2 = FirebaseDatabase.instance.ref().child('kitchen_fan');
  final DatabaseReference lightDetectionRef3 = FirebaseDatabase.instance.ref().child('bedroom_light');
  final DatabaseReference lightDetectionRef4 = FirebaseDatabase.instance.ref().child('bedroom_fan');
  final DatabaseReference lightDetectionRef5 = FirebaseDatabase.instance.ref().child('kitchen_fan');


  bool _isDarkMode = true; // Track theme

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadThemePreference(); // Load theme preference
  }

  /// Initialize Speech Recognition
  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onError: (error) {
        setState(() {
          _status = 'Error: ${error.errorMsg}';
        });
        print('Speech recognition error: ${error.errorMsg}');
      },
      onStatus: (status) {
        setState(() {
          _status = 'Status: $status';
        });
        print('Speech status: $status');
      },
    );
    setState(() {
      _speechEnabled = available;
    });
    print('Speech recognition initialized: $_speechEnabled');
  }


  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true; // Default to dark mode
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

  /// Start listening for speech
  void _startListening() async {
    if (_speechEnabled) {
      print("Attempting to start listening");
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
          print("Recognized words: ${result.recognizedWords}");

          // Check for specific commands
          if (_lastWords.toLowerCase().contains('turn on kitchen light')) {
            _updateLightStatus(true);
          } else if (_lastWords.toLowerCase().contains('turn off kitchen light')) {
            _updateLightStatus(false);
          }
          else if (_lastWords.toLowerCase().contains('turn on kitchen fan')) {
            _updateFanStatus(true);
          }
          else if (_lastWords.toLowerCase().contains('turn off kitchen fan')) {
            _updateFanStatus(false);
          }
          else if (_lastWords.toLowerCase().contains('turn on bedroom light')) {
            _updateBedroomLightStatus(true);
          }
          else if (_lastWords.toLowerCase().contains('turn off bedroom light')) {
            _updateBedroomLightStatus(false);
          }
          else if (_lastWords.toLowerCase().contains('turn on bedroom fan')) {
            _updateBedroomFanStatus(true);
          }
          else if (_lastWords.toLowerCase().contains('turn off bedroom fan')) {
            _updateBedroomFanStatus(false);
          }
         else if (_lastWords.toLowerCase().contains('turn off all light')) {
            _updateLightStatus(false);
            _updateBedroomLightStatus(false);

          }
          else if (_lastWords.toLowerCase().contains('turn on all light')) {
            _updateLightStatus(true);
            _updateBedroomLightStatus(true);

          }


        },
        listenFor: Duration(seconds: 60),
        pauseFor: Duration(seconds: 5),
        localeId: 'en_US',
        partialResults: true,
      );
      setState(() {
        _isListening = true;
      });
      print("Listening started");
    } else {
      print("Speech recognition not enabled");
    }
  }


  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
      print("Listening stopped");
    }
  }


  Future<void> _updateLightStatus(bool isLightOn) async {
    int status = isLightOn ? 1 : 0;
    try {
      await lightDetectionRef.set(status);
      print('Light detection updated to $status');
    } catch (e) {
      print('Failed to update light detection: $e');
    }
  }

  Future<void> _updateFanStatus(bool isLightOn) async {
    int status = isLightOn ? 1 : 0;
    try {
      await lightDetectionRef2.set(status);
      print('Kithchen Light updated to $status');
    } catch (e) {
      print('Failed to update light detection: $e');
    }
  }

  Future<void> _updateBedroomLightStatus(bool isLightOn) async {
    int status = isLightOn ? 1 : 0;
    try {
      await lightDetectionRef3.set(status);
      print('Light detection updated to $status');
    } catch (e) {
      print('Failed to update light detection: $e');
    }
  }

  Future<void> _updateBedroomFanStatus(bool isLightOn) async {
    int status = isLightOn ? 1 : 0;
    try {
      await lightDetectionRef4.set(status);
      print('Light detection updated to $status');
    } catch (e) {
      print('Failed to update light detection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.black : Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const dashboard()),
                  (route) => false,
            );
          },
        ),
        title: Text(
          'Voice Control',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Icon(
                Icons.mic,
                color: _isDarkMode ? Colors.white : Colors.black,
                size: 100,
              ),
            ),
            Text(
              _lastWords,
              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 20),
            ),
            Text(
              _status,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onLongPress: _startListening,
              onLongPressUp: _stopListening,
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
