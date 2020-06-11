import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/Hive/userdata.dart';
import 'package:pbl_project_app/auth/login.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../pageloading.dart';

class PracticalSubjects extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<PracticalSubjects> {
  //variables
  String userid;
  final userbox= Hive.box('currentuser');
  List practicalSubjects;

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
  Future<void> getdetails() async{
    await getuserid();
    try{
      final CollectionReference practicaldata= Firestore.instance.collection('Practical_Subjects_$userid');
      QuerySnapshot practicalsubjects=await practicaldata.getDocuments();
      setState(() {
        practicalSubjects=practicalsubjects.documents;
      });
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
    if(practicalSubjects==null)
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
                        'Practical Subjects',
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for(int i=0;i<practicalSubjects.length;i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          practicalSubjects[i].data['Subject_Name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Total Lectures: ${practicalSubjects[i].data['Total_Lectures'].toString()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Lectures Attended: ${practicalSubjects[i].data['Lectures_Attended'].toString()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          'Current Attendance',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          '${practicalSubjects[i].data['Subject_Attendance'].toStringAsPrecision(3)} %',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ],
              ),
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