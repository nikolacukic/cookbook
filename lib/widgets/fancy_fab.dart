import 'package:flutter/material.dart';

import '../widgets/custom_add_button.dart';
import '../screens/edit_meal_screen.dart';

class FancyFab extends StatefulWidget {
  // final Function() onPressed;
  // final String tooltip;
  // final IconData icon;

  // FancyFab({this.onPressed, this.tooltip, this.icon});

  // @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });

    _animateIcon =
        Tween<double>(begin: 0.0, end: 0.125).animate(_animationController);

    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          1.00,
          curve: Curves.linear,
        ),
      ),
    );

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          0.75,
          curve: _curve,
        ),
      ),
    );

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget buildFab(Function onPressed, String tooltip, IconData icon) {
    return new Container(
      width: 50,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: onPressed,
        heroTag: null,
        tooltip: tooltip,
        child: CustomAddButton(icon),
      ),
    );
  }

  Widget mainToggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: isOpened ? 'Close' : 'Add Contribution',
        // child: AnimatedIcon(
        //   icon: AnimatedIcons.menu_close,
        //   progress: _animateIcon,
        // ),
        // child: isOpened ? Icon(Icons.close) : Icon(Icons.add),
        child: RotationTransition(
          turns: _animateIcon,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: buildFab(
            () {
              Navigator.of(context).pushNamed(EditMealScreen.routeName);
              animate();
            },
            'Add Recipe',
            Icons.restaurant,
          ),
        ),
        // Transform(
        //   transform: Matrix4.translationValues(
        //     0.0,
        //     _translateButton.value * 2.0,
        //     0.0,
        //   ),
        //   child: buildFab(
        //     () {
        //       // route to add/edit daylist
        //     },
        //     'Add Daylist',
        //     Icons.list,
        //   ),
        // ),
        mainToggle(),
      ],
    );
  }
}
