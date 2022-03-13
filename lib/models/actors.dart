import 'actor.dart';

class Actors {
  num? page;
  List<Actor>? results = List.empty();

  Actors({page, results});

  Actors.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    results = json['results']
        .map((item) => Actor.fromJson(item))
        .toList()
        .cast<Actor>();
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
