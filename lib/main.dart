import 'package:cookbook/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/meals.dart';
import './providers/theme_provider.dart';
import './providers/drawer_state_provider.dart';
import './screens/edit_meal_screen.dart';
import './screens/recipe_detail_screen.dart';
import './screens/auth_screen.dart';
import './screens/tabs_screen.dart';
import './screens/category_detail_screen.dart';
import './screens/user_meals_screen.dart';

void main() => runApp(
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: Consumer2<ThemeProvider, Auth>(
          builder: (context, themeMode, auth, child) {
        ifAuth(targetScreen) => auth.isAuth
            ? targetScreen
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen()
                        : auth.isAuth ? targetScreen : AuthScreen(),
              );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cookbook',
          theme: ThemeData.light().copyWith(
              primaryColor: Color(0xfffd7f2c),
              accentColor: Colors.blue,
              canvasColor: Color.fromRGBO(255, 254, 229, 1),
              textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Lato')),
          darkTheme: ThemeData.dark().copyWith(
              // primaryColor: Color(0xfffd7f2c),
              accentColor: Color(0xfffd7f2c),
              canvasColor: Color.fromRGBO(32, 32, 32, 1),
              textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Lato')),
          themeMode: Provider.of<ThemeProvider>(context, listen: false)
              .getCurrentTheme,
          home: ifAuth(TabsScreen()),
          routes: {
            TabsScreen.routeName: (ctx) => ifAuth(TabsScreen()),
            CategoryDetailScreen.routeName: (ctx) =>
                ifAuth(CategoryDetailScreen()),
            UserMealsScreen.routeName: (ctx) => ifAuth(UserMealsScreen()),
            RecipeDetailScreen.routeName: (ctx) => ifAuth(RecipeDetailScreen()),
            EditMealScreen.routeName: (ctx) => ifAuth(EditMealScreen()),
          },
        );
      }),
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DrawerStateInfo(),
        ),
        ChangeNotifierProxyProvider<Auth, Meals>(
          create: (ctx) => Meals('', '', []),
          update: (ctx, auth, previousMeals) => Meals(
            auth.token,
            auth.userId,
            previousMeals == null ? [] : previousMeals.meals,
          ),
        ),
      ],
    );
  }
}
