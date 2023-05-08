import 'package:flutter/material.dart';
import 'package:invite/managewedding.dart';
import 'package:invite/viewlist.dart';
import 'loginscreen.dart';
import 'user.dart';
import 'userscreen.dart';

import 'profilescreen.dart';

import 'EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email.toString()),
            accountName: Text(widget.user.name.toString()),
            currentAccountPicture: const CircleAvatar(
              radius: 30.0,
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => UserScreen(user: widget.user)));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: UserScreen(user: widget.user),
                      enterPage: UserScreen(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => ProfileScreen(user: widget.user)));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: UserScreen(user: widget.user),
                      enterPage: ProfileScreen(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
