import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/movie_controller.dart';
import '../../core/theme/app_colors.dart';
import '../home/widgets/movie_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();
    final TextEditingController searchController = TextEditingController();
    final isSearching = false.obs; // local reactive bool

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 20),

            // Search bar
            Obx(() => TextField(
              controller: searchController,
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (searchController.text == value) {
                    if (value.isEmpty) {
                      isSearching.value = false;
                      movieController.clearSearch();
                    } else {
                      isSearching.value = true;
                      movieController.searchMovies(value);
                    }
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    isSearching.value = false;
                    movieController.clearSearch();
                  },
                )
                    : null,
              ),
            )),
            const SizedBox(height: 20),

            // Results
            Expanded(
              child: Obx(() {
                if (!isSearching.value) return _buildEmptyState();
                if (movieController.isSearching.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (movieController.searchResults.isEmpty) {
                  return const Center(child: Text('No movies found'));
                }
                return _buildSearchResults(movieController.searchResults);
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
          Icon(Icons.movie_outlined, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text('Search for movies',
              style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List movies) {
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
}