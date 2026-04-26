import 'package:flutter/foundation.dart';
import 'package:medical_house/Services/StorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isReadyToNavigate = false;
  bool _showOnboarding = true;
  bool _isLoggedIn = false;
  String? _username;
  String? _userImage;
  String? _points;

  bool get isReadyToNavigate => _isReadyToNavigate;
  bool get showOnboarding => _showOnboarding;
  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get userImage => _userImage;
  String? get points => _points;

  Future<void> loadAppDependencies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _showOnboarding = !(prefs.getBool('has_seen_onboarding') ?? false);

      final userData = await StorageService.getUserData();

      if (userData['clientId'] != null) {
        _isLoggedIn = true;
        _username = userData['username'];
        _userImage = userData['image'];
        _points = userData['points'];
      }

      await Future.wait([
        Future.delayed(const Duration(milliseconds: 3000)),
        _fetchRemoteData(),
      ]);

      _isReadyToNavigate = true;
      notifyListeners();
    } catch (e) {
      _isReadyToNavigate = true;
      notifyListeners();
    }
  }

  Future<void> _fetchRemoteData() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
