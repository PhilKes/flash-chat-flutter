import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'main_screen.dart';
import '../components/messages_stream.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class SingleChatScreen extends StatelessWidget {
  SingleChatScreen();

  User user = _auth.currentUser;
  final TextEditingController messageTextController = TextEditingController();

  String messageText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MessagesStream(
            user: user,
          ),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    try {
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': user.email,
                        'timestamp': DateTime.now().millisecondsSinceEpoch
                      });
                      messageTextController.clear();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
