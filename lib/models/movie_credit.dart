class MovieCredit {
  String? backdropPath;
  String? posterPath;
  String? title;
  String? character;
  num? voteAverage;

  MovieCredit({backdropPath, posterPath, title, character});

  MovieCredit.fromJson(Map<String, dynamic> json) {
    backdropPath = json['backdrop_path'];
    posterPath = json['poster_path'];
    title = json['title'];
    character = json['character'];
    voteAverage = json['vote_average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backdrop_path'] = backdropPath;
    data['poster_path'] = posterPath;
    data['title'] = title;
    data['character'] = character;
    data['vote_average'] = voteAverage;

    return data;
  }
}
