class MusicTrack {
  int? id;
  String? title;
  String? performer;
  String? fileName;
  String? coverPicture;

  MusicTrack({id, title, performer, fileName, coverPicture});

  MusicTrack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    performer = json['performer'];
    fileName = json['filename'];
    coverPicture = json['coverPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['performer'] = performer;
    data['filename'] = fileName;
    data['coverPicture'] = coverPicture;
    return data;
  }
}
