import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:invite/loginscreen.dart';
import 'package:invite/wedding.dart';

import 'package:ndialog/ndialog.dart';
import 'config.dart';
import 'details.dart';
import 'newwedding.dart';
import 'user.dart';
import 'mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ManageWeddingScreen extends StatefulWidget {
  final User user;
  const ManageWeddingScreen({super.key, required this.user});

  @override
  State<ManageWeddingScreen> createState() => _ManageWeddingScreenState();
}

class _ManageWeddingScreenState extends State<ManageWeddingScreen> {
  var _lat, _lng;
  late Position _position;
  List<Wedding> weddingList = <Wedding>[];
  String titlecenter = "Loading...";
  var placemarks;

  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();

    _loadWeddings();
  }

  @override
  void dispose() {
    weddingList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
        appBar: AppBar(title: const Text("Invitation Added"), actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("New Invitation"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              _gotoNewWedding();
              print("My account menu is selected.");
            }
          }),
        ]),
        body: weddingList.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your current wedding (${weddingList.length} found)",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowcount,
                      children: List.generate(weddingList.length, (index) {
                        return Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: () {
                              _showDetails(index);
                            },
                            onLongPress: () {
                              _deleteDialog(index);
                            },
                            child: Column(children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  width: resWidth / 2,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${Config.SERVER}/wedding/${weddingList[index].weddingId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          truncateString(
                                              weddingList[index]
                                                  .weddingId
                                                  .toString(),
                                              15),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ))
                            ]),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
        drawer: MainMenuWidget(user: widget.user));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  Future<void> _gotoNewWedding() async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );
    progressDialog.show();
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewWeddingScreen(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadWeddings();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  void _loadWeddings() {
    http
        .get(
      Uri.parse("${Config.SERVER}/php/loadwedding.php?id=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['wedding'] != null) {
            weddingList = <Wedding>[];
            extractdata['wedding'].forEach((v) {
              weddingList.add(Wedding.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Wedding Available";
            weddingList.clear();
          }
        } else {
          titlecenter = "No Wedding Available";
        }
      } else {
        titlecenter = "No Wedding Available";
        weddingList.clear();
      }
      setState(() {});
    });
  }

  Future<void> _showDetails(int index) async {
    Wedding wedding = Wedding.fromJson(weddingList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailsScreen(
                  wedding: wedding,
                  user: widget.user,
                )));
    _loadWeddings();
  }

  _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(weddingList[index].weddingId.toString(), 15)}",
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
                deletewedding(index);
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

  void deletewedding(index) {
    try {
      http.post(Uri.parse("${Config.SERVER}/php/delete_wedding.php"), body: {
        "weddingid": weddingList[index].weddingId,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadWeddings();
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
    } catch (e) {
      print(e.toString());
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout?",
            style: TextStyle(),
          ),
          content: const Text("Are your sure"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const LoginScreen()));
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
}
