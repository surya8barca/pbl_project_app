import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/Hive/userdata.dart';
import 'package:pbl_project_app/auth/login.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../pageloading.dart';

class Status extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Status> {
  //variables
  String userid;
  final userbox= Hive.box('currentuser');
  Map userdetails;
  double theoryattendance;
  double practicalattendance;
  double totalattendance;
  Color attendance=Colors.green;
  String alert='';

  //functions
  Future<void> getuserid() async{
    if(userbox.length!=0)
    { Userinfo data=userbox.getAt(0) as Userinfo;
      setState(() {
        userid=data.userid;
      });
    }
    else
    {
      FirebaseUser currentuser=await FirebaseAuth.instance.currentUser();
      setState(() {
        userid=currentuser.uid;
      });
    }
  }

  Future<void> getattendance()async{
    try{
      final CollectionReference practicaldata= Firestore.instance.collection('Practical_Subjects_$userid');
      final CollectionReference theorydata= Firestore.instance.collection('Theory_Subjects_$userid');
      QuerySnapshot practicalsubjects=await practicaldata.getDocuments();
      QuerySnapshot theorysubjects=await theorydata.getDocuments();
      double sum1=0.00;
      double sum2=0.00;

      for(int i=0;i<practicalsubjects.documents.length;i++)
      {
        sum1=sum1+practicalsubjects.documents[i].data['Subject_Attendance'];
      }
      for(int i=0;i<theorysubjects.documents.length;i++)
      {
        sum2=sum2+theorysubjects.documents[i].data['Subject_Attendance'];
      }
      setState(() {
        practicalattendance=sum1;
        theoryattendance=sum2;
      });

    }
    catch(e)
    {
      print(e.message);
    }
  }
  Future<void> getcolor()async{
    if(userdetails['total_attendance']<75.00)
    {
      setState(() {
        alert='Attendance less than required';
        attendance=Colors.red;
      });
    }
  }

  Future<void> getdetails() async{
    await getuserid();
    await getattendance();
    try{
      DocumentSnapshot data = await Firestore.instance.collection('Students').document(userid).get();
      setState(() {
        userdetails=data.data;
      });
    
    await getcolor();
    }
    catch(e)
    {
      Alert(
          context: context,
          title: 'Database Error',
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
      return PageLoading();
    }
    else
    {
      return Scaffold(
      body: Builder(builder: (context) => 
      SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Background(),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Attendance Status',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        ),
                    ),
                    SizedBox(
                height: 15,
              ),
              Text(
                'Theory Attendance: ${theoryattendance.toStringAsPrecision(3)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                'Practical Attendance: ${practicalattendance.toStringAsPrecision(3)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: Text(
                  'Overall Attendance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: attendance,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  '${userdetails['total_attendance'].toStringAsPrecision(3)} %',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: attendance,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(child: Text(alert)),
              SizedBox(height: 10),
              Divider(
                      height: 5.0,
                      thickness: 2.0,
                      color: Colors.blueAccent,
                      indent: 30.0,
                      endIndent: 30.0,
                    ),
              SizedBox(height: 30,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
    }
  }
}

