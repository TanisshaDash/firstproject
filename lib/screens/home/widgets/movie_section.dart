import 'package:flutter/material.dart';
import '../../../models/movie.dart';
import 'movie_card.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool isLoading;

  const MovieSection({
    Key? key,
    required this.title,
    required this.movies,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),

        // Movie list
        SizedBox(
          height: 280,
          child: isLoading
              ? _buildLoadingState()
              : movies.isEmpty
              ? _buildEmptyState()
              : _buildMovieList(),
        ),
      ],
    );
  }

  // Loading state with shimmer effect
  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: 150,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  // Empty state
  Widget _buildEmptyState() {
    return const Center(
      child: Text('No movies available'),
    );
  }

  // Horizontal scrolling list of movie cards
  Widget _buildMovieList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: MovieCard(movie: movies[index]),
        );
      },
    );
  }
}