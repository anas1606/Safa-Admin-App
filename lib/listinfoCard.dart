import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Decoraters/GradiantText.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class ListInfoCard extends StatefulWidget {
  ListInfoCard({
    Key key,
    @required this.callback,
    @required this.ondeletepress,
    @required this.id,
    @required this.title,
    @required this.status,
    @required this.icone,
  }) : super(key: key);

  String id;
  String title;
  String status;
  final IconData icone;
  final GestureTapCallback ondeletepress;
  final Function(String id, String status) callback;

  @override
  _ListInfoCardState createState() => _ListInfoCardState();
}

class _ListInfoCardState extends State<ListInfoCard> {
  final _textController = TextEditingController();
  final prefix = "http://ec2-23-23-12-171.compute-1.amazonaws.com";
  var token =
      "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhbmFzQGdtYWlsLmNvbSIsInJvbGUiOlsiVVNFUiJdLCJ1c2VyVHlwZSI6WyJVU0VSIl0sImV4cCI6MTYyMzgzNTEzOSwiaWF0IjoxNjIzMjMwMzM5LCJhdXRob3JpdGllcyI6WyJBRE1JTiJdfQ.U_Upnd6cKgGuOeFpJxdOiF_7cI9SiwWJJAaI0ITTGjIOmQAQXS_cmHDPczuSc53Iwvn-ToWhq1JzcW3EO1rvtA";

  var data;

  updateCategory(String id, String status) async {
    var url = "$prefix/api/admin/category/update/?id=$id&status=$status";
    await http.put(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  @override
  void initState() {
    super.initState();
    setStatus();
  }

  Color statuscolor = Colors.red;
  setStatus() {
    setState(() {
      if (widget.status != "ACTIVE")
        statuscolor = Colors.red;
      else
        statuscolor = Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15.0,
      shadowColor: Colors.blueGrey[900],
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey[900],
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
            )
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Icon(
                widget.icone,
                color: Colors.white30,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Icon(
                Icons.circle,
                color: statuscolor,
                size: 15,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                showDialog(
                    context: context,
                    builder: (context) {
                      String flag = widget.status;
                      _textController.text = widget.title;
                      statuscolor =
                          (flag == "ACTIVE") ? Colors.green : Colors.red;
                      return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                        return FittedBox(
                          child: Dialog(
                            backgroundColor: Colors.transparent,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 400,
                                  width: 300,
                                  margin: EdgeInsets.only(
                                      top: 30, left: 10, right: 10),
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
                                          left: 50.0,
                                        ),
                                        child: GradientText(
                                          "Category",
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
                                        "-: NAME :-",
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
                                                  EdgeInsets.symmetric(
                                                      vertical: 0.0),
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
                                      GradientText(
                                        "-: STATUS :-",
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
                                      Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              height: 40,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    statuscolor,
                                                    statuscolor
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: TextButton(
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                setState(() {
                                                  if (flag == "ACTIVE") {
                                                    statuscolor = Colors.red;
                                                    flag = "DEACTIVATE";
                                                  } else {
                                                    statuscolor = Colors.green;
                                                    flag = "ACTIVE";
                                                  }
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                primary: Colors.white,
                                                textStyle: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                              child: Text(
                                                flag,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                                  "Update Category",
                                                  context,
                                                  duration: Toast.LENGTH_SHORT,
                                                  gravity: Toast.BOTTOM,
                                                  backgroundColor: Colors.green,
                                                );

                                                widget.status = flag;
                                                widget.title =
                                                    _textController.text;
                                                Navigator.pop(context);
                                                widget.callback(
                                                    widget.id, flag);
                                                setStatus();
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
                                Positioned(
                                  top: 0,
                                  right: 240,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        "https://media.giphy.com/media/xTiTnqJm8Arg3mmSOY/source.gif"),
                                    foregroundColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
              child: Icon(Icons.edit_outlined, color: Colors.cyan[700]),
            ),
            SizedBox(
              width: 35,
            ),
            GestureDetector(
              onTap: widget.ondeletepress ??
                  () {
                    HapticFeedback.heavyImpact();
                    showDialog(
                      context: context,
                      builder: (contex) {
                        return AlertDialog(
                          buttonPadding: EdgeInsets.all(15),
                          backgroundColor: Colors.blueGrey[900],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          title: Row(
                            children: [
                              Icon(
                                Icons.dangerous,
                                size: 30,
                                color: Colors.red,
                              ),
                              Text(
                                "  Delete",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Are You Sure ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                "It Will remove all related iteams from product List.",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            RaisedButton(
                              color: Colors.green,
                              child: Text("Confirm",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            RaisedButton(
                              color: Colors.red,
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => Navigator.pop(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                          ],
                        );
                      },
                    );
                  },
              child: Icon(
                Icons.delete_forever,
                color: Colors.deepOrange[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
