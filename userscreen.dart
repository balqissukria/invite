import 'package:invite/viewlist.dart';
import 'managewedding.dart';
import 'mainmenu.dart';
import 'package:flutter/material.dart';

import 'user.dart';

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("H O M E"),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: MaterialButton(
                    child: Text("Manage Weddings"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ManageWeddingScreen(user: widget.user)));
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 10),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: MaterialButton(
                    child: Text("View Invitation List"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              WeddingListScreen(user: widget.user)));
                    },
                  ),
                ),
              ],
            )),
        drawer: MainMenuWidget(
          user: widget.user,
        ));
  }
}
