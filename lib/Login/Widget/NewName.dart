import 'package:flutter/material.dart';

class NewNome extends StatefulWidget {
  NewNome({Key key, @required this.textController}) : super(key: key);

  final TextEditingController textController;
  @override
  _NewNomeState createState() => _NewNomeState();
}

class _NewNomeState extends State<NewNome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
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
            labelText: 'First Name',
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
