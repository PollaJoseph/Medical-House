import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medical_house/Localization/LocaleController.dart';
import 'package:medical_house/Model/ArticleModel.dart';
import 'package:medical_house/Services/ApiService.dart';

class ArticlesViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocaleController _localeController = Get.find<LocaleController>();
  List<ArticleModel> _allArticles = [];
  String _selectedCategory = "All";
  bool _isLoading = true;

  List<ArticleModel> get filteredArticles {
    if (_selectedCategory == "All".tr) {
      return _allArticles;
    }
    return _allArticles
        .where((a) => a.category.tr == _selectedCategory)
        .toList();
  }

  List<String> get availableCategories {
    final Set<String> categories = {
      "All".tr,
      "Dental".tr,
      "Dermatology & Cosmetology".tr,
      "General".tr,
    };

    for (var article in _allArticles) {
      if (article.category.isNotEmpty) {
        categories.add(article.category.tr);
      }
    }

    return categories.toList();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadArticles() async {
    _isLoading = true;
    notifyListeners();
    try {
      String langPrefix = _localeController.isArabic.value ? "ar/" : "en/";
      _allArticles = await _apiService.getArticlesMeta(langPrefix);
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
