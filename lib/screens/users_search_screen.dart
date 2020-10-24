import 'package:flash_chat/components/rounded_button.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class UsersSearchScreen extends StatelessWidget {
  const UsersSearchScreen({
    Key key,
  }) : super(key: key);

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
                ),
              ),
              RoundedButton(
                color: Colors.blueAccent,
                circle: true,
                icon: Icons.search,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
