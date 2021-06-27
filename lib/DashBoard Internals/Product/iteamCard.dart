import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IteamCard extends StatefulWidget {
  IteamCard({
    Key key,
    @required this.press,
    @required this.data,
  }) : super(key: key);

  var data;
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
      child: Card(
        color: Colors.transparent,
        elevation: 20,
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
                child: (widget.data["coverImageUrl"] != null)
                    ? CachedNetworkImage(
                        imageUrl: widget.data["coverImageUrl"],
                        placeholder: (context, url) =>
                            SpinKitCircle(color: Colors.white24),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: Colors.white10,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                widget.data["productName"],
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    "Rs  " + widget.data["rate"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    widget.data["type"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
