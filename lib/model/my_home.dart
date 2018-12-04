import 'package:flutter/material.dart';
import 'package:flutter_world_news/model/source.dart';
import 'package:flutter_world_news/model/article_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  List<Source> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("World News App"),
      ),
      body: RefreshIndicator(
          key: _refreshKey,
          child: _body(),
          onRefresh: ()=> _refresh()),
    );
  }

  // This function handles the refresh action
  Future<Null> _refresh()async{
    _refreshKey.currentState?.show();
    setState(() {
      _list.clear();
      return _body();
    });
    await Future.delayed(Duration(seconds:3));
    return null;
  }

  // This function handles the body GUI and actions
  Widget _body(){
    return Container(
        child: Center(
          child: FutureBuilder(
              future: _sources(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    "No Internet Connection... Unable to fetch Data",
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  );
                } else if (snapshot.hasData) {
                  return _getNewsList(snapshot);
                }
                return CircularProgressIndicator();
              }),
        ));
  }

  Widget _getNewsList(AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Container(
                padding: EdgeInsets.all(20.0),
                 alignment: Alignment.centerLeft,
                 child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.only(bottom: 5.0),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/new2.jpg"),
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                        ),
                        title: Text(
                          snapshot.data[index].name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold,),
                        ),
                        subtitle: Text(snapshot.data[index].description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 13.0, wordSpacing: 2.0,
                              fontWeight: FontWeight.bold,
                            )),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ArticleScreen(snapshot.data[index].id),
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 77.0),
                        alignment: Alignment.centerLeft,
                        child: Text("Category: ${snapshot.data[index].category}",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
              )
          );
        });
  }

  Future<List<Source>> _sources() async {
      String _url = "https://newsapi.org/v2/sources?apiKey=c8b63955a2fb4f48a949593eac3b938d";
      var _data = await http.get(_url);
      var _jsonData = json.decode(_data.body);
      var _result = _jsonData["sources"];

      for (var _index in _result) {
        Source _source = Source(
            _index["id"],
            _index["name"],
            _index["description"],
            _index["url"],
            _index["category"],);
        _list.add(_source);
      }
    return _list;
  }

}
