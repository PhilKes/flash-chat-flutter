import 'package:flutter/material.dart';

class UserEntry extends StatelessWidget {
  UserEntry({this.name, @required this.onOpenChat});

  final String name;

  final Function onOpenChat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onOpenChat(name),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Expanded(
              child: Material(
                elevation: 0.0,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Colors.black,
                            size: 50.0,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Divider()
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 1.0,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
