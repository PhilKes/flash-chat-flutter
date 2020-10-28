import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/messages/messages_stream.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'main_screen.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class SingleChatScreenArguments {
  SingleChatScreenArguments({this.otherUsername});

  String otherUsername;
}

class SingleChatScreen extends StatefulWidget {
  static const String id = 'single_chat_screen';

  User user = _auth.currentUser;
  final TextEditingController messageTextController = TextEditingController();

  @override
  _SingleChatScreenState createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  String messageText;

  String chatName = "";

  @override
  Widget build(BuildContext context) {
    final SingleChatScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    chatName = getChatName(widget.user.email.trim(), args.otherUsername);

    void sendMessage() async {
      var chat =
          await _firestore.collection(kChatsCollection).doc(chatName).get();
      var map = !chat.exists ? {'name': chatName, 'messages': []} : chat.data();
      List<dynamic> msgs = List.castFrom(map['messages']);
      msgs.add({
        'text': messageText,
        'sender': widget.user.email.trim(),
        'timestamp': DateTime.now().toIso8601String()
      });
      map['messages'] = msgs;
      await _firestore.collection(kChatsCollection).doc(chatName).set(map);
      print("Added msg " + messageText);
      widget.messageTextController.clear();
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(args.otherUsername),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              user: widget.user,
              chatName: chatName,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: widget.messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: sendMessage,
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
      ),
    );
  }
}
