import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:medical_house/Localization/LocaleController.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/View/ServiceDetailsView.dart';

class OffersViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocaleController _localeController = Get.find<LocaleController>();
  bool isLoading = false;

  Map<String, List<ServiceModel>> groupedOffers = {};

  OffersViewModel() {
    Future.microtask(() => fetchOffers());
  }

  Future<void> fetchOffers() async {
    isLoading = true;
    notifyListeners();

    try {
      String langPrefix = _localeController.isArabic.value ? "ar/" : "en/";
      groupedOffers = await _apiService.getOffers(langPrefix);
    } catch (e) {
      debugPrint("Error fetching offers: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onOfferTap(BuildContext context, ServiceModel offer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ServiceDetailsView(service: offer, isPointService: false),
      ),
    );
  }
}
