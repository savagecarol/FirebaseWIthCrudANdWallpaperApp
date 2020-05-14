import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

 class MyHomePage extends StatefulWidget
 {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


 String myText;
 StreamSubscription subscription;
  final DocumentReference documentReference=Firestore.instance.document("myData/dummy");
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =new GoogleSignIn();
  
  Future<FirebaseUser> _handleSignIn() async {
   
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    print("signed in " + user.displayName);
    return user;
  }
  
    void _signOut() {
      _googleSignIn.signOut();
      print("User Signed out");
    }
    
    void _add() {
      Map<String,String> data=<String,String>{
        "name":"Kartikeya sharma",
        "desc":"Flutter developer"
      };
      documentReference.setData(data).whenComplete((){
        print("Document Added");
      }).catchError((e)=>print(e));
        }
  
      void _update() {
         Map<String,String> data=<String,String>{
        "name":"Kartikeya sharma updated",
        "desc":"Flutter developer updated"
      };
      documentReference.updateData(data).whenComplete((){
        print("Document updated");
      }).catchError((e)=>print(e));
    }
    
      void _delete() 
      {
  
        documentReference.delete().whenComplete(() {
        print("deleted sucessfully");
        setState(() {});
        }).catchError((e){print(e);});
    }
  
    
      void _fetch() {
        documentReference.get().then((datasnapshot){
          if (datasnapshot.exists)
          setState(() {
            {
            myText=datasnapshot.data['desc'];
            }        
          });
        });
    }
  
  @override
  void initState()
  {
    super.initState();
    subscription =documentReference.snapshots().listen((datasnapshot){
          if (datasnapshot.exists)
          setState(() {
            {
            myText=datasnapshot.data['desc'];
            }        
          });
        });
  }
    @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }
    
  
  
     @override 
     Widget build(BuildContext context)
     {
       return new Scaffold(
         appBar: new AppBar(
           title:Text("Fire Base Demo"),
         ),
         body: Padding(
           padding: const EdgeInsets.all(20),
           child: new Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: <Widget>[
               new RaisedButton(onPressed: () => _handleSignIn().then((FirebaseUser user)=> print(user)).catchError((e) => print(e)),
               child:Text("Sign In"),color:Colors.green),
               Padding(padding: const EdgeInsets.all(10),),
                new RaisedButton(onPressed: _signOut,
               child:Text("Sign Out"),color:Colors.red),
                  Padding(padding: const EdgeInsets.all(10),),
                
                new RaisedButton(onPressed: _add,
               child:Text("Add"),color:Colors.cyan),
                  Padding(padding: const EdgeInsets.all(10),),
  
                new RaisedButton(onPressed: _update,
               child:Text("update"),color:Colors.teal),
                  Padding(padding: const EdgeInsets.all(10),),
                new RaisedButton(onPressed: _delete,
               child:Text("delete"),color:Colors.pinkAccent),
                  Padding(padding: const EdgeInsets.all(10),),
                new RaisedButton(onPressed: _fetch,
               child:Text("fetch"),color:Colors.yellow),
                Padding(padding: const EdgeInsets.all(10),),
                myText==null?Container():new Text(myText,style:new TextStyle(fontSize: 20))
  
             ],
           ),
  
         ),
       );
     }
}
 