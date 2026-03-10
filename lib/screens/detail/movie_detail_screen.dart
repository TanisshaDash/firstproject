import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/movie_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/movie.dart';
import '../../models/movie_detail.dart';
import '../home/widgets/movie_card.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();
    final favController = Get.find<FavoritesController>();

    // fetch details when screen loads
    movieController.fetchMovieDetails(movieId);

    return Scaffold(
      body: Obx(() {
        if (movieController.isLoadingDetail.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (movieController.selectedMovieDetail.value == null) {
          return const Center(child: Text('Movie not found'));
        }

        final movie = movieController.selectedMovieDetail.value!;

        return CustomScrollView(
          slivers: [
            _buildHeader(movie, movieController, favController),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.rating, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        Text('(${movie.voteCount})',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(width: 16),
                        Text(movie.releaseYear,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(width: 16),
                        Text(movie.formattedRuntime,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (movie.genres.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: movie.genres.map((genre) {
                          return Chip(
                            label: Text(genre.name),
                            backgroundColor: AppColors.darkCard,
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 20),

                    if (movie.tagline != null && movie.tagline!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          '"${movie.tagline}"',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                    const Text('Overview',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview ?? 'No overview available.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),

                    // Similar movies
                    Obx(() {
                      if (movieController.similarMovies.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Similar Movies',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movieController.similarMovies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: MovieCard(movie: movieController.similarMovies[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(MovieDetail movie, MovieController movieController,
      FavoritesController favController) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (movie.fullBackdropPath != null)
              CachedNetworkImage(
                imageUrl: movie.fullBackdropPath!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.darkCard),
                errorWidget: (context, url, error) => const Icon(Icons.movie, size: 50),
              )
            else
              Container(color: AppColors.darkCard, child: const Icon(Icons.movie, size: 50)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.darkBackground.withOpacity(0.9)],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Obx(() {
          final isFav = favController.isFavorite(movie.id);
          return IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_outline,
              color: isFav ? Colors.red : Colors.white,
            ),
            onPressed: () {
              final movieForFav = Movie(
                id: movie.id,
                title: movie.title,
                overview: movie.overview,
                posterPath: movie.posterPath,
                backdropPath: movie.backdropPath,
                voteAverage: movie.voteAverage,
                voteCount: movie.voteCount,
                releaseDate: movie.releaseDate,
                genreIds: movie.genres.map<int>((g) => g.id as int).toList(),
              );
              favController.toggleFavorite(movieForFav);
              Get.snackbar(
                '',
                isFav ? 'Removed from favorites' : 'Added to favorites',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
              );
            },
          );
        }),
      ],
    );
  }
}