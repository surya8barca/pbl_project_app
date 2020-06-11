import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:pbl_project_app/user/teacher/Attendance/getclasspicture.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TakeAttendance extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<TakeAttendance> {
  //variables
  bool branchform=false,subjecttypeform=false,subjectform=false,submitbutton=false;
  int sem;
  String semesterValue,subjecttype,subject,branch;
  List semesters=['1','2','3','4','5','6','7','8'];
  List branches=['Computer','Info. Tech','Electronics','Production','Mechanical','Electronics & Computer Science'];
  List subjecttypes=['Practical','Theory'];
  List subjects=[];


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

  @override
  Widget build(BuildContext context) {
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
                                  submitbutton=true;
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
                            visible: submitbutton,
                            child: RaisedButton(
                              color: Colors.blueGrey,
                  onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetClassPic(sem: sem,branch: branch,subjectType: subjecttype,subject: subject),), (route) => false);
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