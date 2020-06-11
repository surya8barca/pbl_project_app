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
    List theory=userdetails['Theory_Subjects'];
    List pracs=userdetails['Practical_Subjects'];
    double totalTheory=0.00;
    double totalPracs=0.00;
    for(int i=0;i<theory.length;i++)
    {
      totalTheory=totalTheory+theory[i]['subject_attendance'];
    }
    setState(() {
      theoryattendance=totalTheory/theory.length;
    });
    for(int i=0;i<pracs.length;i++)
    {
      totalPracs=totalPracs+theory[i]['subject_attendance'];
    }
    setState(() {
      practicalattendance=totalPracs/theory.length;
    });
    setState(() {
      totalattendance=(practicalattendance + theoryattendance)/2;
    });
  }
  Future<void> getcolor()async{
    if(totalattendance<75.00)
    {
      setState(() {
        alert='Attendance less than required';
        attendance=Colors.red;
      });
    }
  }

  Future<void> getdetails() async{
    await getuserid();
    try{
      DocumentSnapshot data = await Firestore.instance.collection('Students').document(userid).get();
      setState(() {
        userdetails=data.data;
      });
    await getattendance();
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
                  '${totalattendance.toStringAsPrecision(3)} %',
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

