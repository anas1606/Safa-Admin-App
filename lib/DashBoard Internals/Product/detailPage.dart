import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class DetailPage extends StatefulWidget {
  DetailPage({
    Key key,
    @required this.data,
    @required this.vehiclename,
    @required this.model,
  }) : super(key: key);

  var data;
  final String vehiclename;
  final String model;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _textController = TextEditingController();
  final prefix = "http://ec2-52-21-110-171.compute-1.amazonaws.com";
  bool progress = false;
  var media;
  List<File> imag = <File>[];
  File _img;
  File _coverImage;
  List<String> mediaList;
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

  getMedias() async {
    try {
      String id = widget.data["productID"];
      var url = "$prefix/api/admin/product/get/media/$id";
      var res = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      media = jsonDecode(res.body);
      validateReq(media);

      setState(() {
        mediaList = new List<String>.from(media["data"]);
      });
    } catch (e) {
      print(e);
    }
  }

  var data;
  updateProduct() async {
    setState(() {
      progress = true;
    });
    String id = widget.data["productID"];
    var url = "$prefix/api/admin/product/update";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    var req = await http.MultipartRequest('PUT', Uri.parse(url));
    req.headers.addAll(header);
    req.fields['data'] = jsonEncode(<String, String>{
      "productID": id,
      "rate": widget.data["rate"].toString(),
    });

    if (imag.length >= 1)
      req.files.add(await http.MultipartFile.fromPath('image1', imag[0].path));
    if (imag.length >= 2)
      req.files.add(await http.MultipartFile.fromPath('image2', imag[1].path));
    if (imag.length >= 3)
      req.files.add(await http.MultipartFile.fromPath('image2', imag[2].path));
    if (imag.length == 4)
      req.files.add(await http.MultipartFile.fromPath('image3', imag[3].path));
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
          "Product Updated",
          context,
          duration: 1,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.blue,
        );
      }
    });
  }

  startup() async {
    await gettoken();
    await getMedias();
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  _imgFromCamera(bool flag, int index) async {
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );

    setState(() {
      _img = File(image.path);
      if (flag)
        imag.insert(index - mediaList.length, _img);
      else
        _coverImage = _img;
    });
  }

  _imgFromGallery(bool flag, int index) async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    setState(() {
      _img = File(image.path);
      if (flag)
        imag.insert(index - mediaList.length, _img);
      else
        _coverImage = _img;
    });
  }

  void _showPicker(context, bool flag, int index) {
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
                      _imgFromGallery(flag, index);
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(flag, index);
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
      body: (widget.data != null)
          ? SingleChildScrollView(
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
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white12, Colors.transparent],
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
                                      widget.vehiclename,
                                      style: TextStyle(
                                        color: Colors.orange[800],
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
                                      widget.model,
                                      style: TextStyle(
                                        color: Colors.orange[800],
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
                                      "Type",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      widget.data["type"],
                                      style: TextStyle(
                                        color: Colors.orange[800],
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
                              child: Container(
                                child: (mediaList != null)
                                    ? buildImagesGridView(mediaList)
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.blueGrey[900],
                                        child: SpinKitFadingGrid(
                                          color: Colors.white60,
                                          size: 50.0,
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                updateProduct();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.update,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "UPDATE",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  if (progress)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SpinKitHourGlass(
                                        color: Colors.blueAccent,
                                        size: 30,
                                      ),
                                    )
                                ],
                              ),
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blueAccent),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blueGrey[900]),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side:
                                          BorderSide(color: Colors.blueAccent)),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.only(
                                        left: 20.0,
                                        right: 30.0,
                                        top: 10.0,
                                        bottom: 10.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data["productName"],
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: Colors.white54,
                                    fontFamily: "fugzOne"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  showDialog(
                                      context: context,
                                      builder: (contex) {
                                        return priceDailog();
                                      });
                                },
                                child: Padding(
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
                                                  fontFamily: "fugzOne"),
                                        ),
                                        TextSpan(
                                          text: "Rs " + widget.data["rate"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  color: Colors.amber[300],
                                                  fontFamily: "fugzOne"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 2.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      showDialog(
                                          context: context,
                                          builder: (contex) {
                                            return priceDailog();
                                          });
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white54,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: AspectRatio(
                                  aspectRatio: 100 / 100,
                                  child: SizedBox(
                                      height: 200,
                                      child: (widget.data["coverImageUrl"] ==
                                                  null &&
                                              _coverImage == null)
                                          ? GestureDetector(
                                              onTap: () {
                                                HapticFeedback.heavyImpact();
                                                _showPicker(context, false, 0);
                                              },
                                              child: Icon(
                                                  Icons
                                                      .add_photo_alternate_outlined,
                                                  size: 200,
                                                  color: Colors.white24),
                                            )
                                          : (widget.data["coverImageUrl"] !=
                                                      null &&
                                                  _coverImage == null)
                                              ? CachedNetworkImage(
                                                  imageUrl: widget
                                                      .data["coverImageUrl"],
                                                  fit: BoxFit.scaleDown,
                                                  placeholder: (context, url) =>
                                                      SpinKitCircle(
                                                          color:
                                                              Colors.white24),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                  child: Image.file(
                                                    _coverImage,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                )),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
    );
  }

  Widget buildImagesGridView(List<String> images) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ((images.length) + (imag.length) == 4)
          ? images.length + imag.length
          : images.length + imag.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 100 / 100,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index == (images.length + imag.length))
          return GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              _showPicker(context, true, index);
            },
            child: Card(
              color: Colors.blueGrey[900],
              elevation: 20,
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 50,
                color: Colors.white24,
              ),
            ),
          );
        else if (index < images.length)
          return Card(
            color: Colors.blueGrey[900],
            elevation: 20,
            child: CachedNetworkImage(
              imageUrl: images[index],
              placeholder: (context, url) =>
                  SpinKitCircle(color: Colors.white24),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        else
          return Card(
            color: Colors.blueGrey[900],
            elevation: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.file(
                imag[index - images.length],
                width: 180,
                height: 250,
                fit: BoxFit.fitHeight,
              ),
            ),
          );
      },
    );
  }

  Widget priceDailog() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        _textController.text = widget.data["rate"];
        return FittedBox(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 300,
                  width: 300,
                  margin: EdgeInsets.only(top: 30, left: 10, right: 10),
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
                          left: 20.0,
                        ),
                        child: GradientText(
                          "Update Price",
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
                        "-: Rate :-",
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
                                  "Price Updated",
                                  context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM,
                                  backgroundColor: Colors.green,
                                );
                                widget.data["rate"] = _textController.text;
                                setState((){});
                                Navigator.pop(context);
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
              ],
            ),
          ),
        );
      },
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
}
