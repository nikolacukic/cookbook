import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final DropdownButtonFormField child;
  final IconData icon;

  CustomDropdown({this.child, this.icon});
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 35.0),
          child: widget.child,
        ),
        Container(
          margin: EdgeInsets.only(top: 30.0),
          child: Icon(
            widget.icon,
            color: Theme.of(context).accentColor,
            size: 20.0,
          ),
        ),
      ],
    );
  }
}
