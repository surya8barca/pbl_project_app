import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Defaulter extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Defaulter> {
  //variables
  bool resultsRecieved = false,
      branchform = false,
      criteriaform = false,
      submitbutton = false;
  int sem;
  double attendancecriteria;
  String semesterValue, branch, criteriaValue;
  List semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  List branches = [
    'Computer',
    'Info. Tech',
    'Electronics',
    'Production',
    'Mechanical',
    'Electronics & Computer Science'
  ];
  List criteria = ['40', '50', '60', '75'];
  List defaulters = [];

  final CollectionReference students =
      Firestore.instance.collection('Students');

  //functions
  Future<void> getdefaulters() async {
    try {
      QuerySnapshot result = await students.getDocuments();
      List allstudents = result.documents;
      for (int i = 0; i < allstudents.length; i++) {
        if (allstudents[i].data['semester'] == sem &&
            allstudents[i].data['branch'] == branch &&
            allstudents[i].data['total_attendance'] < attendancecriteria) {
          defaulters.add(allstudents[i].data);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      Alert(
          context: context,
          title: 'Database Error',
          desc: 'Please Try Again',
          buttons: []).show();
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (resultsRecieved) {
      if (defaulters.isEmpty) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.blueGrey,
              centerTitle: true,
              title: Text(
                'Defaulter List',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            body: Builder(
                builder: (context) => SingleChildScrollView(
                        child: Container(
                            child: Column(children: [
                      Background(),
                      Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Semester: $sem',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Branch: $branch',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Attendance Criteria: $criteriaValue %',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                    'Defaulter\'s List',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                    'No Defaulters in the Class',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              ),
                              ),
                              SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
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
                            )).show();
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      child: Text(
                        'Okay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                              Divider(
                    height: 5.0,
                    thickness: 2.0,
                    color: Colors.blueAccent,
                    indent: 30.0,
                    endIndent: 30.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                    ],
                    ),
                    ),
                    ),
                    ),
                    );
      } else {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.blueGrey,
            centerTitle: true,
            title: Text(
              'Defaulter List',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          body: Builder(
            builder: (context) => SingleChildScrollView(
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
                            child: Text(
                              'Semester: $sem',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Branch: $branch',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Attendance Criteria: $criteriaValue %',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text(
                              'Defaulter\'s List',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (int i = 0; i < defaulters.length; i++)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            defaulters[i]['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            defaulters[i]['rollno'].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            '${defaulters[i]['total_attendance'].toString()} %',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
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
                            )).show();
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      child: Text(
                        'Okay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 5.0,
                      thickness: 2.0,
                      color: Colors.blueAccent,
                      indent: 30.0,
                      endIndent: 30.0,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: Text(
            'Defaulter List',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
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
                          child: Text(
                            'Select Class',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
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
                                      items: semesters
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            height: 60,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          sem = int.parse(semesterValue);
                                          branchform = true;
                                        });
                                      },
                                      value: semesterValue,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: branchform,
                                child: Column(
                                  children: [
                                    Text(
                                      'Select Branch:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
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
                                        items: branches
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem<String>(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                          if (sem == 7 &&
                                              chosen == 'Production') {
                                            Alert(
                                                    context: context,
                                                    title: 'Invalid Selection',
                                                    desc:
                                                        '7th Semester for Prodction is just for Internship and hence is not eligible to use this appplication ',
                                                    buttons: [],
                                                    style: AlertStyle(
                                                        backgroundColor:
                                                            Colors.cyan))
                                                .show();
                                          } else {
                                            setState(() {
                                              branch = chosen;
                                              criteriaform = true;
                                            });
                                          }
                                        },
                                        value: branch,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: criteriaform,
                                child: Column(
                                  children: [
                                    Text(
                                      'Select Attendance criteria:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
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
                                        items: criteria
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem<String>(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            criteriaValue = chosen;
                                            attendancecriteria =
                                                double.parse(criteriaValue);
                                            submitbutton = true;
                                          });
                                        },
                                        value: criteriaValue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: submitbutton,
                                child: RaisedButton(
                                  color: Colors.blueGrey,
                                  onPressed: () async {
                                    Alert(
                                        context: context,
                                        style: AlertStyle(
                                          backgroundColor: Colors.white,
                                        ),
                                        title: "Please wait",
                                        desc:
                                            "Searching for Defaulters in Database...",
                                        buttons: [],
                                        content: Container(
                                          child:
                                              SpinKitCircle(color: Colors.blue),
                                        )).show();
                                    await getdefaulters();
                                    Navigator.pop(context);
                                    Alert(
                                        context: context,
                                        style: AlertStyle(
                                          backgroundColor: Colors.white,
                                        ),
                                        title: "Please wait",
                                        desc: "Preparing list...",
                                        buttons: [],
                                        content: Container(
                                          child:
                                              SpinKitCircle(color: Colors.blue),
                                        )).show();
                                    await Future.delayed(Duration(seconds: 2));
                                    Navigator.pop(context);
                                    setState(() {
                                      resultsRecieved = true;
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
