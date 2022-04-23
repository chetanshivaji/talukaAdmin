import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'myApp.dart';

import 'screen/reportInfo.dart';
import 'screen/welcome_login/login_screen.dart';
import 'screen/welcome_login/registration_screen.dart';
import 'screen/welcome_login/welcome_screen.dart';
import 'screen/welcome_login/forgotPassword.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      // Replace with actual values
      options: FirebaseOptions(
        apiKey: "AIzaSyAxXZsweakuYy5HBQnsU5tmlUVq7rp4gzk",
        appId: "1:221118467263:android:93a0115c427c05eca94a0a",
        messagingSenderId: "221118467263",
        projectId: "gramtry-7a07a",
      ),
    );
  } catch (e) {
    print(e);
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Admin",
      initialRoute: WelcomeScreen.id,
      routes: {
        MyApp.id: (context) => MyApp(),
        reportInfo.id: (context) => reportInfo(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        forgotPasswordScreen.id: (context) => forgotPasswordScreen(),
      },
    ),
  );
}
