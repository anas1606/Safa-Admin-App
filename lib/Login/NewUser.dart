import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safa_admin/AlertDailog.dart';
import 'package:safa_admin/Login/Widget/NewLname.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'Widget/BUttonNewuser.dart';
import 'Widget/NewEmail.dart';
import 'Widget/NewName.dart';
import 'Widget/SignUp.dart';
import 'Widget/UserOld.dart';
import 'Widget/passwordInput.dart';
import 'Widget/textNew.dart';
import 'package:http/http.dart' as http;

class NewUser extends StatefulWidget {
  NewUser({
    key,
    @required this.showSignIn,
  }) : super(key: key);

  final bool showSignIn;
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final _fnametextController = TextEditingController();
  final _lnametextController = TextEditingController();
  final _emailtextController = TextEditingController();
  final _pswdtextController = TextEditingController();
  final prefix = "http://ec2-52-21-110-171.compute-1.amazonaws.com";
  bool processFlag = true;
  var data;
  String token;

  @override
  void initState() {
    super.initState();
    gettoken();
  }

  gettoken() async {
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

  addUser() async {
    setState(() {
      processFlag = false;
    });

    try {
      var url = "$prefix/api/admin/create/user";
      var res = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
          body: jsonEncode(<String, String>{
            'firstName': _fnametextController.text,
            'lastName': _lnametextController.text,
            'password': _pswdtextController.text,
            'email': _emailtextController.text
          }));
      data = jsonDecode(res.body);
      print(data.toString());
      validateReq(data);
      setState(() {
        if (data["statusCode"] == 200) {
          Toast.show(
            "New User Created",
            context,
            duration: 1,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.green,
          );
          _emailtextController.text = "";
          _fnametextController.text = "";
          _lnametextController.text = "";
          _pswdtextController.text = "";
        }
        processFlag = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey[900], Colors.blueGrey[700]]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SingUp(),
                    TextNew(),
                  ],
                ),
                NewNome(textController: _fnametextController),
                NewLNome(textController: _lnametextController),
                NewEmail(textController: _emailtextController),
                PasswordInput(textController: _pswdtextController),
                (processFlag)
                    ? ButtonNewUser(flag: true, callback: () => addUser())
                    : ButtonNewUser(flag: false, callback: () {}),
                if (widget.showSignIn) UserOld(),
              ],
            ),
          ],
        ),
      ),
    );
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
