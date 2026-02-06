import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/movie_provider.dart';
import '../../providers/favorites_provider.dart';
import '../favourites/favorites_screen.dart';
import '../search/search_screen.dart';
import 'widgets/movie_carousel.dart';
import 'widgets/movie_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Bottom navigation pages
  final List<Widget> _pages = [
    const HomePage(),
    const SearchScreen(),
    const FavoritesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load data when screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  // Fetch all movie data on app start
  void _loadInitialData() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);

    movieProvider.fetchPopularMovies();
    movieProvider.fetchTrendingMovies();
    movieProvider.fetchTopRatedMovies();
    favoritesProvider.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

// Home page content with movie sections
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            title: const Text('Cinema'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Future: Notifications
                },
              ),
            ],
          ),

          // Featured movies carousel
          SliverToBoxAdapter(
            child: Consumer<MovieProvider>(
              builder: (context, provider, child) {
                if (provider.isLoadingTrending) {
                  return const SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (provider.trendingMovies.isEmpty) {
                  return const SizedBox.shrink();
                }

                return MovieCarousel(movies: provider.trendingMovies);
              },
            ),
          ),

          // Popular movies section
          SliverToBoxAdapter(
            child: Consumer<MovieProvider>(
              builder: (context, provider, child) {
                return MovieSection(
                  title: 'Popular Now',
                  movies: provider.popularMovies,
                  isLoading: provider.isLoadingPopular,
                );
              },
            ),
          ),

          // Top rated movies section
          SliverToBoxAdapter(
            child: Consumer<MovieProvider>(
              builder: (context, provider, child) {
                return MovieSection(
                  title: 'Top Rated',
                  movies: provider.topRatedMovies,
                  isLoading: provider.isLoadingTopRated,
                );
              },
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}