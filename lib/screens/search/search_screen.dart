import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/movie_provider.dart';
import '../../core/theme/app_colors.dart';
import '../home/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      Provider.of<MovieProvider>(context, listen: false).clearSearch();
      return;
    }

    setState(() {
      _isSearching = true;
    });

    Provider.of<MovieProvider>(context, listen: false).searchMovies(query);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Search',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),

            // Search bar
            TextField(
              controller: _searchController,
              onChanged: (value) {
                // Debounce search - wait for user to stop typing
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _performSearch(value);
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Search results
            Expanded(
              child: Consumer<MovieProvider>(
                builder: (context, provider, child) {
                  if (!_isSearching) {
                    return _buildEmptyState();
                  }

                  if (provider.isSearching) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (provider.searchResults.isEmpty) {
                    return const Center(
                      child: Text('No movies found'),
                    );
                  }

                  return _buildSearchResults(provider.searchResults);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty state when no search is performed
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for movies',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Grid of search results
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
        return MovieCard(
          movie: movies[index],
          width: double.infinity,
        );
      },
    );
  }
}