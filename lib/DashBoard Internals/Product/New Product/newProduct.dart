import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/New%20Product/Widget/Name.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/New%20Product/Widget/Price.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class addnewProduct extends StatefulWidget {
  addnewProduct({Key key}) : super(key: key);

  @override
  _addnewProductState createState() => _addnewProductState();
}

class _addnewProductState extends State<addnewProduct> {
  final _NametextController = TextEditingController();
  final _PricetextController = TextEditingController();

  String dropDown = getList()[0];
  List<File> images = <File>[];
  File _img;
  File _coverImage;
  String cat;
  String vname;
  String mod;
  String type = getList()[0];
  var data;
  bool progress = false;

  final prefix = "http://ec2-52-21-110-171.compute-1.amazonaws.com";
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
      setState(() {
        progress = false;
      });
    } else if (data["statusCode"] != 200) {
      PopUpDialog(data["message"], data["statusCode"], "Somthing Worng");
      setState(() {
        progress = false;
      });
    }
  }

  addproduct() async {
    setState(() {
      progress = true;
    });
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    var url = "$prefix/api/admin/product/add";
    var req = await http.MultipartRequest('POST', Uri.parse(url));
    req.headers.addAll(header);
    req.fields['data'] = jsonEncode(<String, String>{
      "name": _NametextController.text,
      "rate": _PricetextController.text,
      "type": dropDown,
      "category": cat,
      "vehicleName": vname,
      "model": mod
    });
    if (images.length >= 1)
      req.files
          .add(await http.MultipartFile.fromPath('image1', images[0].path));
    if (images.length >= 2)
      req.files
          .add(await http.MultipartFile.fromPath('image2', images[1].path));
    if (images.length >= 3)
      req.files
          .add(await http.MultipartFile.fromPath('image2', images[2].path));
    if (images.length == 4)
      req.files
          .add(await http.MultipartFile.fromPath('image3', images[3].path));
    if (_coverImage != null)
      req.files.add(
          await http.MultipartFile.fromPath('coverimage', _coverImage.path));

    var res = await http.Response.fromStream(await req.send());
    data = jsonDecode(res.body);
    validateReq(data);
    setState(() {
      if (data["statusCode"] == 200) {
        progress = false;
        Toast.show(
          "Product Added",
          context,
          duration: 1,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    });
  }

  List<String> categoryList;
  var category;
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

  var vehicle;
  List<String> vehicleList;
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
      vehicleList = [];
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

  var model;
  List<String> modelList;
  getModelList() async {
    try {
      var url = "$prefix/api/admin/model/get/names/$vname";
      var res = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });
      model = jsonDecode(res.body);
      validateReq(model);
      modelList = [];
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

  refreshData() async {
    await getVehicleNameList();
    vname = vehicleList[0];
    await getModelList();
    mod = modelList[0];
    await getdata();
  }

  refreshModelData() async {
    await getModelList();
    mod = modelList[0];
    //await getdata();
  }

  getdata() async {
    setState(() {});
  }

  startup() async {
    await gettoken();
    await getCategoryList();
    cat = categoryList.contains("TRUCK") ? "TRUCK" : categoryList[0];
    await getVehicleNameList();
    vname = vehicleList.contains("EICHER") ? "EICHER" : vehicleList[0];
    await getModelList();
    mod = modelList[0];
    type = dropDown;
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  _imgFromCamera(bool flag) async {
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    setState(() {
      _img = File(image.path);
      if (flag)
        images.add(_img);
      else
        _coverImage = _img;
    });
  }

  _imgFromGallery(bool flag) async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    setState(() {
      _img = File(image.path);
      if (flag)
        images.add(_img);
      else
        _coverImage = _img;
    });
  }

  void _showPicker(context, bool flag) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery(flag);
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(flag);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        centerTitle: true,
        elevation: 15.0,
        brightness: Brightness.dark,
        backgroundColor: Colors.blueGrey[900],
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: GradientText(
            "Add Product",
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Category *",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white60,
                                  ),
                                ),
                                (categoryList != null)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: DropdownButton<String>(
                                            iconSize: 20,
                                            icon: Icon(
                                                Icons.arrow_drop_down_sharp),
                                            iconEnabledColor: Colors.white70,
                                            value: cat,
                                            dropdownColor: Colors.blueGrey[900],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 3.5,
                                            ),
                                            items: categoryList
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              HapticFeedback.heavyImpact();
                                              setState(() {
                                                cat = newValue;
                                                vname = "NO DATA";
                                                mod = "NO DATA";
                                                vehicleList = null;
                                                modelList = null;
                                                refreshData();
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SpinKitPulse(
                                          size: 40,
                                          color: Colors.white54,
                                        ),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Vehicle Name *",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white60,
                                  ),
                                ),
                                (vehicleList != null)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: DropdownButton<String>(
                                            iconSize: 20,
                                            icon: Icon(
                                                Icons.arrow_drop_down_sharp),
                                            iconEnabledColor: Colors.white70,
                                            value: vname,
                                            dropdownColor: Colors.blueGrey[900],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 3.5,
                                            ),
                                            items:
                                                vehicleList.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              HapticFeedback.heavyImpact();
                                              setState(() {
                                                vname = newValue;
                                                mod = "NO DATA";
                                                modelList = null;
                                                refreshModelData();
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SpinKitPulse(
                                          size: 40,
                                          color: Colors.white54,
                                        ),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Model *",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white60,
                                  ),
                                ),
                                (modelList != null)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: DropdownButton<String>(
                                            iconSize: 20,
                                            icon: Icon(
                                                Icons.arrow_drop_down_sharp),
                                            iconEnabledColor: Colors.white70,
                                            value: mod,
                                            dropdownColor: Colors.blueGrey[900],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 3.5,
                                            ),
                                            items:
                                                modelList.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              HapticFeedback.heavyImpact();
                                              setState(() {
                                                mod = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SpinKitPulse(
                                          size: 40,
                                          color: Colors.white54,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      width: 180,
                      child: Card(
                        color: Colors.blueGrey[900],
                        elevation: 20,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            _showPicker(context, false);
                          },
                          child: (_coverImage != null)
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.file(
                                        _coverImage,
                                        width: 180,
                                        height: 250,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Positioned(
                                      right: 1,
                                      top: 1,
                                      child: InkWell(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 25,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          HapticFeedback.heavyImpact();
                                          _coverImage = null;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.white24,
                                  size: 50,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Name(textController: _NametextController),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Price(textController: _PricetextController),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Type *",
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
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
                            items: getList().map((String value) {
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    height: 200,
                    width: 370,
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      child: buildImagesGridView(images),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    addproduct();
                    setState(() {});
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.done),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "SAVE",
                        style: TextStyle(fontSize: 24),
                      ),
                      if (progress)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SpinKitHourGlass(
                            color: Colors.green,
                            size: 30,
                          ),
                        )
                    ],
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueGrey[900]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.green)),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.only(
                            left: 20.0, right: 30.0, top: 10.0, bottom: 10.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                  Icons.error_outline,
                  size: 30,
                  color: Colors.red,
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

  Widget buildImagesGridView(List<File> im) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (images.length == 4) ? images.length : images.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 100 / 100,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index == im.length)
          return Card(
            color: Colors.blueGrey[900],
            elevation: 20,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                _showPicker(context, true);
              },
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 50,
                color: Colors.white24,
              ),
            ),
          );
        else
          return Card(
            elevation: 20.0,
            clipBehavior: Clip.antiAlias,
            color: Colors.blueGrey[900],
            child: Stack(
              children: [
                Image.file(
                  im[index],
                  width: 200,
                  height: 200,
                  fit: BoxFit.fitHeight,
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: InkWell(
                    child: Icon(
                      Icons.cancel,
                      size: 25,
                      color: Colors.red,
                    ),
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      images.remove(images[index]);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
      },
    );
  }
}

List<String> getList() {
  return ["LD", "HD", "DLX", "NONE"];
}
