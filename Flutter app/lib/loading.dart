import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                CircleAvatar(
          backgroundImage: AssetImage('images/agnel.jpg'),
          radius: 80.0,
        ),
        SizedBox(height: 20,),
        SpinKitThreeBounce(
          color: Colors.blue,
          size: 100,
        )
              
              
            ],
          ),
        ),
      ),
    );
  }
}
