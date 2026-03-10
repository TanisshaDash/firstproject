import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorites_controller.dart';
import '../../core/theme/app_colors.dart';
import '../home/widgets/movie_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoritesController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with count
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Favorites', style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(height: 4),
                    Text('${favController.favorites.length} movies',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                if (favController.favorites.isNotEmpty)
                  TextButton(
                    onPressed: () => _showClearDialog(context, favController),
                    child: const Text('Clear All'),
                  ),
              ],
            )),
            const SizedBox(height: 20),

            // Favorites grid
            Expanded(
              child: Obx(() {
                if (favController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (favController.favorites.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildFavoritesGrid(favController.favorites);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text('No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(
            'Add movies to your favorites\nto see them here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(List movies) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index], width: double.infinity);
      },
    );
  }

  void _showClearDialog(BuildContext context, FavoritesController favController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites?'),
        content: const Text('This will remove all movies from your favorites list.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              favController.clearAllFavorites();
              Get.back();
              Get.snackbar(
                '',
                'All favorites cleared',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}