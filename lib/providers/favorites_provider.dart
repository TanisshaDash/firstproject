import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Movie> _favorites = [];
  bool _isLoading = false;

  List<Movie> get favorites => _favorites;
  bool get isLoading => _isLoading;

  /// Initialize and load favorites from storage
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _storageService.loadFavorites();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if a movie is in favorites
  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }

  /// Add movie to favorites
  Future<void> addToFavorites(Movie movie) async {
    if (!isFavorite(movie.id)) {
      _favorites.add(movie);
      await _storageService.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  /// Remove movie from favorites
  Future<void> removeFromFavorites(int movieId) async {
    _favorites.removeWhere((movie) => movie.id == movieId);
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      await removeFromFavorites(movie.id);
    } else {
      await addToFavorites(movie);
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _storageService.clearFavorites();
    notifyListeners();
  }
}