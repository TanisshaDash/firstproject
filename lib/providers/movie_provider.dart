import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State
  List<Movie> _popularMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _searchResults = [];
  MovieDetail? _selectedMovieDetail;
  List<Movie> _similarMovies = [];

  bool _isLoadingPopular = false;
  bool _isLoadingTrending = false;
  bool _isLoadingTopRated = false;
  bool _isSearching = false;
  bool _isLoadingDetail = false;

  String? _error;

  // Getters
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get searchResults => _searchResults;
  MovieDetail? get selectedMovieDetail => _selectedMovieDetail;
  List<Movie> get similarMovies => _similarMovies;

  bool get isLoadingPopular => _isLoadingPopular;
  bool get isLoadingTrending => _isLoadingTrending;
  bool get isLoadingTopRated => _isLoadingTopRated;
  bool get isSearching => _isSearching;
  bool get isLoadingDetail => _isLoadingDetail;

  String? get error => _error;

  /// Fetch popular movies
  Future<void> fetchPopularMovies() async {
    _isLoadingPopular = true;
    _error = null;
    notifyListeners();

    try {
      _popularMovies = await _apiService.getPopularMovies();
      _isLoadingPopular = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingPopular = false;
      notifyListeners();
    }
  }

  /// Fetch trending movies
  Future<void> fetchTrendingMovies() async {
    _isLoadingTrending = true;
    _error = null;
    notifyListeners();

    try {
      _trendingMovies = await _apiService.getTrendingMovies();
      _isLoadingTrending = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingTrending = false;
      notifyListeners();
    }
  }

  /// Fetch top rated movies
  Future<void> fetchTopRatedMovies() async {
    _isLoadingTopRated = true;
    _error = null;
    notifyListeners();

    try {
      _topRatedMovies = await _apiService.getTopRatedMovies();
      _isLoadingTopRated = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingTopRated = false;
      notifyListeners();
    }
  }

  /// Search movies
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchMovies(query);
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  /// Fetch movie details
  Future<void> fetchMovieDetails(int movieId) async {
    _isLoadingDetail = true;
    _error = null;
    notifyListeners();

    try {
      _selectedMovieDetail = await _apiService.getMovieDetails(movieId);
      _similarMovies = await _apiService.getSimilarMovies(movieId);
      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  /// Clear selected movie detail
  void clearMovieDetail() {
    _selectedMovieDetail = null;
    _similarMovies = [];
    notifyListeners();
  }
}