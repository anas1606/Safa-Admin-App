import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/ProductBody.dart';

class Product extends StatefulWidget {
  Product({Key key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String dropDown = getlist()[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.blueGrey[900],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
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
              items: getlist().map((String value) {
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
            )
          ],
        ),
        elevation: 15.0,
      ),
      body: ProductBody(names: getlist(), model: getlist()),
    );
  }
}

List<String> getlist() {
  List<String> a = ["TRUCK", "CAR", "TRACTOR", "JEEP"];
  return a;
}
