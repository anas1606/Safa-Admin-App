import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IteamCard extends StatefulWidget {
  IteamCard({Key key, @required this.press}) : super(key: key);

  final Function press;
  @override
  _IteamCardState createState() => _IteamCardState();
}

class _IteamCardState extends State<IteamCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        widget.press.call();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              width: 170,
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset("asset/fender.png"),
              /*Icon(
                Icons.image_outlined,
                size: 80,
                color: Colors.white10,
              ),*/
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              "Front on left hand side of the",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              "Rs 5000",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
