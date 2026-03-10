import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/movie_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../favourites/favorites_screen.dart';
import '../search/search_screen.dart';
import 'widgets/movie_carousel.dart';
import 'widgets/movie_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxInt selectedIndex = 0.obs; // reactive index

    final List<Widget> pages = const [
      HomePage(),
      SearchScreen(),
      FavoritesScreen(),
    ];

    return Obx(() => Scaffold(
      body: pages[selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (index) => selectedIndex.value = index,
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
    ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Cinema'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),

          // Trending carousel
          SliverToBoxAdapter(
            child: Obx(() {
              if (movieController.isLoadingTrending.value) {
                return const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (movieController.trendingMovies.isEmpty) return const SizedBox.shrink();
              return MovieCarousel(movies: movieController.trendingMovies);
            }),
          ),

          // Popular movies
          SliverToBoxAdapter(
            child: Obx(() => MovieSection(
              title: 'Popular Now',
              movies: movieController.popularMovies,
              isLoading: movieController.isLoadingPopular.value,
            )),
          ),

          // Top rated movies
          SliverToBoxAdapter(
            child: Obx(() => MovieSection(
              title: 'Top Rated',
              movies: movieController.topRatedMovies,
              isLoading: movieController.isLoadingTopRated.value,
            )),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}