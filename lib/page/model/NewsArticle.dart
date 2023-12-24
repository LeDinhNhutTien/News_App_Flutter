class NewsArticle {
  final String image;
  final String title;
  final String author;
  final String description;
  final String url;
  final String type;
  final String date;

  NewsArticle({
    required this.image,
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.type,
    required this.date,
  });

  static String _extractImage(String content) {
    // Extract the first image from the content
    RegExp regex = RegExp(r'<img[^>]+src="([^">]+)"');
    Match? match = regex.firstMatch(content);

    return match?.group(1) ?? '';
  }

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      image: _extractImage(json['content'] ?? ''),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      type: 'Báo thế giới',
      date: json['published_date'] ?? '',
    );
  }

  factory NewsArticle.fromJsonDB(Map<String, dynamic> json) {
    return NewsArticle(
      image: json['image'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      date: json['create_at'] as String,
    );
  }
}
