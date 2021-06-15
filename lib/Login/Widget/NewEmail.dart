import 'package:flutter/material.dart';

class NewEmail extends StatefulWidget {
  NewEmail({Key key, @required this.textController}) : super(key: key);

  final TextEditingController textController;
  @override
  _NewEmailState createState() => _NewEmailState();
}

class _NewEmailState extends State<NewEmail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: widget.textController,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white70,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white70,
              ),
            ),
            fillColor: Colors.lightBlueAccent,
            labelText: 'E-mail',
            labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
