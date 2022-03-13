import 'person.dart';

class People {
  num? page;
  List<Person>? results = List.empty();

  People({page, results});

  People.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    results = json['results']
        .map((item) => Person.fromJson(item))
        .toList()
        .cast<Person>();
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
