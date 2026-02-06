import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_detail.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/movie_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/movie.dart';
import '../home/widgets/movie_card.dart';


class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch movie details when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false)
          .fetchMovieDetails(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDetail) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.selectedMovieDetail == null) {
            return const Center(
              child: Text('Movie not found'),
            );
          }

          final movie = provider.selectedMovieDetail!;

          return CustomScrollView(
            slivers: [
              // Backdrop header with app bar
              _buildHeader(movie),

              // Movie information
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayLarge,
                      ),
                      const SizedBox(height: 12),

                      // Rating, year, runtime
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.rating,
                              size: 20),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${movie.voteCount})',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            movie.releaseYear,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            movie.formattedRuntime,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Genres
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

                      // Tagline
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

                      // Overview
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview ?? 'No overview available.',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                      ),
                      const SizedBox(height: 24),

                      // Similar movies
                      if (provider.similarMovies.isNotEmpty) ...[
                        const Text(
                          'Similar Movies',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.similarMovies.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: MovieCard(
                                  movie: provider.similarMovies[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 1. The Fixed Header Function
  Widget _buildHeader( MovieDetail movie) {
    return SliverAppBar(
        expandedHeight: 300,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              // Backdrop image
              if (movie.fullBackdropPath != null)
                CachedNetworkImage(
                  imageUrl: movie.fullBackdropPath!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: AppColors.darkCard),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.movie, size: 50),
                )
              else
                Container(color: AppColors.darkCard,
                    child: const Icon(Icons.movie, size: 50)),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.darkBackground.withOpacity(0.9),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          // 2. Favorite button moved inside SliverAppBar actions
          Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              final isFavorite = favProvider.isFavorite(movie.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  // Quick conversion for the provider
                  final movieForFav = Movie(
                    id: movie.id,
                    title: movie.title,
                    overview: movie.overview,
                    posterPath: movie.posterPath,
                    backdropPath: movie.backdropPath,
                    voteAverage: movie.voteAverage,
                    voteCount: movie.voteCount,
                    releaseDate: movie.releaseDate,
                    genreIds: movie.genres.map<int>((dynamic g) => g.id as int).toList(),
                  );

                  favProvider.toggleFavorite(movieForFav);

                  // ✨ Add this for user feedback:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Removed from favorites'
                            : 'Added to favorites',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
          )
        ]
    );
  }
}