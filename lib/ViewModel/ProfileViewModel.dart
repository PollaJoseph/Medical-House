import 'package:flutter/material.dart';
import 'package:medical_house/Model/UserProfileModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserProfileModel? _user;
  UserProfileModel? get user => _user;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();
    try {
      String? clientId = await StorageService.getUserClientId();
      if (clientId != null) {
        _user = await _apiService.getUserProfile(clientId);
      }
    } catch (e) {
      debugPrint("Profile fetch error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteUserAccount() async {
    try {
      String? clientId = await StorageService.getUserClientId();
      if (clientId != null) {
        final response = await _apiService.deleteAccount(clientId);
        if (response.statusCode == 200) {
          await StorageService.clearTokens();
          await StorageService.clearUserClientId();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Delete account error: $e");
      return false;
    }
  }
}
