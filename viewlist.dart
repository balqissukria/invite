import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invite/details.dart';
import 'package:invite/weddingDetails.dart';
import 'userscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:invite/wedding.dart';
import 'mainmenu.dart';
import 'package:ndialog/ndialog.dart';
import 'config.dart';
import 'user.dart';

import 'package:http/http.dart' as http;

class WeddingListScreen extends StatefulWidget {
  final User user;
  const WeddingListScreen({super.key, required this.user});

  @override
  State<WeddingListScreen> createState() => _WeddingListScreenState();
}

class _WeddingListScreenState extends State<WeddingListScreen> {
  List<Wedding> weddingList = <Wedding>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var seller;
  //for pagination
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;

//for pagination
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadWeddings();
    });
  }

  @override
  void dispose() {
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
              title: const Text(
                "Alert Your Invitation",
                textAlign: TextAlign.center,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _loadSearchDialog();
                  },
                ),
              ]),
          body: weddingList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        " Wedding (${weddingList.length} found)",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                    ),
                    //pagination widget
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Color.fromARGB(255, 223, 49, 173);
                          } else {
                            color = Color.fromARGB(255, 0, 0, 0);
                          }
                          return TextButton(
                              onPressed: () => {_loadWeddings()},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
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

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Find Invitation ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'eg: hanim ',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadWeddings();
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  void _showDetails(int index) {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    Wedding wedding = Wedding.fromJson(weddingList[index].toJson());
    //loadSingleSeller(index);
    //todo update seller object with empty object.
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();
    Timer(const Duration(seconds: 1), () {
      if (seller != null) {
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => WeddingDetails(
                      user: widget.user,
                      wedding: wedding,
                      //seller: seller,
                    )));
      }
      progressDialog.dismiss();
    });
  }
}
