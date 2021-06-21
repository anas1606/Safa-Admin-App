import 'package:flutter/material.dart';

class Name extends StatefulWidget {
  Name({Key key, @required this.textController}) : super(key: key);

  final TextEditingController textController;
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 20, right: 30),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          cursorColor: Colors.white,
          controller: widget.textController,
          textCapitalization: TextCapitalization.characters,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
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
            labelText: 'Name *',
            labelStyle: TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
