import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../widgets/meal_item_large.dart';

class CategoryDetailScreen extends StatelessWidget {
  static const routeName = '/category-detail';
  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final meals = Provider.of<Meals>(context, listen: false)
        .findByCategory(category['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category['title'],
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      body: (meals != null && meals.length > 0)
          ? ListView.builder(
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: meals[index],
                child: MealItemLarge(),
              ),
              itemCount: meals.length,
            )
          : Center(
              child: Text('No ${category['title']} meals yet!'),
            ),
    );
  }
}
