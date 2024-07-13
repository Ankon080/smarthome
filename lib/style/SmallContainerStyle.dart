import 'package:flutter/material.dart';

Container smallContainer(MYICON,LARGETEXT,SMALLTEXT,SMALLTEXT2){
  return Container(
    height: 150,
    width: 115,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(29),
      color: Color.fromRGBO(37,37,37, 50),
    ),

    child: Column(
      children: [
        SizedBox(height: 15),
        Center(child: Icon(MYICON,size: 38,color: Color.fromRGBO(234, 23, 99, 1),)),
        SizedBox(height: 10),
        Text(LARGETEXT,style: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        )),
        Text(SMALLTEXT,style: TextStyle(
          color: Colors.white54,
          fontSize: 15,
        )),
        Text(SMALLTEXT2,style: TextStyle(
          color: Colors.white54,
          fontSize: 15,
        )),
      ],
    ),
  );
}