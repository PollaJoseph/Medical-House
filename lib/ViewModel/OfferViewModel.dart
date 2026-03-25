import 'package:flutter/material.dart';
import 'package:medical_house/Model/OfferModel.dart';
import 'package:medical_house/Services/ApiService.dart';

class OffersViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;

  Map<String, List<OfferModel>> groupedOffers = {};

  OffersViewModel() {
    Future.microtask(() => fetchOffers());
  }

  Future<void> fetchOffers() async {
    isLoading = true;
    notifyListeners();

    try {
      groupedOffers = await _apiService.getOffers();
    } catch (e) {
      debugPrint("Error fetching offers: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onOfferTap(OfferModel offer) {
    debugPrint("Selected Offer: ${offer.title}");
    // TODO: Add navigation to a detailed offer view or booking screen
  }
}
