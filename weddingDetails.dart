import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:invite/wedding.dart';
import 'config.dart';

import 'user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WeddingDetails extends StatefulWidget {
  final Wedding wedding;
  final User user;
  // final User seller;
  const WeddingDetails({
    super.key,
    required this.wedding,
    required this.user,
    // required this.seller
  });

  @override
  State<WeddingDetails> createState() => _WeddingDetailsState();
}

class _WeddingDetailsState extends State<WeddingDetails> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    int _index;
    return Scaffold(
      appBar: AppBar(title: const Text("Details Invitations")),
      body: Container(
        color: Color.fromARGB(255, 210, 194, 188),
        child: Column(children: [
          const SizedBox(
            height: 16,
          ),
          // Center(
          //child: SizedBox(
          //  height: 200,
          // child:
          //PageView.builder(
          // itemCount: 3,
          //  controller: PageController(viewportFraction: 0.7),
          // onPageChanged: (int index) => setState(() => _index = index),
          //   itemBuilder: (BuildContext context, int index)

          // ),
          // ),
          // ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.wedding.weddingId.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
