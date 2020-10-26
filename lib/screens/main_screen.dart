import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import '../constants.dart';
import 'single_chat_screen.dart';
import 'users_search_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.message)),
              Tab(icon: Icon(Icons.search))
            ],
          ),
        ),
        body: TabBarView(
          children: [SingleChatScreen(), UsersSearchScreen()],
        ),
      ),
    );
  }
}
