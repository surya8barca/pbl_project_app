import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'User Home',
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