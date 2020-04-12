import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:coronadatamobile/connectiontoapi.dart';

/**
 * @author: Rawaz Zangana
 * @date 13/4/2020
 * This class has cards wigets that have information about the countries. 
 */
final String urlOfApi = "https://coronavirus-19-api.herokuapp.com/countries";

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreen createState() => _SecondScreen();  

}

  
class _SecondScreen extends State<SecondScreen>{
  List data;
   var items = List<dynamic>();
  TextEditingController editingController = TextEditingController();

  Future getData() async{
    ConnectionsApi connUrl = new ConnectionsApi();
    connUrl.setUrl = urlOfApi;
    final response = await http.get(connUrl.getUrl);
    if(response.statusCode == 200){
      data = json.decode(response.body);
      items.addAll(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initStat(){
    super.initState();
    getData();
    setState(() {
      const time = const Duration(minutes: 2);
      new Timer.periodic(time, (Timer t) => setState((){}));
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "ئاماری ڤایرۆسی کۆرۆنا",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasData){

            return Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField( // text filed of the search. 
                      onChanged: (value){
                        filterSearchResults(value); // the method to call. 
                      },
                      controller: editingController, // a controller to call which is a Texteditor.
                      decoration: InputDecoration( 
                        labelText: "تکایە وڵات بە ئینگلیزی داخڵ بکە",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index){
                        return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 2.0,
                                    color: Colors.black,
                                  ), 
                                ),
                                color: Colors.black87,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ExpansionTile(
                                  title: Text("${items[index]['country']}",
                                          style:TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white,
                                          ),
                                  ),
                                  
                                  children: <Widget>[
                                    RichText(
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                        
                                        children: [
                                          TextSpan(text: "ژمارەی توشبووان: " + addComma(items[index]['cases']) + "\t"),
                                          
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Icon(Icons.warning,
                                                color: Colors.yellow,
                                                size: 27.0,
                                              ),
                                            ),
                                          ),  
                                          
                                          TextSpan(text: "\nژمارەی مردووان: "+ addComma(items[index]['deaths']) + "\t\t"),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Icon(Icons.close,
                                                color: Colors.red,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                          TextSpan(text: "\nژمارەی چاکبوو: " + addComma(items[index]['recovered'])+ "\t\t"),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Icon(Icons.check,
                                                color: Colors.green,
                                                size: 30.0,
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                      
                                    ),                                  
                                  ],
                                  
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if(snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
  /**
   * This method will return a list of the searched for.
   */
  void filterSearchResults(String query){ 
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(data);
    List<dynamic> dummyListData = List<dynamic>();
    if(query.isNotEmpty){
      dummySearchList.forEach((item){
         if(item.toString().toLowerCase().contains(query.toLowerCase())){
           dummyListData.add(item);
         }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else{
      setState(() {
        items.clear();
        items.addAll(data);
      });
    }
  }

  String addComma(int number){ // adding the comma for numbers
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    String result = number.toString().replaceAllMapped(reg, mathFunc);
    return result;
  }  
}