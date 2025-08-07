import 'package:flutter/material.dart';

class StatusContainer extends StatelessWidget {
  final IconData myicon;
  final String containerText;
  final bool isActive; // true if alert is active (fire/gas detected)
  final Function()? onTap;

  const StatusContainer({
    Key? key,
    required this.myicon,
    required this.containerText,
    required this.isActive,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = isActive
        ? Color.fromRGBO(234, 23, 99, 1) // alert color (your current color)
        : Colors.green; // no alert color

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 177,
        height: 208,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: bgColor,
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(myicon, size: 59, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    containerText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
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
