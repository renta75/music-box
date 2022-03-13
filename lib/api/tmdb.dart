import 'package:dio/dio.dart';
import '../models/movie_credit.dart';
import '../models/reviews.dart';
import '../models/actor.dart';
import '../models/movies.dart';
import '../models/people.dart';

class TMDB {
  final Dio _dio = Dio();
  static const String baseURL = "https://api.themoviedb.org";
  static const String apiKey = "5f4d74b236569a40ee02c5a90457e6b9";

  Future<Movies> getMovies(num page, num perPage) async {
    String url = "/3/discover/movie";

    Response response = await _dio
        .get(baseURL + url + "?api_key=" + apiKey + "&page=" + page.toString());
    var apidata = response.data;

    Movies movies = Movies.fromJson(apidata);

    return movies;
  }

  Future<Movies> findMovies(num page, num perPage, String searchText) async {
    String url = "/3/search/movie";

    Response response = await _dio.get(baseURL +
        url +
        "?api_key=" +
        apiKey +
        "&page=" +
        page.toString() +
        "&query=" +
        searchText);
    var apidata = response.data;

    Movies movies = Movies.fromJson(apidata);

    return movies;
  }

  Future<People> findPeople(num page, num perPage, String searchText) async {
    String url = "/3/search/person";

    Response response = await _dio.get(baseURL +
        url +
        "?api_key=" +
        apiKey +
        "&page=" +
        page.toString() +
        "&query=" +
        searchText);
    var apidata = response.data;

    People people = People.fromJson(apidata);

    return people;
  }

  Future<Reviews> getRecommendationsByMovie(num movieId) async {
    String url = '/3/movie/$movieId/reviews';

    Response response = await _dio.get(baseURL + url + "?api_key=" + apiKey);
    var apidata = response.data;

    Reviews reviews = Reviews.fromJson(apidata);

    return reviews;
  }

  Future<List<Actor>> getActorsByMovie(num movieId) async {
    String url = '/3/movie/$movieId/credits';

    Response response = await _dio.get(baseURL + url + "?api_key=" + apiKey);
    var apidata = response.data;

    List<Actor> actors = apidata['cast']
        .map((item) => Actor.fromJson(item))
        .toList()
        .cast<Actor>();

    return actors;
  }

  Future<List<MovieCredit>> getMoviesByActor(num personId) async {
    String url = '/3/person/$personId/movie_credits';

    Response response = await _dio.get(baseURL + url + "?api_key=" + apiKey);
    var apidata = response.data;

    List<MovieCredit> credits = apidata["cast"]
        .map((item) => MovieCredit.fromJson(item))
        .toList()
        .cast<MovieCredit>();

    return credits;
  }
}
