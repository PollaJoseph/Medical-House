import 'package:flutter/material.dart';
import 'package:medical_house/Model/ArticleModel.dart';
import 'package:medical_house/Services/ApiService.dart';

class ArticlesViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ArticleModel> _allArticles = [];
  String _selectedCategory = "All";
  bool _isLoading = true;

  List<ArticleModel> get filteredArticles => _selectedCategory == "All"
      ? _allArticles
      : _allArticles.where((a) => a.category == _selectedCategory).toList();

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadArticles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allArticles = await _apiService.getArticlesMeta();
    } catch (e) {
      debugPrint("Error loading articles: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
