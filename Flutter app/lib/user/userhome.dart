import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/auth/login.dart';
import 'package:pbl_project_app/loading.dart';
import 'package:pbl_project_app/user/student/studenthome.dart';
import 'package:pbl_project_app/user/teacher/teacherhome.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserHome extends StatefulWidget {
  final String userid,usertype;
  UserHome({this.userid,this.usertype});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<UserHome> {
  //variacles
  bool validuser;
  final userbox = Hive.box('currentuser');


  //functions
  Future<void> validateuser() async{
    try{
      DocumentSnapshot data =await Firestore.instance.collection('${widget.usertype}s').document(widget.userid).get();
      if(data.data!=null)
      {
        setState(() {
        validuser=true;
      });
      }
      else
      { if(userbox.length!=0)
      {
        userbox.deleteAt(0);
      }
        Alert(
          context: context,
          title: 'Login Error',
          desc: 'Please try loggin in again',
          buttons: []).show();
        await Future.delayed(Duration(seconds: 3));
        Navigator.pop(context);
        await Future.delayed(Duration(seconds: 1));
      setState(() {
        validuser=false;
      });  
      }
    }
    catch (e) {
      if(userbox.length!=0)
      {
        userbox.deleteAt(0);
      }
      Alert(
          context: context,
          title: 'Login Error',
          desc: 'Please try loggin in again',
          buttons: []).show();
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
        await Future.delayed(Duration(seconds: 1));
      setState(() {
        validuser=false;
      });
    }
  }

  @override
  void initState() {
    validateuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    if(validuser==null)
    {
      return Loading();
    }
    else if(validuser==true)
    {
      if(widget.usertype=='Teacher')
      {
        return TeacherHome();
      }
      else
      {
        return StudentHome();
      }
    }
    else
    {
      return Login();
    }
  }
}