import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/auth/login.dart';
import 'package:pbl_project_app/loading.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:pbl_project_app/user/teacher/defaulters.dart';
import 'package:pbl_project_app/user/teacher/particularstudent.dart';
import 'package:pbl_project_app/user/teacher/takattendance.dart';
import 'package:pbl_project_app/user/teacher/tprofile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class TeacherHome extends StatefulWidget {
  final String userid;
  TeacherHome({this.userid});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<TeacherHome> {
  //variables
  final userbox =Hive.box('currentuser');
  Map userdetails;
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
      DocumentSnapshot data = await Firestore.instance.collection('Teachers').document(widget.userid).get(); 
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TProfile(imageurl: imageurl,userid: widget.userid,userdetails: userdetails,),));
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
            'Teacher Home',
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.black,
            ),
          ),
        ),
        body: Builder(builder: (context) => 
        SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Background(),
                Center(
                  child: Text(
                    'Actions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RaisedButton(
                        color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TakeAttendance(),));
                    },
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    child: Text(
                      'Take Attendance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  RaisedButton(
                        color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Defaulter(),));
                      },
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    child: Text(
                      'Show Defaulters\' List',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  RaisedButton(
                        color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ParticularStudent(),));
                      },
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    child: Text(
                      'Data of Particular Student',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
                Divider(
                      height: 5.0,
                      thickness: 2.0,
                      color: Colors.blueAccent,
                      indent: 30.0,
                      endIndent: 30.0,
                    ),
                    SizedBox(height: 20,),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
  }
}