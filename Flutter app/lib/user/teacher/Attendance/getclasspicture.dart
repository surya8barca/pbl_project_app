import 'package:flutter/material.dart';

class GetClassPic extends StatefulWidget {
  final int sem;
  final String branch,subjectType,subject;
  GetClassPic({this.sem,this.branch,this.subjectType,this.subject});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<GetClassPic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Class Picture',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Builder(builder: (context) => 
      SingleChildScrollView(
        child: Container(
          
        ),
      ),
      ),
    );
  }
}