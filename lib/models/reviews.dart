import 'review.dart';

class Reviews {
  num? page;
  List<Review>? results = List.empty();

  Reviews({page, results});

  Reviews.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    results =json['results'].map((item) => Review.fromJson(item)).toList().cast<Review>();
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
