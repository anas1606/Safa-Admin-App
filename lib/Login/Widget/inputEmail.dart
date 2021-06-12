import 'package:flutter/material.dart';

class InputEmail extends StatefulWidget {
  InputEmail({Key key, @required this.textController}) : super(key: key);

  final TextEditingController textController;
  @override
  _InputEmailState createState() => _InputEmailState();
}

class _InputEmailState extends State<InputEmail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          cursorColor: Colors.white,
          controller: widget.textController,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white70,
              ),
            ),
            fillColor: Colors.lightBlueAccent,
            labelText: 'Name',
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
