import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/detailPage.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/iteamCard.dart';

class ProductBody extends StatefulWidget {
  ProductBody({key, @required this.names, @required this.model})
      : super(key: key);

  final List<String> names;
  final List<String> model;
  @override
  _ProductBodyState createState() => _ProductBodyState(names, model);
}

class _ProductBodyState extends State<ProductBody> {
  _ProductBodyState(List<String> names, List<String> model) {
    this.names = names;
    this.model = model;
  }
  @override
  void initState() {
    super.initState();
    dropDown = model[0];
  }

  List<String> names;
  List<String> model;
  int selectedindex = 0;
  String dropDown;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
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
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: GridView.builder(
                  itemCount: names.length * 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 15),
                  itemBuilder: (context, index) => IteamCard(
                      press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contex) => DetailPage()),
                          ))),
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
        iconSize: 40,
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
