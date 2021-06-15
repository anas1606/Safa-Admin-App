import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashBoardDesign extends StatefulWidget {
  DashBoardDesign({Key key}) : super(key: key);

  @override
  _DashBoardDesignState createState() => _DashBoardDesignState();
}

class _DashBoardDesignState extends State<DashBoardDesign> {
  String token;
  final prefix = "http://ec2-52-21-110-171.compute-1.amazonaws.com";
  var data;
  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var session = pref.getString('session');
    token = session;
  }

  validateReq(var data) async {
    if (data["statusCode"] == 401) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('session');
      Navigator.of(context)
          .pushNamedAndRemoveUntil("loginpage", (route) => false);
    } else if (data["statusCode"] == null) {
      Dialog(data["message"], data["status"], "Error");
    } else if (data["statusCode"] != 200) {
      Dialog(data["message"], data["statusCode"], "Somthing Worng");
    }
  }

  getData() async {
    var url = "$prefix/api/admin/dasboard";
    var res = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    data = jsonDecode(res.body);
    validateReq(data);
    setState(() {
      data = data["data"];
    });
  }

  startUP() async {
    await getToken();
    await getData();
  }

  @override
  void initState() {
    super.initState();
    startUP();
  }

  Widget _buildSingleContainer(
      {IconData icon,
      String text,
      int count,
      BuildContext contex,
      String route}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        elevation: 20,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            gradient: LinearGradient(
              colors: [Colors.blueGrey[900], Colors.blueGrey[900]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [Colors.black12, Colors.black12]),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.blueGrey[800],
                      size: 30,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GradientText(
                        text,
                        gradient: LinearGradient(
                          colors: [Colors.blue[400], Colors.purple[300]],
                        ),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "kalam",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GradientText(
                        count.toString(),
                        gradient: LinearGradient(
                          colors: [Colors.blue[400], Colors.purple[300]],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: <Widget>[
          _buildSingleContainer(
            icon: Icons.category,
            text: "Category",
            count: data["category"],
            contex: context,
            route: "category",
          ),
          _buildSingleContainer(
            icon: Icons.car_repair,
            text: "Vehicle Name",
            count: data["vehiclename"],
            contex: context,
            route: "vahiclename",
          ),
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: SpinKitFadingGrid(
          color: Colors.white60,
          size: 50.0,
          shape: BoxShape.rectangle,
        ),
      );
    }
  }

  Dialog(String msg, int code, String header) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.all(15),
            backgroundColor: Colors.blueGrey[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  size: 30,
                  color: Colors.yellow,
                ),
                Text(
                  "  $header",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              ],
            ),
            content: Text(
              "$msg \nErrorCode: $code",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text("Ok", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ],
            actionsPadding: EdgeInsets.only(right: 100),
          );
        });
  }
}
