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
      body: SingleChildScrollView(
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
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.white30, Colors.transparent],
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
                                "EICHER",
                                style: TextStyle(
                                  color: Colors.amberAccent,
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
                                "Pro 3110",
                                style: TextStyle(
                                  color: Colors.amberAccent,
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
                                "Weight",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "0.350 Kg",
                                style: TextStyle(
                                  color: Colors.amberAccent,
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
                      "FENDER",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white54, fontFamily: "fugzOne"),
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
                                            fontFamily: "fugzOne")),
                                TextSpan(
                                    text: "Rs 5000",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.amber[300],
                                            fontFamily: "fugzOne")),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 90 / 100,
                            child: SizedBox(
                                height: 200,
                                child: Image.asset("asset/fender2.png")),
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
