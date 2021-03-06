import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ButtonNewUser extends StatefulWidget {
  ButtonNewUser({
    key,
    @required this.flag,
    @required this.callback,
  }) : super(key: key);

  final bool flag;
  final Function callback;
  @override
  _ButtonNewUserState createState() => _ButtonNewUserState();
}

class _ButtonNewUserState extends State<ButtonNewUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.blueGrey[500],
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              2.0, // horizontal, move right 10
              3.0, // vertical, move down 10
            ),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: FlatButton(
          onPressed: () {
            widget.callback();
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
              (widget.flag)
                  ? Icon(
                      Icons.arrow_forward,
                      color: Colors.blueGrey[700],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SpinKitHourGlass(
                        size: 20,
                        duration: Duration(seconds: 10),
                        color: Colors.blueGrey[900],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
