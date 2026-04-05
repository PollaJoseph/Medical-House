import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medical_house/Components/CustomSnackBar.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/HomeModel.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/View/SectionDetailView.dart';

class HomeViewModel extends ChangeNotifier {
  late final PatientProfile currentUser;
  final ApiService _apiService = ApiService();

  bool isLoading = false;

  HomeViewModel({String? name, String? imageUrl, int? points}) {
    currentUser = PatientProfile(
      name: name ?? "Guest User".tr,
      imageUrl: imageUrl ?? Constants.MaleAvatarImagePath,
      points: points ?? 0,
    );
  }

  final List<HospitalSection> hospitalSections = [
    HospitalSection(
      mainTitle: "Dermatology & Cosmetology".tr,
      imageUrl: Constants.DermatologySectionImagePath,
      subSections: [],
    ),
    HospitalSection(
      mainTitle: "Dental Department".tr,
      imageUrl: Constants.DentalSectionImagePath,
      subSections: [],
    ),
  ];

  Future<void> openSection(
    BuildContext context,
    HospitalSection section,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      List<ServiceModel> fetchedServices = await _apiService
          .getServicesByCategory(section.mainTitle);
      section.subSections.clear();
      section.subSections.addAll(fetchedServices);

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectionDetailView(section: section),
          ),
        );
      }
    } catch (e) {
      debugPrint("API Error: $e");
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          title: "Error".tr,
          message: "Failed to load services. Please check your connection.".tr,
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
