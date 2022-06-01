import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:admin_taluka/util.dart';
import 'package:admin_taluka/consts.dart';

class forgotPasswordScreen extends StatefulWidget {
  static String id = "forgotPasswordscreen";
  @override
  _forgotPasswordScreenState createState() => _forgotPasswordScreenState();
}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  final _formforgotPasswordKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  bool onPressedforgotPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formforgotPasswordKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return msgEnterEmail;
                  }
                  email = value;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: labelAdminEmail,
                  hintText: msgEnterEmail,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  elevation: 5.0,
                  child: MaterialButton(
                    splashColor: clrBSplash,
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      labelForgotPassword,
                    ),
                    onPressed: () async {
                      if (_formforgotPasswordKey.currentState!.validate() &&
                          onPressedforgotPassword == false) {
                        onPressedforgotPassword = true;
                        //Implement registration functionality.
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email)
                              .then(
                                (value) async {},
                              );
                          popAlert(
                              context,
                              kTitleForgotPasswordMailSent,
                              kSubTitleForgotPasswordMailSent,
                              getRightIcon(),
                              2);
                        } catch (e) {
                          onPressedforgotPassword = false;
                          popAlert(
                            context,
                            kTitleFail,
                            e.toString(),
                            getWrongIcon(),
                            2,
                          );
                          return;
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
