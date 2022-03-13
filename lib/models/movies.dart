import 'movie.dart';

class Movies {
  num? page;
  List<Movie>? results = List.empty();

  Movies({page, results});

  Movies.fromJson(Map<String, dynamic> json) {
    //page = json['page'];
    results =json['results'].map((item) => Movie.fromJson(item)).toList().cast<Movie>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['results'] = results;
    return data;
  }

  @override
  String toString() {
    return "Page: $page, " + results.toString();
  }
}
