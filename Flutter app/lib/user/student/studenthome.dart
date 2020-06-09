import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/auth/login.dart';
import 'package:pbl_project_app/loading.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'practicalsub.dart';
import 'status.dart';
import 'theorysub.dart';

class StudentHome extends StatefulWidget {
  final String userid;
  StudentHome({this.userid});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<StudentHome> {
  //variables
  final userbox =Hive.box('currentuser');
  Map userdetails;
  int index=1;
  List pages = [TheorySubjects(),Status(),PracticalSubjects()];

  //functions
  Future<void> getdetails() async{
    try{
      DocumentSnapshot data = await Firestore.instance.collection('Students').document(widget.userid).get(); 
      setState(() {
        userdetails=data.data;
      });
    }
    catch(e)
    {
      Alert(
          context: context,
          title: 'Database Error at UserHome',
          desc: 'Please try loggin in again',
          buttons: []).show();
          if(userbox.length!=0)
          {
            userbox.deleteAt(0);
          }
        await FirebaseAuth.instance.signOut();
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }
  }

  @override
  void initState() {
    getdetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(userdetails==null)
    {
      return Loading();
    }
    else
    {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Student Home',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.black,
          ),
        ),
      ),
      body: pages[index],
          bottomNavigationBar: CurvedNavigationBar(
            animationCurve: Curves.linearToEaseOut,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            backgroundColor: Colors.white,
            index: 1,
            items: <Widget>[
              Icon(
                Icons.book,
                color: Colors.blue,
                size: 40,
              ),
              Icon(
                Icons.home,
                color: Colors.blue,
                size: 40,
              ),
              Icon(
                Icons.laptop_chromebook,
                color: Colors.blue,
                size: 40,
              ),
            ],
            buttonBackgroundColor: Colors.black,
            height: 50,
            color: Colors.black,
          ),
    );
    }
  }
}