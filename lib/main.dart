import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/Produts.dart';
import 'package:safa_admin/DashBoard%20Internals/category.dart';
import 'package:safa_admin/Dashboard.dart';
import 'package:safa_admin/Login/LoginPage.dart';
import 'package:safa_admin/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Safa Admin App",
      home: MyHomePage(),
      routes: {
        'dasboard': (context) => Dashboard(),
        'category': (context) => Category(),
        'loginpage': (context) => LoginPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String storedSession;
  getSessionToken() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var session = pref.getString('session');
      storedSession = session;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void startTimer() {
    Timer(Duration(milliseconds: 5400), () {
      try {
        if (storedSession == null)
          Navigator.of(context).pushReplacementNamed("loginpage");
        else
          Navigator.of(context).pushReplacementNamed("dasboard");
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSessionToken();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
