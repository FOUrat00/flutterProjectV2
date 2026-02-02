import 'package:flutter/material.dart';
import '../models/property.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final List<Property> _favorites = [];

  List<Property> get favorites => List.unmodifiable(_favorites);

  void toggleFavorite(Property property) {
    final index = _favorites.indexWhere((p) => p.id == property.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(property);
    }
    notifyListeners();
  }

  bool isFavorite(Property property) {
    return _favorites.any((p) => p.id == property.id);
  }
}
