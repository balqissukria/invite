import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'config.dart';
import 'user.dart';
import 'mainmenu.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth, resWidth;
  File? _image;
  var pathAsset = "assets/images/profile.png";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Column(children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: screenHeight * 0.25,
                  child: Row(
                    children: [
                      Flexible(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(widget.user.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                                child: Divider(
                                  color: Colors.blueGrey,
                                  height: 2,
                                  thickness: 2.0,
                                ),
                              ),
                              Table(
                                columnWidths: const {
                                  0: FractionColumnWidth(0.3),
                                  1: FractionColumnWidth(0.7)
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    const Icon(Icons.email),
                                    Text(widget.user.email.toString()),
                                  ]),
                                  TableRow(children: [
                                    const Icon(Icons.phone),
                                    Text(widget.user.phone.toString()),
                                  ]),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
            Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth,
                        alignment: Alignment.center,
                        color: Theme.of(context).backgroundColor,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: Text("PROFILE SETTINGS",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      Expanded(
                          child: ListView(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              shrinkWrap: true,
                              children: [
                            MaterialButton(
                              onPressed: () => {_updateProfileDialog(1)},
                              child: const Text("UPDATE NAME"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            MaterialButton(
                              onPressed: () => {_updateProfileDialog(2)},
                              child: const Text("UPDATE PHONE"),
                            ),
                            MaterialButton(
                              onPressed: () => {_updateProfileDialog(3)},
                              child: const Text("UPDATE PASSWORD"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            MaterialButton(
                              onPressed: _registerAccountDialog,
                              child: const Text("NEW REGISTRATION"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            MaterialButton(
                              onPressed: _loginDialog,
                              child: const Text("LOGIN"),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            const Divider(
                              height: 2,
                            ),
                          ])),
                    ],
                  ),
                )),
          ]),
          drawer: MainMenuWidget(
            user: widget.user,
          )),
    );
  }

  _updateProfileDialog(int i) {}

  void buyCreditPage() {}

  void _loginDialog() {}

  void _registerAccountDialog() {}
}
