import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:pbl_project_app/shared/form_decoration.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ParticularStudent extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ParticularStudent> {
  //variables
  int rollno;
  bool resultsRecieved = false;
  String imageurl;
  Map userinfo;

  final CollectionReference students =
      Firestore.instance.collection('Students');
      final FirebaseStorage photos= FirebaseStorage(storageBucket: 'gs://pbl-app-87c6e.appspot.com');
  

  //functions
  Future<void> getstudent()async{
    try{
      QuerySnapshot data=await students.getDocuments();
      List allstudents = data.documents;
      for(int i=0;i<allstudents.length;i++)
      {
        if(allstudents[i].data['rollno']==rollno)
        {
          String id = allstudents[i].documentID;
          final StorageReference downloader = photos.ref().child(id);
      String url=await downloader.getDownloadURL();
      setState(() {
        imageurl=url;
      });
          setState(() {
            userinfo=allstudents[i].data;
          });
        }
      }
    }
    catch (e) {
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
    if(resultsRecieved)
    {
      if(userinfo==null)
      {
        return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Particular Student',
          style: TextStyle(
            fontSize: 25,
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
                                  child: Text(
                                    'Search Result',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Center(
                                  child: Text(
                                    '$rollno not found in the User Database\nMaybe Invalid Roll Number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
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
      else
      {
        return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Particular Student',
          style: TextStyle(
            fontSize: 25,
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
                  children: [
                    Center(
                                  child: Text(
                                    'Search Result',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                    Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                )
              ),
              child: Image.network(
                imageurl,
                height: 200,
                width: 200,
                ),
            )
          ),
          SizedBox(height: 30.0,),
          Text(
                  'Student Details',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 40,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${userinfo["name"]}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  'Roll No: ${userinfo["rollno"]}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  'Date of Birth: ${userinfo["date_of_birth"]}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  'Semester: ${userinfo["semester"]}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  'Branch: ${userinfo["branch"]}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  'Current Attendance: ${userinfo["total_attendance"]}%',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
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
    else
    {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Particular Student',
          style: TextStyle(
            fontSize: 25,
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
                          child: Text(
                            'Enter Roll Number of the Student you want get the Information of',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: fieldDecoration.copyWith(
                            labelText: 'Roll number',
                          ),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                rollno = int.parse(value);
                              });
                            }
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).unfocus(),
                        ),
                        SizedBox(height: 20,),
                        RaisedButton(
                              color: Colors.blue,
                  onPressed: ()async {
                    if(rollno!=null && rollno.toString() !='')
                    {
                      Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Searching for Student...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                  await getstudent();
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
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pop(context);
                  setState(() {
                    resultsRecieved=true;
                  });
                  }
                  else
                  {
                    Alert(
                                        context: context,
                                        title: 'Empty Fields',
                                        desc: 'Please Enter Roll Number',
                                        buttons: [],
                                        style: AlertStyle(
                                            backgroundColor: Colors.cyan))
                                    .show();
                  }
                  },
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                  child: Text(
                    'Search',
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