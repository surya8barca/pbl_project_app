import 'package:flutter/material.dart';
import 'package:pbl_project_app/loading.dart';
import 'shared/background.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool start=false;

  Future<void> first() async{
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      start=true;
    });
  }
  @override
  void initState() {
    first();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(start==false)
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
          'Attendance System',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Builder(builder: (context) => 
      SingleChildScrollView(
        child: Container(
          child: Container(
            child: Column(
              children: [
                Background(),
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

