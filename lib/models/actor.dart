class Actor {
  String? name;
  String? character;
  String? profilePath;

  Actor({
    name,
    character,
    profilePath
  });

  Actor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    character = json['character'];
    profilePath= json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['character'] = character;
    data['profile_path'] = profilePath;

    return data;
  }
}
