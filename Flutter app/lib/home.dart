import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/Hive/userdata.dart';
import 'package:pbl_project_app/loading.dart';
import 'package:pbl_project_app/user/userhome.dart';
import 'firstpage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variables
  bool start = false,usersaved;
  String userid,usertype;
  final userbox = Hive.box('currentuser');

  //functions
  Future<void> getdata()async{
    if(userbox.length==0)
    {
      setState(() {
        usersaved=false;
      });
    }
    else
    {
      Userinfo user=await userbox.getAt(0) as Userinfo;
      setState(() {
        userid=user.userid;
        usertype=user.usertype;
        usersaved=true;
      });
    }
  }

  Future<void> first() async {
    await getdata();
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      start = true;
    });
  }

  @override
  void initState() {
    first();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (start == false) {
      return Loading();
    } else {
      if(usersaved)
      {
        return UserHome(userid: userid,usertype: usertype);
      }
      else
      {
        return Firstpage();
      }
      
    }
  }
}

