import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:safa_admin/Global.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonLogin extends StatefulWidget {
  ButtonLogin({
    Key key,
    @required this.email,
    @required this.pswd,
  }) : super(key: key);

  final TextEditingController email;
  final TextEditingController pswd;
  @override
  _ButtonLoginState createState() => _ButtonLoginState();
}

class _ButtonLoginState extends State<ButtonLogin> {
  final prefix = GlobelValue.prefix;
  var data;
  bool processFlag = true;

  setToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('session', token);
    });
  }

  setName(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('name', name);
    });
  }

  login() async {
    setState(() {
      processFlag = false;
    });

    var url = "$prefix/api/admin/login";
    var res = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'emailId': widget.email.text,
          'password': widget.pswd.text
        }));

    data = jsonDecode(res.body);

    setState(() {
      if (data["statusCode"] == 200) {
        data = data["data"];
        setToken(data["sessionToken"]);
        setName(data["firstName"] + " " + data["lastName"]);
        Navigator.of(context).pushReplacementNamed("dasboard");
      } else
        Dialog(data["message"], data["statusCode"]);

      processFlag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey[500],
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                2.0, // horizontal, move right 10
                3.0, // vertical, move down 10
              ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FlatButton(
          onPressed: () {
            print(widget.email.text);
            print(widget.pswd.text);
            login();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'OK',
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              (processFlag)
                  ? Icon(
                      Icons.arrow_forward,
                      color: Colors.blueGrey[700],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SpinKitHourGlass(
                        size: 20,
                        duration: Duration(seconds: 1),
                        color: Colors.blueGrey[900],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Dialog(String msg, int code) {
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
                  "  Invalid User Detail",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              ),
            ],
          );
        });
  }
}
