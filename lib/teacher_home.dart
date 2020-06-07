import 'package:attendance_app/teacher_profile.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app/main.dart';
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'getpicture.dart';

void main() => runApp(MaterialApp(
  home: Teacher(),
)
);

class Teacher extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Teacher> {
  String subject;
  //subject name selected saved in here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Mahendra Mehra',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(
        child:Column(
          children: <Widget>[
          Container(
            color: Colors.cyan,
            child: DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://yt3.ggpht.com/a/AATXAJzNgJlmLKSWBIxpT_yoZDrzHBlvXvoRE82Mpw=s288-c-k-c0xffffffff-no-rj-mo'), //image url of each teacher from database
                    radius: 50.0,
                  ),
                  Text(
                    'Mahendra Mehra', //name of teacher
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ),
          ),
          Divider(
            height:3,
            thickness:3.0,
            color:Colors.black, 
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ButtonTheme(
                height: 80,
                buttonColor: Colors.transparent,
                child: RaisedButton(
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (context) => ProfileT());
                  Navigator.push(context, route); 
                }, 
                child: Text(
                  'Profile',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            ButtonTheme(
              height: 80,
                buttonColor: Colors.transparent,
                child: RaisedButton(
                onPressed: (){
                  //Route route = MaterialPageRoute(builder: (context) => LoginT());
                  //Navigator.pushReplacement(context, route); 
                  //send to change password page
                }, 
                child: Text(
                  'Change Password',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            ButtonTheme(
              height: 80,
                buttonColor: Colors.transparent,
                child: RaisedButton(
                onPressed: (){
                  Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.cyan,
                    ),
                    title: "Logout",
                    desc: "Are you sure you want to logout?",
                    buttons: [],
                    content: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ButtonTheme(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            buttonColor: Colors.black,
                            child: RaisedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ButtonTheme(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            buttonColor: Colors.black,
                            child: RaisedButton(
                              onPressed: (){
                                Route route = MaterialPageRoute(builder: (context) => Home());
                                Navigator.pop(context);
                                Navigator.pushReplacement(context, route);
                              },
                              child: Text(
                                'Yes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ).show();
                }, 
                child: Text(
                  'Logout',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            ],
            ),
          ),
        ],
        ),
      ),
      body: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Colors.green[800],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'FR. CONCEICAO RODRIGUES COLLEGE OF ENGINEERING',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '(Approved by AICTE & Affiliated to university of Mumbai)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Bandstand,Bandra (W), Mumbai - 400 050. *Tel.: 6711 4000 * Fax: 6711 4200 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 15.0,),
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('images/agnel.jpg'),
                radius: 80.0,
              ),
            ),
            SizedBox(height: 15.0,),
            Divider(
              height:5.0,
              thickness:2.0,
              color:Colors.blueAccent,
              indent:30.0,
              endIndent:30.0, 
            ),
            SizedBox(height: 15.0,),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30)
              ),
                minWidth: 1500,
                height: 60,
                buttonColor: Colors.cyan,
                child: RaisedButton(
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (context) => Photo());
                  Navigator.push(context, route);
                  
                }, 
                child: Text(
                  'Take Attendance',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30)
              ),
                minWidth: 1500,
                height: 60,
                buttonColor: Colors.cyan,
                child: RaisedButton(
                onPressed: (){
                  //Route route = MaterialPageRoute(builder: (context) => LoginS());
                  //Navigator.pushReplacement(context, route);
                  //Student Notification
                }, 
                child: Text(
                  'Notifications to Students',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30)
              ),
                minWidth: 1500,
                height: 60,
                buttonColor: Colors.cyan,
                child: RaisedButton(
                onPressed: (){
                  //Route route = MaterialPageRoute(builder: (context) => LoginS());
                  //Navigator.pushReplacement(context, route);
                  //parent report
                }, 
                child: Text(
                  'Report to Parents',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30)
              ),
                minWidth: 1500,
                height: 60,
                buttonColor: Colors.cyan,
                child: RaisedButton(
                onPressed: () {
                  Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.cyan,
                    ),
                    title: "Exit",
                    desc: "Are you sure you want to exit?",
                    buttons: [],
                    content: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ButtonTheme(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            buttonColor: Colors.black,
                            child: RaisedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ButtonTheme(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            buttonColor: Colors.black,
                            child: RaisedButton(
                              onPressed: (){
                                exit(0);
                              },
                              child: Text(
                                'Yes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ).show();
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
          ]
        ),
      )
     ]
    )
      )		
    );
  }
}






