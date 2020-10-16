import 'package:cookbook/screens/category_detail_screen.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  final bool featured;

  CategoryItem(this.id, this.title, this.color, this.featured);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CategoryDetailScreen.routeName,
        arguments: {'id': this.id, 'title': this.title});
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'View $title dishes',
      child: InkWell(
        onTap: () => selectCategory(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Padding(
            padding: featured ? EdgeInsets.only(top: 60) : EdgeInsets.all(0),
            child: Text(
              title,
              style: featured
                  ? TextStyle(
                      fontSize: 36,
                    )
                  : Theme.of(context).textTheme.headline6,
              textAlign: featured ? TextAlign.center : TextAlign.left,
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.7),
                color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
