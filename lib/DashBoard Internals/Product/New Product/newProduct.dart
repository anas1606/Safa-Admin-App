import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/New%20Product/Widget/Name.dart';
import 'package:safa_admin/DashBoard%20Internals/Product/New%20Product/Widget/Price.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class addnewProduct extends StatefulWidget {
  addnewProduct({Key key}) : super(key: key);

  @override
  _addnewProductState createState() => _addnewProductState();
}

class _addnewProductState extends State<addnewProduct> {
  String dropDown = getList()[0];
  File _coverImage;

  _imgFromCamera() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    setState(() {
      _coverImage = File(image.path);
    });
  }

  _imgFromGallery() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _coverImage = File(image.path);
    });
  }

  void _showPicker(context) {
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
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.image_not_supported_outlined),
                    title: new Text('Remove Image'),
                    onTap: () {
                      setState(() {
                        _coverImage = null;
                      });
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
    final _nametextController = TextEditingController();
    final _pricetextController = TextEditingController();
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white12,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            _showPicker(context);
                          },
                          child: (_coverImage != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Image.file(
                                    _coverImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.white24,
                                  size: 150,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Name(textController: _nametextController),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Price(textController: _pricetextController),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<String> getList() {
  return ["LD", "HD", "DLX", "NONE"];
}
