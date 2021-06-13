import 'package:flutter/material.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                height: 600,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FENDER",
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          color: Colors.white54, fontFamily: "fugzOne"),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Price\n"),
                              TextSpan(
                                  text: "Rs 5000",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(
                                          color: Colors.white70,
                                          fontFamily: "fugzOne")),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Icon(
                            Icons.image_outlined,
                            size: 250,
                            color: Colors.black,
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
      ),
    );
  }
}
