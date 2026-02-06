import 'genre.dart';

class MovieDetail {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<Genre> genres;
  final int runtime;
  final String status;
  final String? tagline;

  MovieDetail({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genres,
    required this.runtime,
    required this.status,
    this.tagline,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromJson(g))
          .toList() ??
          [],
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'],
    );
  }

  String? get fullPosterPath {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String? get fullBackdropPath {
    if (backdropPath == null) return null;
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }

  String get releaseYear {
    if (releaseDate.isEmpty) return 'N/A';
    return releaseDate.split('-')[0];
  }

  double get rating {
    return voteAverage / 2;
  }

  String get formattedRuntime {
    if (runtime == 0) return 'N/A';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}h ${minutes}m';
  }
}