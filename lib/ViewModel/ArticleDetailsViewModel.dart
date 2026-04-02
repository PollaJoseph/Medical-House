import 'package:flutter/material.dart';
import 'package:medical_house/Model/ArticleDetailModel.dart';
import 'package:medical_house/Services/ApiService.dart';

class ArticleDetailsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ArticleDetailModel? _article;
  ArticleDetailModel? get article => _article;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? errorMessage;

  Future<void> loadArticleDetails(String articleId) async {
    try {
      _article = await _apiService.getArticleById(articleId);
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception:", "");
      debugPrint("Error fetching article details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
