import 'package:flutter/material.dart';
import 'package:flutter_world_news/model/my_home.dart';

/*
      Programmer: Aanu Pelumi Olakunle
      Date Modified: 04/12/2018
*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "World News App",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}