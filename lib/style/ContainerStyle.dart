import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart'; // Assuming you have your custom colors defined here

class Mycontainer extends StatefulWidget {
  final IconData myicon;
  final String containerText;
  final String pageName; // New parameter to differentiate between pages
  final Function()? onTap;
  final bool isActive;
  final ValueChanged<bool>? onSwitchChanged; // New callback for switch changes

  const Mycontainer({
    Key? key,
    required this.myicon,
    required this.containerText,
    required this.pageName, // Required pageName to identify different pages
    this.onTap,
    this.isActive = false, // Default to false
    this.onSwitchChanged, // Initialize the new callback
  }) : super(key: key);

  @override
  _MycontainerState createState() => _MycontainerState();
}

class _MycontainerState extends State<Mycontainer> {
  late bool _lights;

  @override
  void initState() {
    super.initState();
    _lights = widget.isActive;
    _loadButtonState(); // Load the button state when the widget initializes
  }

  Future<void> _saveButtonState(bool state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setBool('button_state_${widget.pageName}_${widget.containerText}', state);
    print('Saved button state for ${widget.containerText} on ${widget.pageName}: $state, success: $success');
  }

  Future<void> _loadButtonState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lights = prefs.getBool('button_state_${widget.pageName}_${widget.containerText}') ?? widget.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 177,
        height: 208,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: _lights ? lightPink : Color.fromRGBO(237, 237, 237, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(widget.myicon, size: 59),
                  SizedBox(height: 10),
                  Text(
                    widget.containerText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SwitchListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                _lights ? 'ON' : 'OFF',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              value: _lights,
              onChanged: (bool value) async {
                setState(() {
                  _lights = value;
                });

                // Update SharedPreferences
                await _saveButtonState(_lights);

                if (widget.onSwitchChanged != null) {
                  widget.onSwitchChanged!(value);
                }


                print('Switch changed for ${widget.containerText} on ${widget.pageName}, new value: $value');
              },
              activeColor: Colors.white,
              inactiveTrackColor: Colors.grey,
              activeTrackColor: lightPink,
              inactiveThumbColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
