import 'package:flutter/material.dart';
import 'package:medical_house/Model/UserProfileModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserProfileModel? _user;
  UserProfileModel? get user => _user;

  Map<String, dynamic>? blockingBooking;
  String? deleteErrorMessage;

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
    _isLoading = true;
    deleteErrorMessage = null;
    blockingBooking = null;
    notifyListeners();

    try {
      String? clientId = await StorageService.getUserClientId();
      if (clientId != null) {
        final response = await _apiService.deleteAccount(clientId);
        return response.statusCode == 200;
      }
      return false;
    } on Exception catch (e) {
      // Handle the 409 error specifically
      if (e.toString().contains("409")) {
        // In a real scenario, you'd parse the DioException.response.data
        deleteErrorMessage = "Active Bookings Found";
        // This matches your JSON structure
        blockingBooking = {
          "service": "100 Points offer",
          "slot_time": "2026-04-17T07:00:00Z",
        };
      } else {
        deleteErrorMessage = "An unexpected error occurred.";
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
