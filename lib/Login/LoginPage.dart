import 'package:flutter/material.dart';
import 'Widget/FirstTime.dart';
import 'Widget/TextLogin.dart';
import 'Widget/VerticalText.dart';
import 'Widget/button.dart';
import 'Widget/inputEmail.dart';
import 'Widget/passwordInput.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailtextController = TextEditingController();
  final _passwordtextController = TextEditingController();

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
                Row(children: <Widget>[
                  VerticalText(),
                  TextLogin(),
                ]),
                InputEmail(textController: _emailtextController),
                PasswordInput(textController: _passwordtextController),
                ButtonLogin(
                  email: _emailtextController,
                  pswd: _passwordtextController,
                ),
                FirstTime(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
