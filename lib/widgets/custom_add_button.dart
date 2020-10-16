import 'package:flutter/material.dart';

class CustomAddButton extends StatelessWidget {
  final IconData icon;

  CustomAddButton(this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 20,
          ),
          Icon(
            Icons.add,
            size: 12,
          ),
        ],
      ),
    );
  }
}
