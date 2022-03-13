import '../models/actor.dart';
import '../models/movies.dart';
import '../models/reviews.dart';

import '../api/tmdb.dart';

class MoviesRepository {
  static final MoviesRepository _moviesRepository = MoviesRepository._();
  static const num _perPage = 20;

  MoviesRepository._();

  factory MoviesRepository() {
    return _moviesRepository;
  }

  Future<Movies> getMovies({
    required num page,
  }) async {
    return await TMDB().getMovies(page, _perPage);
  }

  Future<Movies> findMovies({
    required num page,
    required String query,
  }) async {
    return await TMDB().findMovies(page, _perPage, query);
  }

  Future<List<Actor>> getPersonsForMovie({
    required num movieId,
  }) async {
    return await TMDB().getActorsByMovie(movieId);
  }

  Future<Reviews> getReviewsForMovie({
    required num movieId,
  }) async {
    return await TMDB().getRecommendationsByMovie(movieId);
  }
}
