import 'package:flutter/material.dart';

class NewLNome extends StatefulWidget {
  NewLNome({Key key, @required this.textController}) : super(key: key);

  final TextEditingController textController;
  @override
  _NewLNomeState createState() => _NewLNomeState();
}

class _NewLNomeState extends State<NewLNome> {
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
            labelText: 'Last Name',
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
