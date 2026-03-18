import 'package:flutter/foundation.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isReadyToNavigate = false;

  bool get isReadyToNavigate => _isReadyToNavigate;

  Future<void> loadAppDependencies() async {
    try {
      debugPrint("ViewModel: Starting background initialization...");

      await Future.wait([
        Future.delayed(const Duration(milliseconds: 3000)),

        _fetchRemoteData(),
      ]);

      _isReadyToNavigate = true;
      debugPrint("ViewModel: Initialization complete.");
      notifyListeners();
    } catch (e) {
      debugPrint("Error initializing app: $e");
      _isReadyToNavigate = true;
      notifyListeners();
    }
  }

  Future<void> _fetchRemoteData() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
