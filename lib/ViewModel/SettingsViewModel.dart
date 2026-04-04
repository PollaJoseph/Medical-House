import 'package:flutter/material.dart';
import 'package:medical_house/Model/UserProfileModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';

class SettingsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserProfileModel? _userProfile;
  UserProfileModel? get userProfile => _userProfile;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? clientId = await StorageService.getUserClientId();
      if (clientId != null) {
        _userProfile = await _apiService.getUserProfile(clientId);
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
