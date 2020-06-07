//picture saved in file format

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MaterialApp(
  home: Photo(),
)
);

class Photo extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Photo> {
  File imageclicked; //picture saved here

  Future getimage() async{
    var image= await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageclicked=image;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Take Picture',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.black,
          ),
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
            Container(
              child: Center(
                child: imageclicked==null
                      ? Column(
                        children: <Widget>[
                          SizedBox(height: 15),
                          Text(
                            'No image selected Please click a picture',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 50.0,),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ButtonTheme(
                                shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50)
                              ),                
                              minWidth: 100,
                              height: 60,
                              buttonColor: Colors.blue,
                              child: RaisedButton(
                              onPressed: (){
                                getimage(); 
                              }, 
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.add_a_photo),
                                  SizedBox(width: 15.0),
                                  Text(
                                    'Take a Picture',
                                    style: TextStyle(
                                      fontSize: 25.0
                                    ),
                                  )
                                ],
                              )
                              ),
                          ),
                            ),
                        ], 
                        )
                      : Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Container(
                                child: Image.file(imageclicked)
                                ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ButtonTheme(
                                shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50)
                              ),                
                              minWidth: 50,
                              height: 60,
                              buttonColor: Colors.blue,
                              child: RaisedButton(
                              onPressed: (){
                                getimage(); 
                              }, 
                              child: Text(
                                'Retake',
                                style: TextStyle(
                                  fontSize: 25.0
                                ),
                              )
                              ),
                              ),
                              SizedBox(width: 10.0),
                              ButtonTheme(
                                shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50)
                              ),                
                              minWidth: 50,
                              height: 60,
                              buttonColor: Colors.blue,
                              child: RaisedButton(
                              onPressed: (){
                                Alert(
                                context: context,
                                style: AlertStyle(
                                backgroundColor: Colors.cyan,
                                ),
                                title: "Submit",
                                desc: "Are you sure you want to submit image ?",
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
                                          Navigator.pop(context);
                                          Navigator.pop(context);
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
                                  ),
                        ],
                      ),
                    ),
                  ).show(); 
                              }, 
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 25.0
                                ),
                              )
                              ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50.0),
                        ],
                      ),
              )
            ),
          ]
        ),
      ),
    );
  }
}






