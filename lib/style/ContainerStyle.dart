import 'package:flutter/material.dart';
import 'package:smarthome/style/colors.dart';

class Mycontainer extends StatefulWidget {
  final IconData myicon;
  final String containerText;

  const Mycontainer({
    Key? key,
    required this.myicon,
    required this.containerText,
  }) : super(key: key);

  @override
  _MycontainerState createState() => _MycontainerState();
}

class _MycontainerState extends State<Mycontainer> {
  bool _lights = false; // State variable to track the state of the switch

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 177,
      height: 208,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: _lights ? lightPink : Color.fromRGBO(237, 237, 237, 1),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(widget.myicon, size: 59),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 80, 0),
            child: Text(
              widget.containerText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 35),
          SwitchListTile(
            title: Text(
              _lights ? 'ON' : 'OFF',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            value: _lights,
            onChanged: (bool value) {
              setState(() {
                _lights = value; // Update the state of _lights
              });
              // Handle onChanged here if needed
            },
            activeColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            activeTrackColor: lightPink, // Replace with your desired active track color
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
