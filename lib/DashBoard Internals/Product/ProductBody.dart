import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/detailPage.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/iteamCard.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';

class ProductBody extends StatefulWidget {
  ProductBody({
    key,
    @required this.names,
    @required this.model,
    @required this.data,
    @required this.vehicleChange,
    @required this.vehname,
    @required this.modelname,
  }) : super(key: key);

  final List<String> names;
  final List<String> model;
  final Function(String) vehicleChange;
  var data;
  final String vehname;
  final String modelname;
  @override
  _ProductBodyState createState() => _ProductBodyState(names, model);
}

class _ProductBodyState extends State<ProductBody> {
  _ProductBodyState(List<String> names, List<String> model) {
    this.names = names;
    this.model = model;
  }

  List<String> names;
  List<String> model;
  int selectedindex = 0;
  String dropDown;

  @override
  void initState() {
    super.initState();
    selectedindex = names.indexOf(widget.vehname);
    dropDown = model[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2),
            color: Colors.blueGrey[900],
            child: SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.names.length,
                itemBuilder: (context, index) => buildNames(index),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(2),
                  color: Colors.blueGrey[900],
                  child: SizedBox(
                    height: 35,
                    child: Center(
                      child: Text(
                        dropDown,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                color: Colors.blueGrey[900],
                child: modelDropDown(),
              ),
            ],
          ),
          Expanded(
            child: (widget.data != null)
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      itemCount: widget.data.length,
                      padding: EdgeInsets.only(top: 10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) => IteamCard(
                          data: widget.data[index],
                          press: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => DetailPage()),
                              )),
                    ),
                  )
                : (widget.data != null && widget.data.length == 0)
                    ? Center(
                        child: GradientText(
                          "NO DATA",
                          gradient: LinearGradient(
                            colors: [
                              Colors.white24,
                              Colors.white24,
                            ],
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontFamily: "fugzOne"),
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
          )
        ],
      ),
    );
  }

  Widget buildNames(int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        setState(() {
          selectedindex = index;
          widget.vehicleChange(names[index]);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                widget.names[index],
                style: TextStyle(
                  color: selectedindex == index ? Colors.white : Colors.white38,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              height: 2,
              width: 30,
              color: selectedindex == index ? Colors.white : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget modelDropDown() {
    return SizedBox(
      height: 35,
      child: DropdownButton<String>(
        iconSize: 20,
        icon: Icon(Icons.arrow_drop_down_sharp),
        iconEnabledColor: Colors.white70,
        value: dropDown,
        dropdownColor: Colors.blueGrey[900],
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 3.5,
        ),
        items: model.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (String newValue) {
          HapticFeedback.heavyImpact();
          setState(() {
            dropDown = newValue;
          });
        },
      ),
    );
  }
}
