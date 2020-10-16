import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../widgets/app_drawer.dart';
import '../widgets/meal_item_compact.dart';
import '../widgets/custom_popup_menu.dart';
import '../widgets/fancy_fab.dart';

class UserMealsScreen extends StatefulWidget {
  static const routeName = '/user-meals';
  @override
  _UserMealsScreenState createState() => _UserMealsScreenState();
}

class _UserMealsScreenState extends State<UserMealsScreen> {
  var _isInit = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _loadMeals();
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  Future<void> _loadMeals() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Meals>(context).fetchAndSetMeals(true);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refresh() async {
    await Provider.of<Meals>(context, listen: false).fetchAndSetMeals(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          CustomPopupMenu(),
        ],
        title: Text(
          'Your Recipes',
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FancyFab(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              child: Consumer<Meals>(
                builder: (context, mealsData, _) => mealsData.meals.isEmpty
                    ? Center(
                        child: Text('Recipes you add will be displayed here.'),
                      )
                    : ListView.separated(
                        itemBuilder: (ctx, index) {
                          if (index != mealsData.meals.length) {
                            return MealItemCompact(
                                meal: mealsData.meals[index]);
                          } else {
                            return Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Text(
                                    'Swipe items to the left to delete.',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            );
                          }
                        },
                        separatorBuilder: (ctx, index) => Divider(
                          thickness: 2,
                        ),
                        itemCount: mealsData.meals.length + 1,
                      ),
              ),
              onRefresh: _refresh,
            ),
    );
  }
}
