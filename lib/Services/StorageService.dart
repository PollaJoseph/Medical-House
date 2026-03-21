import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> saveTokens(String access, String refresh) async {
    await _secureStorage.write(key: 'access_token', value: access);
    await _secureStorage.write(key: 'refresh_token', value: refresh);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  static Future<void> clearTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  ////////////////////////////////////////////////////////////////////
  static Future<void> saveUserClientId(String clientId) async {
    await _secureStorage.write(key: 'user_client_id', value: clientId);
  }

  static Future<String?> getUserClientId() async {
    return await _secureStorage.read(key: 'user_client_id');
  }

  static Future<void> clearUserClientId() async {
    await _secureStorage.delete(key: 'user_client_id');
  }
}
