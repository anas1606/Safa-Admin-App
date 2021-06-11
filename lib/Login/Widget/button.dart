import 'package:flutter/material.dart';

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
            if (widget.email.text == "admin" && widget.pswd.text == "unlock") {
              Navigator.of(context).pushReplacementNamed("dasboard");
            }
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
              Icon(
                Icons.arrow_forward,
                color: Colors.blueGrey[700],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
