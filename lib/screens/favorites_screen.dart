import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../widgets/meal_item_large.dart';
import '../models/meal.dart';

class FavoritesScreen extends StatelessWidget {
  Future<void> _refresh(BuildContext context, List<Meal> items) async {
    await Provider.of<Meals>(context, listen: false).fetchAndSetMeals();
    items = Provider.of<Meals>(context, listen: false).favoriteItems;
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Meals>(context, listen: false).favoriteItems;
    return (items != null && items.length > 0)
        ? RefreshIndicator(
            onRefresh: () => _refresh(context, items),
            child: ListView.builder(
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: items[index],
                child: MealItemLarge(),
              ),
              itemCount: items.length,
            ),
          )
        : Center(
            child: Text('No favorite meals yet!'),
          );
  }
}
