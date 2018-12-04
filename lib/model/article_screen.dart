import 'package:flutter/material.dart';
import 'package:flutter_world_news/model/source.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatefulWidget {
  String id;


  ArticleScreen(this.id);

  @override
  _ArticleScreenState createState() => _ArticleScreenState(id);
}

class _ArticleScreenState extends State<ArticleScreen> {
  String id;
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  List<Articles> _list = [];


  _ArticleScreenState(this.id);

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

  Future<Null> _refresh()async{
    _refreshKey.currentState?.show();
    setState(() {
      _list.clear();
      return _body();
    });
    await Future.delayed(Duration(seconds:3));
    return null;
  }

  Widget _body(){
    return Container(
        child: Center(
          child: FutureBuilder(
              future: _articles(id),
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
                        leading: Container(
                          width: 100.0,
                          height: 60.0,
                          color: Colors.grey,
                          child:(snapshot.data[index].urlToImage) != null ? Image.network(snapshot.data[index].urlToImage):Text(""),
                        ),
                        title: Text(
                          snapshot.data[index].title,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold,),
                        ),
                        subtitle: Text(snapshot.data[index].description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 13.0, wordSpacing: 2.0,
                              fontWeight: FontWeight.bold,
                            )),
                        onTap: () => _launchURL(snapshot.data[index].url),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 116.0),
                        alignment: Alignment.centerLeft,
                        child: Text("Published At: ${snapshot.data[index].publishedAt}",
                            style: TextStyle(
                              fontSize: 13.0, color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    ],
                  )
              )
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<Articles>> _articles(String id) async {
      String _url = "https://newsapi.org/v2/top-headlines?sources=$id&apiKey=c8b63955a2fb4f48a949593eac3b938d";
      var _data = await http.get(_url);
      var _jsonData = json.decode(_data.body);
      var _result = _jsonData["articles"];

      for (var _index in _result) {
        var _source = _index["source"];
        InnerSource _innerSource = InnerSource(_source["id"], _source["name"]);
        Articles _article = Articles(
            _innerSource,
            _index["title"],
            _index["description"],
            _index["url"],
            _index["urlToImage"],
            _index["publishedAt"],);
        _list.add(_article);
      }
    return _list;
  }
}
