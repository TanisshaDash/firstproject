import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../detail/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;

  const MovieCard({
    Key? key,
    required this.movie,
    this.width = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: SizedBox(
        width: width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 2 / 3, // Standard poster ratio
                child: movie.fullPosterPath != null
                    ? CachedNetworkImage(
                  imageUrl: movie.fullPosterPath!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.darkCard,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.darkCard,
                    child: const Icon(
                      Icons.movie,
                      size: 40,
                      color: AppColors.darkIcon,
                    ),
                  ),
                )
                    : Container(
                  color: AppColors.darkCard,
                  child: const Icon(
                    Icons.movie,
                    size: 40,
                    color: AppColors.darkIcon,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Movie title
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Rating
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.rating,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  movie.rating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
      )
    );

  }
}