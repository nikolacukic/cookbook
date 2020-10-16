import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/auth.dart';
import '../widgets/nutritional_info.dart';

class RecipeDetailScreen extends StatelessWidget {
  static const routeName = '/recipe-detail';
  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    final auth = Provider.of<Auth>(context, listen: false);
    final meal = Provider.of<Meal>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          meal.title,
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 250,
                    width: double.infinity,
                    child: Hero(
                      tag: meal.id,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/images/dinner.png'),
                        image: NetworkImage(meal.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(.7),
                      child: IconButton(
                        tooltip: 'Toggle favorite status',
                        icon: meal.isFavorite
                            ? Icon(
                                Icons.favorite,
                                color: Theme.of(context).accentColor,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                        onPressed: () {
                          meal.toggleFavoriteStatus(auth.token, auth.userId);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                meal.title,
                style: TextStyle(fontSize: 26),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(height: 10),
              NutritionalInfo(meal: meal),
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 16),
                child: const Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withOpacity(.7),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) => Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 16, 0),
                    child: Text(
                      '• ${meal.ingredients[index]}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  itemCount: meal.ingredients.length,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32, left: 16),
                child: const Text(
                  'Steps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.8),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(thickness: 5),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) => Padding(
                    padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
                    child: Text(
                      '${index + 1}. ${meal.steps[index]}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  itemCount: meal.steps.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 32),
                //   child: Tooltip(
                //     message: 'Add a Comment - not yet supported',
                //     child: RaisedButton.icon(
                //       onPressed: () {
                //         //TODO Implement adding comments
                //       },
                //       color: Theme.of(context).accentColor,
                //       textColor: Colors.white,
                //       icon: Icon(
                //         Icons.comment,
                //         // color: Colors.red,
                //       ),
                //       label: Text('Add a Comment'),
                //     ),
                //   ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
