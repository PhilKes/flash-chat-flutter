import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/user_entry.dart';
import 'package:flash_chat/components/user_search_entry.dart';
import 'package:flash_chat/screens/single_chat_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../constants.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class ChatsScreen extends StatefulWidget {
  ChatsScreen();

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

List<String> friends = [];

class _ChatsScreenState extends State<ChatsScreen> {
  Stream<QuerySnapshot> stream = _firestore
      .collection(kFriendslistsCollection)
      .where('user', isEqualTo: _auth.currentUser.email)
      .snapshots()
      .first
      .asStream();

/*  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      stream=
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[ChatsStream(stream: stream)],
      ),
    );
  }
}

class ChatsStream extends StatefulWidget {
  ChatsStream({@required this.stream});

  final Stream<QuerySnapshot> stream;

  @override
  _ChatsStreamState createState() => _ChatsStreamState();
}

class _ChatsStreamState extends State<ChatsStream> {
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

  void openChat(String username) async {
    print('Open Chat ' + username);
    String chatName = getChatName(_auth.currentUser.email.trim(), username);
    var chat =
        await _firestore.collection(kChatsCollection).doc(chatName).get();
    if (!chat.exists) {
      await _firestore
          .collection(kChatsCollection)
          .doc(chatName)
          .set({'name': chatName, 'messages': []});
    }
    Navigator.pushNamed(context, SingleChatScreen.id,
        arguments: SingleChatScreenArguments(otherUsername: username));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data.docs;
          List<UserEntry> usersBox = [];
          for (var user in users) {
            List<String> friends = List.castFrom(user.get('friends'));
            for (var friend in friends) {
              final userBox = UserEntry(
                name: friend,
                onOpenChat: openChat,
              );
              usersBox.add(userBox);
            }
          }
          if (usersBox.isEmpty) {
            usersBox.add(UserEntry(
              name: "No Chats available",
              onOpenChat: openChat,
            ));
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: usersBox,
            ),
          );
        }
        return Column(
          children: [
            UserEntry(
              name: "No Chats available",
              onOpenChat: openChat,
            )
          ],
        );
      },
    );
  }
}
