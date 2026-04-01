class ArticleModel {
  final String articleId;
  final String name;
  final String authorUsername;
  final String authorImage;
  final String category;
  final String createdAt;
  final String shortDescription;
  final String? articleImage;

  ArticleModel({
    required this.articleId,
    required this.name,
    required this.authorUsername,
    required this.authorImage,
    required this.category,
    required this.createdAt,
    required this.shortDescription,
    this.articleImage,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      articleId: json['ArticleID'] ?? '',
      name: json['Name'] ?? 'Untitled Article',
      authorUsername: json['AuthorUsername'] ?? 'Anonymous',
      authorImage:
          json['AuthorImage'] ?? 'https://ui-avatars.com/api/?name=Admin',
      category: json['Category'] ?? 'General',
      createdAt: json['CreatedAt'] ?? '',
      shortDescription: json['ShortDescription'] ?? 'No description available.',
      articleImage: json['ArticleImage'],
    );
  }
}
