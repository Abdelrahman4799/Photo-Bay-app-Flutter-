import 'package:flutter/material.dart';
import 'src.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//key : 13047186-101be9442f8ec640115ac8df0
int main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: firstPage(),
  ));
}

class firstPage extends StatelessWidget {
  var _catgoryNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
              ),
              Image(
                image: AssetImage("images/photobay.png"),
                width: 200.0,
                height: 200.0,
              ),
              ListTile(
                title: new TextFormField(
                  controller: _catgoryNameController,
                  decoration: new InputDecoration(
                      labelText: "enter a category ..",
                      hintText: "eg : dogs, cats, cars,... ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              new ListTile(
                title: Material(
                  color: Colors.blueAccent,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  child: new MaterialButton(
                    height: 48.0,
                    onPressed: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context){
                          print(_catgoryNameController.text);
                          return new seconedPage(catg: _catgoryNameController.text);
                        })
                      );
                    },
                    child: Text(
                      "Search",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class seconedPage extends StatefulWidget {
  String catg;
  seconedPage({this.catg});
  @override
  _seconedPageState createState() => _seconedPageState();
}

class _seconedPageState extends State<seconedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Photo Bay', style: TextStyle(color: Colors.white),),
        centerTitle: true,),

      body: FutureBuilder(
        future: getPics(widget.catg),
        builder: (context, snapShot) {
          Map data = snapShot.data;
          if (snapShot.hasError) {
            print(snapShot.error);
            return Text('Failed to get response from the server',
              style: TextStyle(color: Colors.red, fontSize: 22.0),);
          }
          else if (snapShot.hasData) {
            return Center(
                child: new ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return new Column(
                        children: <Widget>[
                          new Container(
                            child: InkWell(
                              onTap: () {},
                              child: new Image.network(
                                  '${data['hits'][index]['largeImageURL']}'),
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(5.0)),
                        ],
                      );
                    }
                )
            );
          }
          else if (!snapShot.hasData)
            {
              return new Center(
                child: CircularProgressIndicator(),
              );

            }
        },
      ),
    );
  }
}

Future<Map> getPics(String catg) async
{
  String url = 'https://pixabay.com/api/?key=$apiKey&q=$catg&image_type=photo&pretty=true';
  http.Response response = await http.get(url);

  return json.decode(response.body);
}