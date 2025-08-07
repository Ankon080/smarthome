import 'package:flutter/material.dart';

class SimpleContainer extends StatelessWidget {
  final IconData myicon;
  final String containerText;
  final Function()? onTap;

  const SimpleContainer({
    Key? key,
    required this.myicon,
    required this.containerText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 177,
        height: 208,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color:  Color.fromRGBO(234, 23, 99, 1),
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
                  Icon(myicon, size: 59),
                  SizedBox(height: 10),
                  Text(
                    containerText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
