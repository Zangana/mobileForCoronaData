import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget{
  @override 
  Widget build (BuildContext ctxt){
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "ئاماری ڤایرۆسی کۆرۆنا",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),
        ),
        leading: Icon(Icons.menu),
      ),
    );
  }
}