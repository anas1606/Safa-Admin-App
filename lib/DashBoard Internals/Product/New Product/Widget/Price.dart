import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Price extends StatefulWidget {
  Price({Key key, @required this.textController}) : super(key: key);

  final TextEditingController textController;
  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 100,
        child: TextField(
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          controller: widget.textController,
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 20
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
            labelText: 'Price *',
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
