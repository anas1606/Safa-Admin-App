import 'package:flutter/material.dart';
import 'package:safa_admin/Login/Widget/NewLname.dart';
import 'Widget/BUttonNewuser.dart';
import 'Widget/NewEmail.dart';
import 'Widget/NewName.dart';
import 'Widget/SignUp.dart';
import 'Widget/UserOld.dart';
import 'Widget/passwordInput.dart';
import 'Widget/textNew.dart';

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
  final _textController = TextEditingController();
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
                NewNome(),
                NewLNome(),
                NewEmail(),
                PasswordInput(textController: _textController),
                ButtonNewUser(),
                if (widget.showSignIn) UserOld(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
