class ArticleDetailModel {
  final String articleId;
  final String name;
  final String content;
  final String authorUsername;
  final String category;
  final String createdAt;

  ArticleDetailModel({
    required this.articleId,
    required this.name,
    required this.content,
    required this.authorUsername,
    required this.category,
    required this.createdAt,
  });

  factory ArticleDetailModel.fromJson(Map<String, dynamic> json) {
    return ArticleDetailModel(
      articleId: json['article_id'] ?? '',
      name: json['name'] ?? '',
      content: json['content'] ?? '',
      authorUsername: json['author__username'] ?? 'Unknown',
      category: json['category'] ?? 'General',
      createdAt: json['created_at'] ?? '',
    );
  }
}
