import 'package:flutter/material.dart';

class Dailog extends StatelessWidget {
  const Dailog({
    Key key,
    @required this.msg,
    @required this.code,
  }) : super(key: key);

  final msg;
  final code;
  @override
  Widget build(BuildContext context) {
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
      },
    );
  }
}
