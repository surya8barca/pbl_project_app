import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl_project_app/auth/login.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:pbl_project_app/shared/form_decoration.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Register extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Register> {
  //variables
  String userID;
  String formDob = "Date of Birth";
  String imagestatus = 'Upload your picture';
  File idPhoto;
  String email, password, name, branch, userType, dob, finishyear;
  int rollno, sem, teacherid;
  bool hidepassword = true,
      firstform = true,
      secondform = false,
      studentform = false,
      teacherform = false,
      imageform = false;
  List user = ['Teacher', 'Student'];
  List branches=['Computer','Info. Tech','Electronics','Production','Mechanical'];

  final CollectionReference teachers= Firestore.instance.collection('Teachers');
  final CollectionReference students= Firestore.instance.collection('Students');
  final FirebaseStorage photos= FirebaseStorage(storageBucket: 'gs://pbl-app-87c6e.appspot.com');

  //functions
  Future<bool> registration()async{
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      setState(() {
        userID = result.user.uid;
      });
      return true;
    } catch (e) {
      Navigator.pop(context);
      Alert(
          context: context,
          title: 'Registration Error',
          desc: e.message,
          buttons: []).show();
      return false;
    }

  }

  Future<bool> dataentryTeacher() async{
    try{
      await teachers.document(userID).setData({
        'name':name,
        'teacherID':teacherid,
        'date_of_birth':dob,
        'branch':branch,
        'user_type':userType,
      });
      return true;
    }
    catch (e) {
      Navigator.pop(context);
      Alert(
          context: context,
          title: 'Database Error',
          desc: e.message,
          buttons: []).show();
      return false;
    }

    }


  Future<bool> dataentryStudent() async{
    try{
      await students.document(userID).setData({
        'name':name,
        'rollno':rollno,
        'semester':sem,
        'date_of_birth':dob,
        'branch':branch,
        'user_type':userType,
      });
      return true;
    }
    catch (e) {
      Navigator.pop(context);
      Alert(
          context: context,
          title: 'Database Error',
          desc: e.message,
          buttons: []).show();
      return false;
    }
    }

  Future<bool> photoupload() async{
    try{
      final StorageReference uploader = photos.ref().child(userID);
      StorageUploadTask upload=uploader.putFile(idPhoto);
      await upload.onComplete;    
      return true;
    }
    catch (e) {
      Navigator.pop(context);
      Alert(
          context: context,
          title: 'Uploading Error',
          desc: e.message,
          buttons: []).show();
      return false;
    }
    }

  Future getcameraimage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      idPhoto = image;
      imagestatus = 'View/Edit your picture  ';
    });
  }

  Future getgalleryimage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      idPhoto = image;
      imagestatus = 'View/Edit your picture  ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Registration',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Background(),
                Visibility(
                  visible: firstform,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Enter your login details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration:
                              fieldDecoration.copyWith(labelText: 'Email Id'),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                email = value;
                              });
                            }
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          obscureText: hidepassword,
                          decoration: fieldDecoration.copyWith(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                setState(() {
                                  hidepassword = false;
                                });
                                await Future.delayed(Duration(seconds: 3));
                                setState(() {
                                  hidepassword = true;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                password = value;
                              });
                            }
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).unfocus(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30)),
                          minWidth: 150,
                          height: 60,
                          buttonColor: Colors.cyan,
                          child: RaisedButton(
                            onPressed: () async {
                              if (email != null && password != null) {
                                Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Regestering the user on firebase...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                                bool status=await registration();
                                if(status)
                                {
                                  Navigator.pop(context);
                                  setState(() {
                                  firstform = false;
                                });
                                setState(() {
                                  secondform = true;
                                });
                                }
                              } else {
                                Alert(
                                        context: context,
                                        title: 'Empty Fields',
                                        desc: 'All fields are mandatory',
                                        buttons: [],
                                        style: AlertStyle(
                                            backgroundColor: Colors.cyan))
                                    .show();
                              }
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                              ),
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
                  height: 10,
                ),
                Text(
                  'Already a user?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30)),
                          minWidth: 150,
                          height: 60,
                          buttonColor: Colors.blue,
                          child: RaisedButton(
                            onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                  height: 10,
                ),
                Divider(
                      height: 5.0,
                      thickness: 2.0,
                      color: Colors.blueAccent,
                      indent: 30.0,
                      endIndent: 30.0,
                    ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: secondform,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'What type of User are you?',
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
                                'Select User Type:',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              isExpanded: true,
                              items:
                                  user.map<DropdownMenuItem<String>>((value) {
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
                                  userType = chosen;
                                });
                              },
                              value: userType,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30)),
                            minWidth: 150,
                            height: 60,
                            buttonColor: Colors.cyan,
                            child: RaisedButton(
                              onPressed: () async {
                                Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Preparing next steps...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                                if (userType != null) {
                                  setState(() {
                                    secondform = false;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.pop(context);
                                  if (userType == 'Teacher')
                                    setState(() {
                                      teacherform = true;
                                    });
                                  else {
                                    setState(() {
                                      studentform = true;
                                    });
                                  }
                                } else {
                                  Alert(
                                          context: context,
                                          title: 'Empty Fields',
                                          desc: 'Please Select any one option',
                                          buttons: [],
                                          style: AlertStyle(
                                              backgroundColor: Colors.cyan))
                                      .show();
                                }
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                Visibility(
                  visible: teacherform,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Enter your personal details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration:
                              fieldDecoration.copyWith(labelText: 'Full Name'),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                name = value;
                              });
                            }
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: fieldDecoration.copyWith(
                            labelText: 'Teacher ID',
                          ),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                teacherid = int.parse(value);
                              });
                            }
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).unfocus(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                setState(() {
                                  formDob =
                                      "${date.toString().split(' ')[0].split('-')[2]}/${date.toString().split(' ')[0].split('-')[1]}/${date.toString().split(' ')[0].split('-')[0]}";
                                  dob = formDob;
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  formDob,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 30),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue,width: 2,),
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                            ),
                            child: DropdownButton(
                              iconEnabledColor: Colors.blue,
                              underline: Container(),
                              hint: Text(
                                'Select your Branch:',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.blue,
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
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
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
                                  branch= chosen;
                                });
                              },
                              value: branch,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30)),
                          minWidth: 150,
                          height: 60,
                          buttonColor: Colors.cyan,
                          child: RaisedButton(
                            onPressed: () async {
                              if (name != null && teacherid != null && dob!=null && branch!=null) {
                                Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Adding the information on firebase database...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                                bool status= await dataentryTeacher();
                                if(status)
                                {
                                  Navigator.pop(context);
                                  setState(() {
                                  teacherform = false;
                                });
                                setState(() {
                                  imageform = true;
                                });
                                }
                                
                              } else {
                                Alert(
                                        context: context,
                                        title: 'Empty Fields',
                                        desc: 'All fields are mandatory',
                                        buttons: [],
                                        style: AlertStyle(
                                            backgroundColor: Colors.cyan))
                                    .show();
                              }
                            },
                            child: Text(
                              'Next',
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
                ),
                Visibility(
                  visible: studentform,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Enter your personal details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration:
                              fieldDecoration.copyWith(labelText: 'Full Name'),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                name = value;
                              });
                            }
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 20),
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
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                setState(() {
                                  formDob =
                                      "${date.toString().split(' ')[0].split('-')[2]}/${date.toString().split(' ')[0].split('-')[1]}/${date.toString().split(' ')[0].split('-')[0]}";
                                  dob = formDob;
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  formDob,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 30),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: fieldDecoration.copyWith(
                            labelText: 'Semester',
                          ),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          onChanged: (value) {
                            if (value != null) {
                              if(int.parse(value)<1 || int.parse(value)>8)
                              {
                                Alert(
                                        context: context,
                                        title: 'Invalid input',
                                        desc: 'Semester must be between 1 and 8',
                                        buttons: [],
                                        style: AlertStyle(
                                            backgroundColor: Colors.cyan))
                                    .show();
                              }
                              setState(() {
                                sem = int.parse(value);
                              });
                            }
                          },
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue,width: 2,),
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                            ),
                            child: DropdownButton(
                              iconEnabledColor: Colors.blue,
                              underline: Container(),
                              hint: Text(
                                'Select your Branch:',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.blue,
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
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
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
                                  branch= chosen;
                                });
                              },
                              value: branch,
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30)),
                          minWidth: 150,
                          height: 60,
                          buttonColor: Colors.cyan,
                          child: RaisedButton(
                            onPressed: () async {
                              if (name != null && rollno != null && dob!=null && branch!=null && sem!=null) {
                                Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Adding the information on firebase database...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                                bool status= await dataentryStudent();
                                if(status){
                                  Navigator.pop(context);
                                  setState(() {
                                  studentform = false;
                                });
                                setState(() {
                                  imageform = true;
                                });
                                }
                              } else {
                                Alert(
                                        context: context,
                                        title: 'Empty Fields',
                                        desc: 'All fields are mandatory',
                                        buttons: [],
                                        style: AlertStyle(
                                            backgroundColor: Colors.cyan))
                                    .show();
                              }
                            },
                            child: Text(
                              'Next',
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
                ),
                Visibility(
                  visible: imageform,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Your Photo (face should be visible clearly)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35
                          ),
                        ),
                        SizedBox(height: 20,),
                        InkWell(
                        onTap: () {
                          if (idPhoto == null) {
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
                                        child: Image.file(idPhoto),
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
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                imagestatus,
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20),
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Icon(
                                Icons.photo_camera,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30)),
                          minWidth: 150,
                          height: 60,
                          buttonColor: Colors.blue,
                          child: RaisedButton(
                            onPressed: () async {
                              if (idPhoto!=null) {
                                Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.cyan,
                    ),
                    title: "Final Submit",
                    desc: "Are you sure you want to submit?",
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
                              onPressed: ()async{
                                Navigator.pop(context);
                                Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Please wait",
                    desc: "Uploading you picture to the Database...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                          bool status = await photoupload();
                          if(status)
                          {
                            Navigator.pop(context);
                            Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.white,
                    ),
                    title: "Registration Successful",
                    desc: "Redirecting to login page...",
                    buttons: [],
                    content: Container(
                      child: SpinKitCircle(color: Colors.blue),
                    )
                  ).show();
                  await Future.delayed(Duration(seconds: 3));
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                          }
                          //carols's backend test
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
                              } else {
                                Alert(
                                        context: context,
                                        title: 'Empty Fields',
                                        desc: 'please upload your picture',
                                        buttons: [],
                                        style: AlertStyle(
                                            backgroundColor: Colors.cyan))
                                    .show();
                              }
                            },
                            child: Text(
                              'Submit',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
