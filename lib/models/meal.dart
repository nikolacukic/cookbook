import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum Complexity {
  Simple,
  Medium,
  Hard,
}

enum Affordability {
  Cheap,
  Pricey,
  Lux,
}

class Meal with ChangeNotifier {
  final String id;
  final List<String> categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
  bool isFavorite;

  Meal(
      {@required this.id,
      @required this.categories,
      @required this.title,
      @required this.imageUrl,
      @required this.ingredients,
      @required this.steps,
      @required this.duration,
      @required this.complexity,
      @required this.affordability,
      @required this.isGlutenFree,
      @required this.isLactoseFree,
      @required this.isVegan,
      @required this.isVegetarian,
      this.isFavorite});

  String toString() {
    return '$id $categories $title $imageUrl $ingredients $steps  $duration ${describeEnum(complexity)} ${describeEnum(affordability)} $isGlutenFree $isLactoseFree $isVegan $isVegetarian';
  }

  Meal copyWith(
      {String id,
      List<String> categories,
      String title,
      String imageUrl,
      List<String> ingredients,
      List<String> steps,
      int duration,
      Complexity complexity,
      Affordability affordability,
      bool isGlutenFree,
      bool isLactoseFree,
      bool isVegan,
      bool isVegetarian,
      bool isFavorite}) {
    return Meal(
        id: id ?? this.id,
        categories: categories ?? this.categories,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
        duration: duration ?? this.duration,
        complexity: complexity ?? this.complexity,
        affordability: affordability ?? this.affordability,
        isGlutenFree: isGlutenFree ?? this.isGlutenFree,
        isLactoseFree: isLactoseFree ?? this.isLactoseFree,
        isVegan: isVegan ?? this.isVegan,
        isVegetarian: isVegetarian ?? this.isVegetarian,
        isFavorite: isFavorite ?? this.isFavorite);
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final currentStatus = this.isFavorite;
    this.isFavorite = !this.isFavorite;
    notifyListeners();
    try {
      final url =
          'https://cookbook-flutter.firebaseio.com/userFavorites/$userId/${this.id}.json?auth=$token';
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        this.isFavorite = currentStatus;
        notifyListeners();
      }
    } catch (error) {
      this.isFavorite = currentStatus;
      notifyListeners();
    }
  }
}
