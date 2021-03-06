import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:safa_admin/Global.dart';
import 'package:safa_admin/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:safa_admin/listinfoCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Model extends StatefulWidget {
  Model({Key key}) : super(key: key);

  @override
  _ModelState createState() => _ModelState();
}

class _ModelState extends State<Model> {
  final _textController = TextEditingController();
  String dropDown;
  String dropDown2;
  final prefix = GlobelValue.prefix;
  var data;
  List<String> categoryList;
  List<String> vehicleList;
  var category;
  var vehicle;
  var result;

  String token;
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
      var url = "$prefix/api/admin/vehiclename/get/names/$dropDown";
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

  refreshData() async {
    await getVehicleNameList();
    dropDown2 = vehicleList[0];
    await getdata();
  }

  getdata() async {
    try {
      var url = "$prefix/api/admin/model/get/list/$dropDown2";
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

  addModel(String str) async {
    try {
      var url = "$prefix/api/admin/model/add";
      var res = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(
            <String, String>{
              'vehicleName': dropDown2,
              'modelName': str,
            },
          ));
      validateReq(jsonDecode(res.body));
      setState(() {
        getdata();
      });
    } catch (e) {
      print(e);
    }
  }

  updateModel(String id, String status) async {
    var url = "$prefix/api/admin/model/update";
    var res = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, String>{
          'modelId': id,
          'status': status,
        },
      ),
    );
    validateReq(jsonDecode(res.body));
    setState(() {
      getdata();
    });
  }

  deleteModel(String id) async {
    var url = "$prefix/api/admin/model/delete/$id";
    var res = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    validateReq(jsonDecode(res.body));
    setState(() {
      getdata();
    });
  }

  void startUp() async {
    await gettoken();
    await getCategoryList();
    dropDown = categoryList.contains("TRUCK") ? "TRUCK" : categoryList[0];
    await getVehicleNameList();
    dropDown2 = vehicleList.contains("EICHER") ? "EICHER" : vehicleList[0];
    await getdata();
  }

  @override
  void initState() {
    super.initState();
    startUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 15.0,
        brightness: Brightness.dark,
        backgroundColor: Colors.blueGrey[900],
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: GradientText(
            "Models",
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
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
        ),
        child: data != null && data.length > 0
            ? Column(
                children: <Widget>[
                  dropDownMenu(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Chart(
                    data: generateChartListData(result["Active"],
                        result["Deactivate"], result["total"]),
                    active: result["Active"],
                    total: result["total"],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListInfoCard(
                            id: data[index]["modelId"],
                            title: data[index]["modelName"],
                            icone: Icons.category,
                            status: data[index]["status"],
                            callback: (String id, String status) {
                              updateModel(id, status);
                            },
                            ondeletepress: () {
                              HapticFeedback.heavyImpact();
                              showDialog(
                                context: context,
                                builder: (contex) {
                                  return AlertDialog(
                                    buttonPadding: EdgeInsets.all(15),
                                    backgroundColor: Colors.blueGrey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          //data.removeAt(index);
                                          deleteModel(data[index]["modelId"]);
                                          Toast.show(
                                            "Model Deleted",
                                            context,
                                            duration: 1,
                                            gravity: Toast.BOTTOM,
                                            backgroundColor: Colors.green,
                                          );
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                      RaisedButton(
                                        color: Colors.red,
                                        child: Text("Cancel",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Toast.show(
                                            "Canceled",
                                            context,
                                            duration: 1,
                                            gravity: Toast.BOTTOM,
                                            backgroundColor: Colors.red,
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            : (data != null && data.length == 0)
                ? Column(
                    children: [
                      dropDownMenu(),
                      Container(
                        height: MediaQuery.of(context).size.height - 300,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
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
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: SpinKitFadingGrid(
                      color: Colors.white60,
                      size: 50.0,
                      shape: BoxShape.rectangle,
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.heavyImpact();
          showDialog(
              context: context,
              builder: (context) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 300,
                            width: 400,
                            margin:
                                EdgeInsets.only(top: 30, left: 10, right: 10),
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
                                  padding: const EdgeInsets.all(8.0),
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
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                        fontFamily: "fugzOne"),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
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
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontFamily: "kalam",
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                      autofocus: true,
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
                                  height: 30,
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
                                            "New Category Created",
                                            context,
                                            duration: 1,
                                            gravity: Toast.BOTTOM,
                                            backgroundColor: Colors.green,
                                          );
                                          addModel(_textController.text);
                                          _textController.text = "";
                                          Navigator.pop(context);
                                        },
                                        color: Colors.green,
                                        alignment: Alignment.center,
                                        iconSize: 50.0,
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
                                            duration: 1,
                                            gravity: Toast.BOTTOM,
                                            backgroundColor: Colors.red,
                                          );
                                          _textController.text = "";
                                          Navigator.pop(context);
                                        },
                                        color: Colors.red,
                                        alignment: Alignment.center,
                                        iconSize: 50.0,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              });
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
      resizeToAvoidBottomInset: false,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              ),
            ],
          );
        });
  }

  dropDownMenu() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Cat ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: DropdownButton<String>(
                iconSize: 20,
                icon: Icon(Icons.arrow_drop_down_sharp),
                iconEnabledColor: Colors.white70,
                value: dropDown,
                dropdownColor: Colors.blueGrey[900],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
                    dropDown = newValue;
                    vehicleList = [];
                    dropDown2 = "NO DATA";
                    data = null;
                    refreshData();
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Names ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: DropdownButton<String>(
                iconSize: 20,
                icon: Icon(Icons.arrow_drop_down_sharp),
                iconEnabledColor: Colors.white70,
                value: dropDown2,
                dropdownColor: Colors.blueGrey[900],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.5,
                ),
                items: vehicleList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  HapticFeedback.heavyImpact();
                  setState(() {
                    dropDown2 = newValue;
                    data = null;
                    getdata();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> generateChartListData(
    int active, int deactive, int total) {
  int remain = (active + deactive) - total;
  List<PieChartSectionData> data = [
    PieChartSectionData(
      showTitle: true,
      color: Color(0xFF1CA33E),
      radius: 25,
      value: active.ceilToDouble(),
      title: active.toString(),
      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    PieChartSectionData(
      showTitle: true,
      color: Color(0xFFE71B25),
      radius: 25,
      value: deactive.ceilToDouble(),
      title: deactive.toString(),
      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    PieChartSectionData(
      showTitle: false,
      color: Colors.grey.withOpacity(0.2),
      radius: 25,
      value: remain.ceilToDouble().abs(),
    ),
  ];
  return data;
}
