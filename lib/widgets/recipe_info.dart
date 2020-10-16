import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/meal.dart';

class RecipeInfo extends StatelessWidget {
  const RecipeInfo({
    Key key,
    @required this.meal,
  }) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.timer,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 6,
            ),
            Text('${meal.duration} min.'),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.fitness_center,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 6,
            ),
            Text(describeEnum(meal.complexity)),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.attach_money,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 6,
            ),
            Text(describeEnum(meal.affordability)),
          ],
        ),
      ],
    );
  }
}
