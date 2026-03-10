import 'package:get/get.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';

class FavoritesController extends GetxController {
  final StorageService _storageService = StorageService();

  var favorites = <Movie>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading(true);
    try {
      favorites.assignAll(await _storageService.loadFavorites());
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      isLoading(false);
    }
  }

  bool isFavorite(int movieId) {
    return favorites.any((movie) => movie.id == movieId);
  }

  Future<void> addToFavorites(Movie movie) async {
    if (!isFavorite(movie.id)) {
      favorites.add(movie);
      await _storageService.saveFavorites(favorites);
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    favorites.removeWhere((movie) => movie.id == movieId);
    await _storageService.saveFavorites(favorites);
  }

  Future<void> toggleFavorite(Movie movie) async {
    isFavorite(movie.id)
        ? await removeFromFavorites(movie.id)
        : await addToFavorites(movie);
  }

  Future<void> clearAllFavorites() async {
    favorites.clear();
    await _storageService.clearFavorites();
  }
}