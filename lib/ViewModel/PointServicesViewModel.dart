import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:medical_house/Localization/LocaleController.dart';
import 'package:medical_house/Model/PointServiceModel.dart';
import 'package:medical_house/Model/ServiceModel.dart'; // 1. ADD THIS IMPORT
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/View/ServiceDetailsView.dart';

class PointServicesViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocaleController _localeController = Get.find<LocaleController>();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? errorMessage;

  Map<String, List<PointServiceModel>> _groupedServices = {};
  Map<String, List<PointServiceModel>> get groupedServices => _groupedServices;

  Future<void> loadServices() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String langPrefix = _localeController.isArabic.value ? "ar/" : "en/";
      _groupedServices = await _apiService.getPointsServices(langPrefix);
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception:", "");
      debugPrint("Error fetching point services: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onServiceTap(BuildContext context, PointServiceModel pointService) {
    final convertedService = ServiceModel(
      id: pointService.serviceId,
      title: pointService.name,
      description: pointService.description,
      price: pointService.points,
      imageUrl: pointService.image,
      discountTag: pointService.tag,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ServiceDetailsView(service: convertedService, isPointService: true),
      ),
    );
  }
}
