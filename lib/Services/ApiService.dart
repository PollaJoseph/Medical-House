import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medical_house/Model/SignUpAPIModel.dart';
import 'package:medical_house/Services/StorageService.dart';

class ApiService {
  final Dio _dio = Dio();

  //URL
  /*static String globalBaseUrl = "https://1281-41-43-175-104.ngrok-free.app/";
  String get baseUrl => globalBaseUrl;*/

  final String baseUrl = "https://d511-156-196-10-228.ngrok-free.app/";
  //dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  String? _authToken;

  ApiService();

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> getHeaders({bool includeAuth = false}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-API-KEY': apiKey,
      'ngrok-skip-browser-warning': 'true',
    };

    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // Refresh Token
  /* Future<String> refreshToken(String refreshToken) async {
    try {
      final headers = getHeaders(includeAuth: false);
      headers['Refresh-Token'] = refreshToken;

      final response = await _dio.post(
        '$baseUrl$refreshTokenEndpoint',
        data: {'refresh': refreshToken},
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        final newRefreshToken = response.data['refresh'];

        if (newAccessToken != null &&
            newAccessToken is String &&
            newRefreshToken != null &&
            newRefreshToken is String) {
          await StorageService.saveTokens(newAccessToken, newRefreshToken);
          setAuthToken(newAccessToken);
          return newAccessToken;
        } else {
          throw Exception('Access or Refresh token not found in the response.');
        }
      } else {
        throw Exception(
          'Failed to refresh token with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      await StorageService.clearTokens();
      clearAuthToken();
      throw Exception(
        'Error refreshing token: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }*/

  Future<Response> signUp(SignUpAPIModel user) async {
    try {
      FormData formattedData = await user.toFormData();

      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      requestHeaders.remove('Content-Type');

      final response = await _dio.post(
        '${baseUrl}Users/SignUp/',
        data: formattedData,
        options: Options(headers: requestHeaders),
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Sign Up Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
