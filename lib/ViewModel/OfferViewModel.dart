import 'package:flutter/material.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/View/ServiceDetailsView.dart';

class OffersViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;

  Map<String, List<ServiceModel>> groupedOffers = {};

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
