import 'package:flutter/material.dart';
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
      name: name ?? "Guest User",
      imageUrl: imageUrl ?? Constants.MaleAvatarImagePath,
      points: points ?? 0,
    );
  }

  final List<HospitalSection> hospitalSections = [
    HospitalSection(
      mainTitle: "Dermatology & Cosmetology",
      imageUrl: Constants.DermatologySectionImagePath,
      subSections: [], // Now expects ServiceModel objects
    ),
    HospitalSection(
      mainTitle: "Dental Department",
      imageUrl: Constants.DentalSectionImagePath,
      subSections: [], // Now expects ServiceModel objects
    ),
  ];

  Future<void> openSection(
    BuildContext context,
    HospitalSection section,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch the data
      List<ServiceModel> fetchedServices = await _apiService
          .getServicesByCategory(section.mainTitle);

      // 2. Clear the old list
      section.subSections.clear();

      // 3. FIXED: Just add the fetched services directly! No .map() needed.
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Failed to load services. Please check your connection.",
            ),
            backgroundColor: Color(0xFFFF4B4B),
          ),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
