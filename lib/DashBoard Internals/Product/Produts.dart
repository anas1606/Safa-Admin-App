import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/ProductBody.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  Product({Key key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String cat;
  String veh;
  String mod;

  final prefix = "http://ec2-52-21-110-171.compute-1.amazonaws.com";
  var data;
  var result;
  String token;
  List<String> categoryList;
  var category;
  List<String> vehicleList;
  var vehicle;
  List<String> modelList;
  var model;

  gettoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var session = pref.getString('session');
    token = session;
  }

  validateReq(var data) async {
    if (data["statusCode"] == 401) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('session');
      Navigator.of(context)
          .pushNamedAndRemoveUntil("loginpage", (route) => false);
    } else if (data["statusCode"] == null) {
      PopUpDialog(data["message"], data["status"], "Error");
    } else if (data["statusCode"] != 200) {
      PopUpDialog(data["message"], data["statusCode"], "Somthing Worng");
    }
  }

  refreshData() async {
    await getVehicleNameList();
    veh = vehicleList[0];
    await getModelList();
    mod = modelList[0];
    await getdata();
  }

  refreshModelData() async {
    await getModelList();
    mod = modelList[0];
    await getdata();
  }

  getdata() async {
    try {
      var url = "$prefix/api/admin/model/get/list/$veh";
      var res = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });
      data = jsonDecode(res.body);
      validateReq(data);
      setState(() {
        result = data["result"];
        data = data["data"];
      });
    } catch (e) {
      print(e);
    }
  }

  getCategoryList() async {
    try {
      var url = "$prefix/api/admin/category/list/name";
      var res = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });

      category = jsonDecode(res.body);
      validateReq(category);

      setState(() {
        categoryList = new List<String>.from(category["data"]);
      });
    } catch (e) {
      print(e);
    }
  }

  getVehicleNameList() async {
    try {
      var url = "$prefix/api/admin/vehiclename/get/names/$cat";
      var res = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });

      vehicle = jsonDecode(res.body);
      validateReq(vehicle);
      setState(() {
        if (vehicle["data"].isNotEmpty)
          vehicleList = new List<String>.from(vehicle["data"]);
        else
          vehicleList.add("NO DATA");
      });
    } catch (e) {
      print(e);
    }
  }

  getModelList() async {
    try {
      var url = "$prefix/api/admin/model/get/names/$veh";
      var res = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });

      model = jsonDecode(res.body);
      validateReq(model);
      setState(() {
        if (model["data"].isNotEmpty)
          modelList = new List<String>.from(model["data"]);
        else
          modelList.add("NO DATA");
      });
    } catch (e) {
      print(e);
    }
  }

  startup() async {
    await gettoken();
    await getCategoryList();
    cat = categoryList.contains("TRUCK") ? "TRUCK" : categoryList[0];
    await getVehicleNameList();
    veh = vehicleList.contains("EICHER") ? "EICHER" : vehicleList[0];
    await getModelList();
    mod = vehicleList[0];
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.blueGrey[900],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: (categoryList != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    iconSize: 40,
                    icon: Icon(Icons.arrow_drop_down_sharp),
                    iconEnabledColor: Colors.white70,
                    value: cat,
                    dropdownColor: Colors.blueGrey[900],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.5,
                    ),
                    items: categoryList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      HapticFeedback.heavyImpact();
                      setState(() {
                        cat = newValue;
                        veh = "NO DATA";
                        mod = "NO DATA";
                        vehicleList = [];
                        modelList = [];
                        data = null;
                        refreshData();
                      });
                    },
                  )
                ],
              )
            : SpinKitRipple(
                color: Colors.white60,
                size: 40.0,
              ),
        elevation: 15.0,
        shadowColor: Colors.blueGrey[550],
      ),
      body: (vehicleList != null && modelList != null)
          ? (vehicleList.length != 0 && modelList.length != 0)
              ? ProductBody(
                  names: vehicleList,
                  model: modelList,
                  data: data,
                  vehname: veh,
                  modelname: mod,
                  vehicleChange: (String name) {
                    setState(() {
                      veh = name;
                      data = null;
                      mod = "NO DATA";
                      modelList = [];
                      refreshModelData();
                    });
                  },
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
                )
          /*Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 300,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blueGrey[900],
                      child: Center(
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
                      ),
                    ),
                  ],
                )*/
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.heavyImpact();
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        elevation: 20,
        backgroundColor: Colors.teal[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      resizeToAvoidBottomInset: true,
    );
  }

  PopUpDialog(String msg, int code, String header) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.all(15),
            backgroundColor: Colors.blueGrey[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  size: 30,
                  color: Colors.yellow,
                ),
                Text(
                  "  $header",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              ],
            ),
            content: Text(
              "$msg \nErrorCode: $code",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text("Ok", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ],
            actionsPadding: EdgeInsets.only(right: 100),
          );
        });
  }
}

List<String> getlist() {
  List<String> a = ["TRUCK", "CAR", "TRACTOR", "JEEP"];
  return a;
}
