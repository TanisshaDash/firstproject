import 'package:get/get.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/api_service.dart';

class MovieController extends GetxController {
  final ApiService _apiService = ApiService();

  // State
  var popularMovies = <Movie>[].obs;
  var trendingMovies = <Movie>[].obs;
  var topRatedMovies = <Movie>[].obs;
  var searchResults = <Movie>[].obs;
  var selectedMovieDetail = Rxn<MovieDetail>(); // nullable observable
  var similarMovies = <Movie>[].obs;

  var isLoadingPopular = false.obs;
  var isLoadingTrending = false.obs;
  var isLoadingTopRated = false.obs;
  var isSearching = false.obs;
  var isLoadingDetail = false.obs;
  var error = RxnString(); // nullable observable string

  @override
  void onInit() {
    super.onInit();
    fetchPopularMovies();
    fetchTrendingMovies();
    fetchTopRatedMovies();
  }

  Future<void> fetchPopularMovies() async {
    isLoadingPopular(true);
    error(null);
    try {
      popularMovies.assignAll(await _apiService.getPopularMovies());
    } catch (e) {
      error(e.toString());
    } finally {
      isLoadingPopular(false);
    }
  }

  Future<void> fetchTrendingMovies() async {
    isLoadingTrending(true);
    error(null);
    try {
      trendingMovies.assignAll(await _apiService.getTrendingMovies());
    } catch (e) {
      error(e.toString());
    } finally {
      isLoadingTrending(false);
    }
  }

  Future<void> fetchTopRatedMovies() async {
    isLoadingTopRated(true);
    error(null);
    try {
      topRatedMovies.assignAll(await _apiService.getTopRatedMovies());
    } catch (e) {
      error(e.toString());
    } finally {
      isLoadingTopRated(false);
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    isSearching(true);
    error(null);
    try {
      searchResults.assignAll(await _apiService.searchMovies(query));
    } catch (e) {
      error(e.toString());
    } finally {
      isSearching(false);
    }
  }

  void clearSearch() => searchResults.clear();

  Future<void> fetchMovieDetails(int movieId) async {
    isLoadingDetail(true);
    error(null);
    try {
      selectedMovieDetail.value = await _apiService.getMovieDetails(movieId);
      similarMovies.assignAll(await _apiService.getSimilarMovies(movieId));
    } catch (e) {
      error(e.toString());
    } finally {
      isLoadingDetail(false);
    }
  }

  void clearMovieDetail() {
    selectedMovieDetail.value = null;
    similarMovies.clear();
  }
}