import 'package:cookbook/providers/meals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './categories_screen.dart';
import './favorites_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_popup_menu.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  var _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future<void> _loadRecipes() async {
    await Provider.of<Meals>(context, listen: false).fetchAndSetMeals();
  }

  @override
  void initState() {
    _pages = [
      {
        'page': CategoriesScreen(),
        'title': 'Categories',
      },
      {
        'page': FavoritesScreen(),
        'title': 'Favorites',
      },
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _loadRecipes();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'],
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: <Widget>[
          CustomPopupMenu(),
          // IconButton(
          //   icon: Icon(Icons.more_vert),
          //   tooltip: 'More Options',
          //   onPressed: () {},
          // ),
        ],
      ),
      drawer: AppDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        selectedFontSize: 13,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            title: Text('Discover'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
        ],
        // backgroundColor: Theme.of(context).primaryColor,
        // unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
      ),
    );
  }
}
