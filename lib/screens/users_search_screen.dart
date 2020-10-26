import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/user_entry.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../constants.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class UsersSearchScreen extends StatefulWidget {
  UsersSearchScreen();

  @override
  _UsersSearchScreenState createState() => _UsersSearchScreenState();
}

List<QuerySnapshot> friends = [];

class _UsersSearchScreenState extends State<UsersSearchScreen> {
  String search = "";
  String lastSearch = "";

  Stream<QuerySnapshot> stream =
      _firestore.collection(kUsersCollection).snapshots();

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      _firestore
          .collection(kFriendslistsCollection)
          .where('user', isEqualTo: _auth.currentUser.email)
          .snapshots()
          .first
          .then((friendLists) {
        friends = friendLists.docs.first.get('friends');
        print(friends);
      });
    }
  }

  void searchUsers() {
    setState(() {
      this.lastSearch = search;
      this.stream = _firestore
          .collection(kUsersCollection)
          .where('name', isGreaterThanOrEqualTo: search)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: kInputTextFieldDecoration.copyWith(
                      hintText: 'Search Users'),
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),
              ),
              RoundedButton(
                color: Colors.blueAccent,
                circle: true,
                icon: Icons.search,
                onPressed: () {
                  searchUsers();
                },
              )
            ],
          ),
          UsersStream(search: lastSearch, stream: stream)
        ],
      ),
    );
  }
}

class UsersStream extends StatefulWidget {
  UsersStream({this.search, @required this.stream});

  String search = "";
  final Stream<QuerySnapshot> stream;

  @override
  _UsersStreamState createState() => _UsersStreamState();
}

class _UsersStreamState extends State<UsersStream> {
  List<String> friends = [];

  @override
  void initState() {
    super.initState();
    _firestore
        .collection(kFriendslistsCollection)
        .doc(_auth.currentUser.email)
        .get()
        .then((list) {
      friends = List.castFrom(list.get('friends'));
    });
  }

  void addFriend(String username, bool add) async {
    var friendList = await _firestore
        .collection(kFriendslistsCollection)
        .doc(_auth.currentUser.email)
        .get();
    var map = friendList.data();
    if (add)
      friends.add(username);
    else
      friends.remove(username);
    map['friends'] = friends;
    await _firestore
        .collection(kFriendslistsCollection)
        .doc(_auth.currentUser.email)
        .update(map);
    print("Added friend " + username);
    setState(() {});
  }

  hasAlreadyAdded(String username) {
    return friends.any((friend) => friend == username);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data.docs;
          List<Widget> usersBox = [];
          for (var user in users) {
            final userName = user.get('name');
            if (userName.toString().contains(widget.search) &&
                userName.toString() != _auth.currentUser.email.trim()) {
              final userBox = UserEntry(
                name: userName,
                alreadyAdded: hasAlreadyAdded(userName),
                onAddFriend: addFriend,
              );
              usersBox.add(userBox);
            }
          }
          if (usersBox.isEmpty) {
            usersBox.add(UserEntry(
              name: "No Users found",
              alreadyAdded: true,
              onAddFriend: addFriend,
            ));
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: usersBox,
            ),
          );
        }
        return Column(
          children: [
            UserEntry(
              name: "No Users found",
              alreadyAdded: true,
              onAddFriend: addFriend,
            )
          ],
        );
      },
    );
  }
}
