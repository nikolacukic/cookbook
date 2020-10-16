import 'package:cookbook/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/tabs_screen.dart';
import '../screens/user_meals_screen.dart';
import '../providers/auth.dart';
import '../providers/drawer_state_provider.dart';
import '../widgets/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  // final DrawerElement currentPage;

  // AppDrawer(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              leading: Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                child: Image.asset(
                  'assets/images/meal.png',
                  // color: Theme.of(context).accentColor,
                  color: Colors.white70,
                ),
              ),
              title: Text(
                'Your Cookbook',
                style: TextStyle(fontFamily: 'Lato'),
              ),
              automaticallyImplyLeading: false,
            ),
            SizedBox(height: 10),
            DrawerItem(
              itemType: DrawerElement.GetInspired,
              icon: Icons.lightbulb_outline,
              title: 'Get Inspired',
              tooltipMessage: 'Discover new Recipes and Daylists',
              routeName: TabsScreen.routeName,
            ),
            DrawerItem(
              itemType: DrawerElement.ManageContributions,
              icon: Icons.create,
              title: 'Manage Your Recipes',
              tooltipMessage: 'Add, Edit and Delete Recipes',
              routeName: UserMealsScreen.routeName,
            ),
            Divider(
              thickness: 1.5,
            ),
            DarkModeToggle(),
            Divider(
              thickness: 1.5,
            ),
            Tooltip(
              message: 'Log out of the app',
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop();
                  Provider.of<Auth>(context, listen: false).logout();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DarkModeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeMode, _) => CheckboxListTile(
          activeColor: Theme.of(context).accentColor,
          title: Row(
            children: <Widget>[
              Icon(
                Icons.brightness_2,
                color: themeMode.getCurrentTheme == ThemeMode.light
                    ? Colors.grey[600]
                    : Colors.amber,
              ),
              SizedBox(width: 30),
              Text('Dark Mode')
            ],
          ),
          value: themeMode.getCurrentTheme == ThemeMode.dark,
          onChanged: (_) {
            Provider.of<ThemeProvider>(context, listen: false).switchMode();
          }),
    );
  }
}
