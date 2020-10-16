import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../models/meal.dart';
import '../screens/edit_meal_screen.dart';

class MealItemCompact extends StatelessWidget {
  const MealItemCompact({
    Key key,
    @required this.meal,
  }) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(meal.id),
      background: Container(
        height: double.infinity,
        // color: Theme.of(context).errorColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 0),
          child: Icon(
            Icons.delete_sweep,
            color: Colors.red,
            size: 30,
          ),
        ),
        alignment: Alignment.centerRight,
        // padding: EdgeInsets.only(right: 20),
        // margin: EdgeInsets.symmetric(
        //   horizontal: 15,
        //   vertical: 4,
        // ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure you want to delete this recipe?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Meals>(context, listen: false).removeItem(meal.id);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(meal.imageUrl),
        ),
        title: Text(meal.title),
        // subtitle: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: RecipeInfo(meal: meal),
        // ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(EditMealScreen.routeName, arguments: meal.id);
          },
        ),
      ),
    );
  }
}
