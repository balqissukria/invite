import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:invite/user.dart';

import 'config.dart';

class NewWeddingScreen extends StatefulWidget {
  final User user;
  final Position position;
  final List<Placemark> placemarks;
  const NewWeddingScreen(
      {super.key,
      required this.user,
      required this.position,
      required this.placemarks});

  @override
  State<NewWeddingScreen> createState() => _NewWeddingScreenState();
}

class _NewWeddingScreenState extends State<NewWeddingScreen> {
  final TextEditingController _wddescEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // _checkPermissionGetLoc();
    // _lat = widget.position.latitude.toString();
    // _lng = widget.position.longitude.toString();
    //_getAddress();
  }

  File? _image;
  // List<File> _imageList = [];
  var pathAsset = "assets/images/camera.jpeg";
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text("New Invitation")),
        body: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: _selectImageDialog,
              child: Card(
                elevation: 8,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image!) as ImageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add New Invitation",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _wddescEditingController,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Wedding description must be longer than 10"
                          : null,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Wedding Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.person,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      child: const Text('Add Invitation'),
                      onPressed: () => {
                        _newWeddingDialog(),
                      },
                    ),
                  ),
                ]),
              ),
            )
          ]),
        ));
  }

  void _newWeddingDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert this Invitation?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                insertWedding();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select picture from:",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 64,
                    onPressed: _onCamera,
                    icon: const Icon(Icons.camera)),
                IconButton(
                    iconSize: 64,
                    onPressed: _onGallery,
                    icon: const Icon(Icons.browse_gallery)),
              ],
            ));
      },
    );
  }

  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
      //setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;

      setState(() {});
    }
  }

  void insertWedding() {
    String wddesc = _wddescEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("${Config.SERVER}/php/insert_wed.php"), body: {
      "id": widget.user.id,
      "wddesc": wddesc,
      "image": base64Image,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
