import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/meal.dart';
import '../screens/recipe_detail_screen.dart';
import 'recipe_info.dart';

class MealItemLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meal = Provider.of<Meal>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 300,
        child: Stack(children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Tooltip(
              message: 'View recipe for ${meal.title}',
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: meal,
                        child: RecipeDetailScreen(),
                      ),
                    ),
                  );
                  // Navigator.of(context)
                  //     .pushNamed(RecipeDetailScreen.routeName, arguments: meal);
                },
                splashColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(.12),
                highlightColor: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 180,
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
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        meal.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: RecipeInfo(meal: meal),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 28,
            bottom: 97,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.7),
              child: Consumer<Meal>(
                builder: (ctx, meal, _) => IconButton(
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
          )
        ]),
      ),
    );
  }
}
