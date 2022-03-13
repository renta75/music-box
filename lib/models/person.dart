class Person {
  num? id;
  String? name;
  String? profilePath;
  num? popularity;

  Person({name, profilePath, popularity});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePath = json['profile_path'];
    popularity = json['popularity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profile_path'] = profilePath;
    data['popularity'] = popularity;

    return data;
  }
}
