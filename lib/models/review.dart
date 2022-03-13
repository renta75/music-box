class Review {
  String? author;
  String? content;
  
  Review(
      {author,
      content,
      });

  Review.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author'] = author;
    data['content'] = content;
    
    return data;
  }
}
