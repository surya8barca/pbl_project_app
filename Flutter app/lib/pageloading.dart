import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'shared/background.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) => 
      SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Background(),
              SizedBox(height: 60,),
              Container(
                child: Center(
                  child: SpinKitCircle(
                    color: Colors.blue,
                    size: 100,
                  ),
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