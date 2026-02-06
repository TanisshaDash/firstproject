import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Load from environment variables
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';

  // Image URLs
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String posterSize = 'w500';
  static const String backdropSize = 'original';


  // API endpoints
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String trendingMovies = '/trending/movie/week';
  static const String searchMovies = '/search/movie';
}