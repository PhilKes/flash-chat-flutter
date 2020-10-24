import 'dart:ffi';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {this.text,
      this.onPressed,
      this.color,
      this.icon,
      this.width,
      this.circle});

  final String text;
  final Function onPressed;
  final Color color;
  final IconData icon;
  final double width;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.onPressed,
          minWidth:
              width != null ? width : circle != null && circle ? 42.0 : 200.0,
          height:
              circle != null && circle ? width != null ? width : 42.0 : 42.0,
          child: icon == null
              ? Text(
                  this.text,
                  style: TextStyle(color: Colors.white),
                )
              : Icon(
                  icon,
                  size: 42.0,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
