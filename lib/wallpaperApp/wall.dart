import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'fullscreen.dart';
 
const String testDevice='';
class WallScreen extends StatefulWidget
{
  @override
  _WallScreenState createState() => new _WallScreenState();
}

class _WallScreenState extends State<WallScreen>
{








  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> WallpapersList;

  final CollectionReference collectionReference=Firestore.instance.collection("wallpapers");

@override
void initState() {
    // TODO: implement initState
    super.initState();
    subscription=collectionReference.snapshots().listen((datasnapshot){
      setState(() {
        WallpapersList=datasnapshot.documents;
      });
    });
  }

@override
void dispose()
{
  subscription?.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: new AppBar(title:Text('kalify')),
      body:WallpapersList !=null?
      new StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0), 
          crossAxisCount: 4,
          itemCount: WallpapersList.length,
          itemBuilder:(context,i){
            String imgPath=WallpapersList[i].data['url'];
            return new Material(
              elevation: 8.0,
              borderRadius: new BorderRadius.all(Radius.circular(8))
              ,child: new InkWell(
                onTap:()=> Navigator.push(context,new MaterialPageRoute(builder: (context)=> new FullScreenImagePage(imgPath))),
                child:new Hero(
                  tag:imgPath,
                  child:new FadeInImage(
                    image:new NetworkImage(imgPath),
                    fit:BoxFit.cover,
                    placeholder:new NetworkImage("https://i.pinimg.com/originals/d2/30/d3/d230d317147c7911971b59e46a57b621.png")

                  ),


                ),
              ),
            );
          } ,
          staggeredTileBuilder: (i)=>new StaggeredTile.count(2,i.isEven?2:3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,   
      ):new Center(
        child: new CircularProgressIndicator(),
      )
    );
  }
}
