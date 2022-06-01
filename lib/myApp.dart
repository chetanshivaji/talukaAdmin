import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:admin_taluka/screen/reportInfo.dart';

import 'package:admin_taluka/util.dart';
import 'package:admin_taluka/consts.dart';

class MyApp extends StatelessWidget {
  static String id = "myappscreen";
  bool drawerOpen = false;

  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (drawerOpen == true) {
          Navigator.pop(context);
        }

        popLogOutAlert(
          context,
          kTitleSignOut,
          kSubtitleLogOutConfirmation,
          Icon(Icons.power_settings_new),
        );
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        onDrawerChanged: (isOpen) {
          drawerOpen = isOpen;
        },
        appBar: AppBar(
          title: Text(appBarMainAppInfo),
          actions: <Widget>[
            IconButton(
              splashColor: clrIconSpalsh,
              splashRadius: iconSplashRadius,
              tooltip: kTitleSignOut,
              onPressed: () {
                //logout
                popLogOutAlert(
                    context,
                    kTitleSignOut,
                    kSubtitleLogOutConfirmation,
                    Icon(Icons.power_settings_new));
              },
              icon: Icon(Icons.power_settings_new),
            ),
          ],
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Stack(
                  children: <Widget>[
                    Text(
                      dHeading,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.yellow,
                      ),
                    ), //gree
                  ],
                ),
              ),
              ListTile(
                shape: getListTileShapeForDrawer(),
                leading: Icon(Icons.report),
                title: Text(dReport),
                tileColor: clrRed, //red
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (onPressedDrawerReport == false) {
                    onPressedDrawerReport = true;
                    Navigator.pushNamed(context, reportInfo.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
