import 'package:flutter/material.dart';
import 'package:googlesignin/wallpaperApp/wall.dart';
import 'crudApp/crudApp.dart';
  



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Flutter demo",
      home: new WallScreen(),
    );
  }
}
