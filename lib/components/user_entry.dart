import 'package:flutter/material.dart';

class UserEntry extends StatelessWidget {
  UserEntry(
      {this.name, @required this.alreadyAdded, @required this.onAddFriend});

  final String name;
  final bool alreadyAdded;

  final Function onAddFriend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Expanded(
        child: Material(
          elevation: alreadyAdded ? 2.0 : 5.0,
          borderRadius: BorderRadius.circular(8.0),
          color: alreadyAdded ? Colors.grey : Colors.blueAccent,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        onAddFriend(name, !alreadyAdded);
                      },
                      icon: alreadyAdded
                          ? Icon(Icons.remove_circle)
                          : Icon(Icons.add_circle),
                      color: Colors.white,
                      iconSize: 40.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
