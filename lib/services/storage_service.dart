import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _favoritesKey = 'favorites';

  /// Save favorites to local storage
  Future<void> saveFavorites(List<Movie> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        favorites.map((movie) => movie.toJson()).toList(),
      );
      await prefs.setString(_favoritesKey, encoded);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  /// Load favorites from local storage
  Future<List<Movie>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson == null) return [];

      final List<dynamic> decoded = json.decode(favoritesJson);
      return decoded.map((item) => Movie.fromJson(item)).toList();
    } catch (e) {
      print('Error loading favorites: $e');
      return [];
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}