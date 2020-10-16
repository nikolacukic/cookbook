import 'package:flutter/material.dart';

class LandscapeLogoAppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/meal.png',
          height: 60,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Welcome to Cookbook',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
