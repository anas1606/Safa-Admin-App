import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int flag = 0;
  double percent = 0.0;

  void timer() {
    Timer timer;
    timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        percent += 10.0;
        if (percent >= 100) {
          timer.cancel();
          flag = 1;
          percent = 100;
        }
      });
    });
  }

  @override
  void initState() {
    timer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey[900]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage("asset/splash/safalogo.png"),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        "SAFA ENTERPRISE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                        ),
                      )
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      flag == 0
                          ? CircularProgressIndicator(
                              strokeWidth: 10,
                              backgroundColor: Colors.teal,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightGreen),
                            )
                          : CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.green[800],
                              child: Icon(
                                Icons.done_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                      flag == 0
                          ? Padding(padding: EdgeInsets.only(top: 50))
                          : Padding(padding: EdgeInsets.only(top: 36)),
                      Text(
                        "Getting Information \n From Server",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LinearPercentIndicator(
                        alignment: MainAxisAlignment.center,
                        animation: true,
                        animationDuration: 500,
                        lineHeight: 20.0,
                        width: MediaQuery.of(context).size.width - 50,
                        percent: percent / 100,
                        animateFromLastPercent: true,
                        center: Text(
                          percent.toString() + "%",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.green[800],
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
