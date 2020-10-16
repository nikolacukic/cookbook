import 'package:flutter/material.dart';
import '../models/meal.dart';

class NutritionalInfo extends StatelessWidget {
  const NutritionalInfo({
    Key key,
    @required this.meal,
  }) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (meal.isVegan)
          Chip(
            label: Text('Vegan'),
            labelStyle: TextStyle(fontFamily: 'Lato'),
            backgroundColor: Colors.green[200],
          ),
        if (meal.isVegetarian)
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Chip(
              label: Text('Vegetarian'),
              labelStyle: TextStyle(fontFamily: 'Lato'),
              backgroundColor: Colors.cyan[200],
            ),
          ),
        if (meal.isGlutenFree)
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Chip(
              label: Text('Gluten Free'),
              labelStyle: TextStyle(fontFamily: 'Lato'),
              backgroundColor: Colors.orange[200],
            ),
          ),
        if (meal.isLactoseFree)
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Chip(
              label: Text('Lactose Free'),
              labelStyle: TextStyle(fontFamily: 'Lato'),
              backgroundColor: Colors.red[200],
            ),
          )
      ],
    );
  }
}
