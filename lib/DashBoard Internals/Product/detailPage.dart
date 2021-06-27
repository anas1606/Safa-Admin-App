import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:toast/toast.dart';

class DetailPage extends StatefulWidget {
  DetailPage({
    Key key,
    @required this.data,
    @required this.vehiclename,
    @required this.model,
  }) : super(key: key);

  var data;
  final String vehiclename;
  final String model;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.blueGrey[900],
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: GradientText(
              "Detail Page",
              gradient: LinearGradient(
                colors: [
                  Colors.blue[400],
                  Colors.purple[500],
                ],
              ),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFamily: "fugzOne"),
            ),
          ),
        ),
        elevation: 15.0,
        centerTitle: true,
        shadowColor: Colors.blueGrey[550],
        automaticallyImplyLeading: false,
      ),
      body: (widget.data != null)
          ? SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.12,
                        left: 20,
                      ),
                      //height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white12, Colors.transparent],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Brand",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      widget.vehiclename,
                                      style: TextStyle(
                                        color: Colors.cyan[400],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Model",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      widget.model,
                                      style: TextStyle(
                                        color: Colors.cyan[400],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Type",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      widget.data["type"],
                                      style: TextStyle(
                                        color: Colors.cyan[400],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Container(
                              height: 200,
                              width: 370,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white38),
                              ),
                              child: Container(
                                child: buildImagesGridView(getList()),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data["productName"],
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: Colors.white54,
                                    fontFamily: "fugzOne"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Price\n",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                color: Colors.white54,
                                                fontFamily: "fugzOne"),
                                      ),
                                      TextSpan(
                                        text: "Rs " + widget.data["rate"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                color: Colors.amber[300],
                                                fontFamily: "fugzOne"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 2.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      showDialog(
                                          context: context,
                                          builder: (contex) {
                                            return priceDailog();
                                          });
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white54,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 95 / 100,
                                  child: SizedBox(
                                    height: 200,
                                    child: (widget.data["coverImageUrl"] ==
                                            null)
                                        ? Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 200,
                                            color: Colors.white24)
                                        : Image.network(
                                            widget.data["coverImageUrl"],
                                            fit: BoxFit.scaleDown,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blueGrey[900],
              child: SpinKitFadingGrid(
                color: Colors.white60,
                size: 50.0,
                shape: BoxShape.rectangle,
              ),
            ),
    );
  }

  Widget buildImagesGridView(List<String> images) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 100 / 100,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index == images.length)
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 50,
              color: Colors.white30,
            ),
          );
        else
          return Container(child: Image.asset(images[index]));
      },
    );
  }

  Widget priceDailog() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        _textController.text = widget.data["rate"];
        return FittedBox(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 300,
                  width: 300,
                  margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 20.0,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 20.0,
                        ),
                        child: GradientText(
                          "Update Price",
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[400],
                              Colors.purple[500],
                            ],
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontFamily: "fugzOne"),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GradientText(
                        "-: Rate :-",
                        gradient: LinearGradient(
                          colors: [
                            Colors.white60,
                            Colors.white60,
                          ],
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontFamily: "kalam",
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 50,
                          left: 50,
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _textController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontFamily: "kalam",
                            ),
                            decoration: InputDecoration(
                              // to put thext in center
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0.0),
                              border: OutlineInputBorder(),
                              filled: true,
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                fontFamily: "kalam",
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.done),
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                Toast.show(
                                  "Price Updated",
                                  context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM,
                                  backgroundColor: Colors.green,
                                );
                                Navigator.pop(context);
                              },
                              color: Colors.green,
                              alignment: Alignment.center,
                              iconSize: 40.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                Toast.show(
                                  "Canceled",
                                  context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM,
                                  backgroundColor: Colors.red,
                                );
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                              alignment: Alignment.center,
                              iconSize: 40.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<String> getList() {
  return [
    "asset/pic2.jpeg",
    "asset/pic2.jpeg",
    "asset/pic2.jpeg",
    "asset/fender.png",
    "asset/jam.jpeg",
    "asset/fender.jpeg"
  ];
}
