import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/auth/login.dart';
import 'package:pbl_project_app/loading.dart';
import 'package:pbl_project_app/user/student/profile.dart';
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
  final FirebaseStorage photos= FirebaseStorage(storageBucket: 'gs://pbl-app-87c6e.appspot.com');
  String imageurl;

  //functions
  Future<void> getimageurl()async{
    try{
      final StorageReference downloader = photos.ref().child(widget.userid);
      String url=await downloader.getDownloadURL();
      setState(() {
        imageurl=url;
      });
    }
    catch(e)
    {
      Alert(
          context: context,
          title: 'Error getting User Image',
          desc: e.message,
          buttons: []).show();
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
    }
  }
  Future<void> getdetails() async{
    try{
      await getimageurl();
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
    return SafeArea(
          child: Scaffold(
        drawer: Drawer(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.cyan,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(imageurl),
                        radius: 50,
                      ),
                      Center(
                        child: Text(
                          userdetails['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 3,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(imageurl: imageurl,userid: widget.userid,userdetails: userdetails,),));
                  },
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  child: Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                RaisedButton(
                  onPressed: () {
                    Alert(
                      context: context,
                      style: AlertStyle(
                        backgroundColor: Colors.cyan,
                      ),
                      title: "Logout",
                      desc: "Are you sure you want to logout?",
                      buttons: [],
                      content: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ButtonTheme(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              buttonColor: Colors.black,
                              child: RaisedButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'No',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ButtonTheme(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              buttonColor: Colors.black,
                              child: RaisedButton(
                                onPressed: ()async{
                                  Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Signing Out...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                                  await FirebaseAuth.instance.signOut();
                                  if(userbox.length!=0)
                                  {
                                    await userbox.deleteAt(0);
                                  }
                                  await Future.delayed(Duration(seconds: 2));
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login(),), (route) => false);
                                },
                                child: Text(
                                  'Yes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ).show();
                  },
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  child: Text(
                    'Sign Out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black
          ),
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
      ),
    );
    }
  }
}