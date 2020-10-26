import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

final _firestore = Firestore.instance;

class MessagesStream extends StatelessWidget {
  MessagesStream({@required this.user, @required this.chatName});
  User user;
  String chatName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection(kChatsCollection).doc(chatName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chat = snapshot.data;
          List<MessageBubble> messageBubbles = [];
          List<dynamic> msgs = List.castFrom(chat.get('messages'));
          msgs.sort((msg1, msg2) => DateTime.parse(msg2['timestamp'])
              .compareTo(DateTime.parse(msg1['timestamp'])));
          for (var msg in msgs) {
            final messageText = msg['text'];
            final messageSender = msg['sender'];

            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              fromMe: user.email == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        }
        return Column();
      },
    );
  }
}
