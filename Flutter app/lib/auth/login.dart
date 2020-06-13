import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:pbl_project_app/Hive/userdata.dart';
import 'package:pbl_project_app/auth/register.dart';
import 'package:pbl_project_app/shared/background.dart';
import 'package:pbl_project_app/shared/form_decoration.dart';
import 'package:pbl_project_app/user/userhome.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Login> {
  //variables
  String email, password, userid, usertype;
  List user = ['Teacher', 'Student'];
  bool hidepassword = true, rememberme = false;
  final userbox = Hive.box('currentuser');

  //functions
  Future<bool> login() async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        userid = result.user.uid;
      });
      if (rememberme) {
        await userbox.add(Userinfo(userid: userid, usertype: usertype));
      }
      return true;
    } catch (e) {
      Navigator.pop(context);
      Alert(
          context: context,
          title: 'Login Error',
          desc: e.message,
          buttons: []).show();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          'Login',
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
              Container(
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
                    SizedBox(
                      height: 20,
                    ),
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
                    SizedBox(height: 10),
                    Text(
                      'What type of User are you?',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: DropdownButton(
                        iconEnabledColor: Colors.black,
                        underline: Container(),
                        hint: Text(
                          'Select User Type:',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                          ),
                        ),
                        isExpanded: true,
                        items: user.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                            usertype = chosen;
                          });
                        },
                        value: usertype,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: rememberme,
                          onChanged: (value) {
                            setState(() {
                              rememberme = value;
                            });
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ],
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
                          if (email != null &&
                              password != null &&
                              usertype != null) {
                            Alert(
                                context: context,
                                style: AlertStyle(
                                  backgroundColor: Colors.white,
                                ),
                                title: "Please wait",
                                desc: "Loggin user in...",
                                buttons: [],
                                content: Container(
                                  child: SpinKitCircle(color: Colors.blue),
                                )).show();
                            bool status = await login();
                            if (status) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserHome(
                                            userid: userid,
                                            usertype: usertype,
                                          )),
                                  (route) => false);
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
                          'Login',
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
                      'Still not a User?',
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
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ));
                        },
                        child: Text(
                          'Register',
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
            ],
          )),
        ),
      ),
    );
  }
}
