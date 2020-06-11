import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TakeAttendance extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<TakeAttendance> {
  //variables
  bool branchform=false,subjecttypeform=false,subjectform=false,submitbutton=false,getpicture=false,resultsRecieved=false;
  int sem;
  File attendancepicture;
  String semesterValue,subjecttype,subject,branch;
  String imagestatus = 'Upload your picture';
  List presentstudents=[8320,8321,8367];//result after sending picture
  List semesters=['1','2','3','4','5','6','7','8'];
  List branches=['Computer','Info. Tech','Electronics','Production','Mechanical','Electronics & Computer Science'];
  List subjecttypes=['Practical','Theory'];
  List subjects=[];

  final CollectionReference students= Firestore.instance.collection('Students');

  //functions
  Future<void> getsubjects() async{
    try{
      String url='https://musubjects.herokuapp.com/subjects/?Semester=$sem&Branch=$branch';
      Response data = await get(url);
      Map values = jsonDecode(data.body);
      List pracs=values['Practical Subjects'];
      List theory = values['Theory Subjects'];
      if(subjecttype=='Practical')
      {
        setState(() {
          subjects=pracs;
        });
      }
    else
    {
      setState(() {
        subjects=theory;
      });
    }
    }
    catch(e)
    {
      Navigator.pop(context);
      Alert(
          context: context,
          title: 'Error in getting subjects/nTry again',
          desc: e.message,
          buttons: []).show();
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
          Navigator.pop(context);
    }
  }

  Future getcameraimage() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      attendancepicture = File(image.path);
      imagestatus = 'View/Edit your picture  ';
    });
  }
  Future getgalleryimage() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      attendancepicture = File(image.path);
      imagestatus = 'View/Edit your picture  ';
    });
  }


  @override
  Widget build(BuildContext context) {
    if(resultsRecieved)
    {
      return Scaffold(
        appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Take Attendance',
          style: TextStyle(
            fontSize: 23,
            color: Colors.black,
          ),
        ),
      ),
      body: Builder(builder: (context) =>
      SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Background(),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child:Text(
                      'Semester: $sem' ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    Center(
                      child:Text(
                      'Branch: $branch' ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    Center(
                      child:Text(
                      'Subject: $subject (Type:$subjecttype)' ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child:Text(
                      'Students Present' ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Column(
                      children: [
                        for(int i=0;i<presentstudents.length;i++)
                        Text(
                          'Roll no: ${presentstudents[i]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    RaisedButton(
                      color: Colors.blue,
                    onPressed: ()async {
                      Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Marking Attendance...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                    await Future.delayed(Duration(seconds: 5));
                    Navigator.pop(context);
                    Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Attendance Marked Successfully",
                    buttons: [],
                  ).show();
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context);
                    Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Redirecting to Home Page...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                  await Future.delayed(Duration(seconds: 5));
                    Navigator.pop(context);
                    Navigator.pop(context);
                    },
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    child: Text(
                      'Mark Attendance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),                  
                    ],
                ),      

              ),
              Divider(
                      height: 5.0,
                      thickness: 2.0,
                      color: Colors.blueAccent,
                      indent: 30.0,
                      endIndent: 30.0,
                    ),
                          SizedBox(height: 20,)
            ],
          ),
        ),
      )
      ,)  
      );
    }
    else
    {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Take Attendance',
          style: TextStyle(
            fontSize: 23,
            color: Colors.black,
          ),
        ),
      ),
      body: Builder(builder: (context) => 
      SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Background(),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child:Text(
                      'Select Subject',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Text(
                            'Select Semester:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: DropdownButton(
                              iconEnabledColor: Colors.white,
                              underline: Container(),
                              hint: Text(
                                'Select:',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              isExpanded: true,
                              items:
                                  semesters.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (chosen) {
                                setState(() {
                                  semesterValue = chosen;
                                  sem=int.parse(semesterValue);
                                  branchform=true;
                                });
                              },
                              value: semesterValue,
                            ),
                          ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Visibility(
                            visible: branchform,
                            child: Column(
                            children: [
                              Text(
                            'Select Branch:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: DropdownButton(
                              iconEnabledColor: Colors.white,
                              underline: Container(),
                              hint: Text(
                                'Select:',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              isExpanded: true,
                              items:
                                  branches.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (chosen) {
                                if(sem==7 && chosen=='Production')
                                {
                                  Alert(
                                        context: context,
                                        title: 'Invalid Selection',
                                        desc: '7th Semester for Prodction is just for Internship and hence is not eligible to use this appplication ',
                                        buttons: [],
                                        style: AlertStyle(
                                            backgroundColor: Colors.cyan))
                                    .show();
                                }
                                else
                                {
                                  setState(() {
                                  branch = chosen;
                                  subjecttypeform=true;
                                });
                                }
                              },
                              value: branch,
                            ),
                          ),
                            ],
                          ),
                          ),
                          SizedBox(height: 15,),
                          Visibility(
                            visible: subjecttypeform,
                            child: Column(
                            children: [
                              Text(
                            'Select Subject Type:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: DropdownButton(
                              iconEnabledColor: Colors.white,
                              underline: Container(),
                              hint: Text(
                                'Select:',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              isExpanded: true,
                              items:
                                  subjecttypes.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (chosen) async{
                                setState(() {
                                  subjecttype = chosen;
                                });
                                await Future.delayed(Duration(milliseconds:30));
                                Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Getting Subject List...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                                await getsubjects();
                                Navigator.pop(context);
                                setState(() {
                                  subjectform=true;
                                });
                              },
                              value: subjecttype,
                            ),
                          ),
                            ],
                          ),
                          ),
                          SizedBox(height: 15,),
                          Visibility(
                            visible: subjectform,
                            child: Column(
                            children: [
                              Text(
                            'Select Subject:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: DropdownButton(
                              iconEnabledColor: Colors.white,
                              underline: Container(),
                              hint: Text(
                                'Select:',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              isExpanded: true,
                              items:
                                  subjects.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (chosen){
                                setState(() {
                                  subject = chosen;
                                  getpicture=true;
                                });
                              },
                              value: subject,
                            ),
                          ),
                            ],
                          ),
                          ),
                          SizedBox(height: 15,),
                          Visibility(
                            visible: getpicture,
                            child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Class Photo for Attendance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25
                          ),
                        ),
                        SizedBox(height: 20,),
                        InkWell(
                        onTap: () {
                          if (attendancepicture == null) {
                            Alert(
                              context: context,
                              title: 'Select method',
                              buttons: [],
                              style: AlertStyle(
                                backgroundColor: Colors.black,
                                titleStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    FlatButton(
                                      padding: EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      onPressed: () async {
                                        await getcameraimage();
                                        Navigator.pop(context);
                                      },
                                      color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Camera',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.photo_camera,
                                            color: Colors.black,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FlatButton(
                                      padding: EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      onPressed: () async {
                                        await getgalleryimage();
                                        Navigator.pop(context);
                                      },
                                      color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Gallery',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.camera,
                                            color: Colors.black,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).show();
                            setState(() {
                              submitbutton=true;
                            });
                          } else {
                            Alert(
                              context: context,
                              title: 'Your Image',
                              buttons: [],
                              style: AlertStyle(
                                backgroundColor: Colors.black,
                                titleStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Image.file(attendancepicture),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Alert(
                                                context: context,
                                                title: 'Select method',
                                                buttons: [],
                                                style: AlertStyle(
                                                  backgroundColor: Colors.black,
                                                  titleStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Container(
                                                  padding: EdgeInsets.all(25),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      FlatButton(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25)),
                                                        onPressed: () async {
                                                          await getcameraimage();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        color: Colors.blue,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              'Camera',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .photo_camera,
                                                              color:
                                                                  Colors.black,
                                                              size: 30,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      FlatButton(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25)),
                                                        onPressed: () async {
                                                          await getgalleryimage();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        color: Colors.blue,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              'Gallery',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Icon(
                                                              Icons.camera,
                                                              color:
                                                                  Colors.black,
                                                              size: 30,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ).show();
                                            },
                                            color: Colors.blue,
                                            child: Text(
                                              'Edit',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          FlatButton(
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.blue,
                                            child: Text(
                                              'Okay',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ).show();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                imagestatus,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                          ),
                          SizedBox(height: 15,),
                          Visibility(
                            visible: submitbutton,
                            child: RaisedButton(
                              color: Colors.blueGrey,
                  onPressed: ()async {
                      Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Processing Image...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                  await Future.delayed(Duration(seconds: 5));
                  Navigator.pop(context);
                  Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Getting Results...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                  await Future.delayed(Duration(seconds: 5));
                  Navigator.pop(context);
                  setState(() {
                    resultsRecieved=true;
                  });
                  },
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
              Divider(
                      height: 5.0,
                      thickness: 2.0,
                      color: Colors.blueAccent,
                      indent: 30.0,
                      endIndent: 30.0,
                    ),
                          SizedBox(height: 20,)
            ],
          ),
        ),
      ),
      ),
    );
  }
  }
}