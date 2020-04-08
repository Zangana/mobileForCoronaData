import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import './secondpage.dart' as secondPage;


void main(){
  runApp(MaterialApp(
    home: HomePage(),

  ));
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map data;
  List kpiData;
  Future getData() async {
    final response = await http.get("https://coronavirus-19-api.herokuapp.com/all");
    if (response.statusCode == 200){
     return data = json.decode(response.body);
    } else {
      debugPrint(response.body);
      throw Exception ('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "ئاماری ڤایرۆسی کۆرۆنا",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: getData(), // if you mean this method well return image url
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Container(
        color: Colors.grey,
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index){
            return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: 175,
              width: double.maxFinite,
              child: Card(
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 2.0,
                        color: Colors.black ,
                      ),
                    ),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        iconsType(returnKeyOfMap(index)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Spacer(),
                                        typeOfCases(returnKeyOfMap(index)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        caseAmount(returnKeyOfMap(index))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),        
      );
      }else if(snapshot.hasError){
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
      },
      ),
      drawer: buildDrawer(),
    );
  }

  Widget  buildDrawer(){
     return Drawer(
       child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("ئاماری راستەوخۆی ڤایرۆسی کۆرۆنا",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text("Next Page",
              style: TextStyle(fontSize: 25.0),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (BuildContext context) => new secondPage.SecondScreen()),
                );
              },
            ),
            ListTile(
              title: Text("about",
                        style: TextStyle(fontSize: 25.0),
                      ),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){Navigator.pop(context);},
            )
          ],
        ),
      );
  }

    Widget iconsType(String icon){
    return Align(
      alignment: Alignment.topRight,
      child: icon == "cases" 
          ? Icon(
              Icons.warning,
              color: Colors.yellow,
              size: 30.0,
            )   
          : icon == "deaths" 
            ? Icon(
              Icons.clear,
              color: Colors.red,
              size: 40.0,
            )
          : Icon(
            Icons.check_box,
            color: Colors.green,
            size: 40.0
          ),
      );
  }

  Widget caseAmount(String cases){

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: cases == "cases" ? "${data['cases']}" : cases == "deaths" ? "${data['deaths']}" : "${data['recovered']}" ,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget deathAmount(Map data){
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "${data['deaths']}",
                style: TextStyle(
                  color:Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget typeOfCases(String type){
    return(
      Align(
        alignment: Alignment.topRight,
        child: RichText(
          text: TextSpan(
            text: type == "cases" ? "ژمارەی توشبووان" : type == "deaths" ? "ژمارەی مردوو" : "ژمارەی چاکبوو",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      )
    );
  }

  String returnKeyOfMap(int index){
    var keys = data.keys.iterator;
    String key = "none";
    for(int i = 0; i < index; i++){
      keys.moveNext();
    }
    key = keys.current;
    return key;
  }
}