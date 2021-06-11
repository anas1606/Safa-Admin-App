import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safa_admin/DashBoard%20Internals/category.dart';
import 'package:safa_admin/Dashboard.dart';
import 'package:safa_admin/Login/LoginPage.dart';
import 'package:safa_admin/splashScreen.dart';

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
  void startTimer() {
    Timer(Duration(milliseconds: 5400), () {
      Navigator.of(context).pushReplacementNamed("loginpage");
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
