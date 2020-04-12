import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: ()=> Navigator.pop(context, false),),
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            "دەربارە",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),
          ),
        ),
        body: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.black),
            child: RichText(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              text: TextSpan(
                children: [
                  TextSpan(text: "ئەم بەرنامەیە ئۆپن سۆرسە و داتاکانی لە "),
                  TextSpan(text: "https://github.com/javieraviles/covidAPI "),
                  TextSpan(text: "وەرگیراوە."),
                  
                  TextSpan(text: "\n\n\n copyright @Rawaz Zangana"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}