import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/category_item.dart';
import '../providers/categories.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final featuredCategory = Categories.items()
        .elementAt(Random().nextInt(Categories.items().length));
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 15.0),
          child: Text(
            'Today\'s featured category',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
          child: Container(
            height: 200,
            width: deviceSize.width * .75,
            child: CategoryItem(featuredCategory.id, featuredCategory.title,
                featuredCategory.color, true),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 15.0),
          child: Text(
            'All Categories',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        GridView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: const EdgeInsets.all(25),
          children: Categories.items()
              .map(
                (catData) => CategoryItem(
                    catData.id, catData.title, catData.color, false),
              )
              .toList(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 40,
          ),
        ),
      ],
    );
  }
}
