// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medical_house/Model/LoginAPIModel.dart';
import 'package:medical_house/Model/OTPVerificationModel.dart';
import 'package:medical_house/Model/OfferModel.dart';
import 'package:medical_house/Model/ResendOTP.dart';
import 'package:medical_house/Model/SignUpAPIModel.dart';
import 'package:medical_house/Services/StorageService.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = "https://1f70-156-196-215-175.ngrok-free.app/";
  //dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String SignUpEndpoint = dotenv.env['SIGN_UP_ENDPOINT'] ?? '';
  final String GoogleSignUpEndpoint =
      dotenv.env['GOOGLE_SIGN_UP_ENDPOINT'] ?? '';
  final String VerifyOtpEndpoint = dotenv.env['VERIFY_OTP_ENDPOINT'] ?? '';
  final String ResendOtpEndpoint = dotenv.env['RESEND_OTP_ENDPOINT'] ?? '';
  final String LoginEndpoint = dotenv.env['LOGIN_ENDPOINT'] ?? '';
  final String OfferEndpoint = dotenv.env['OFFER_ENDPOINT'] ?? '';

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
        '$baseUrl$SignUpEndpoint',
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

  Future<Response> googleLogin(String accessToken) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.post(
        '$baseUrl$GoogleSignUpEndpoint',
        data: {'access_token': accessToken},
        options: Options(headers: requestHeaders),
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Google Login Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> verifyEmail(
    EmailVerificationModel data,
    String clientId,
  ) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);
      final response = await _dio.post(
        '$baseUrl$VerifyOtpEndpoint$clientId/',
        data: data.toJson(),
        options: Options(headers: requestHeaders),
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Verification Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> resendOTP(ResendOTPModel data) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.post(
        '$baseUrl$ResendOtpEndpoint',
        data: data.toJson(),
        options: Options(headers: requestHeaders),
      );

      return response;
    } on DioException catch (e) {
      throw Exception(
        'Failed to resend code: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> login(LoginRequestModel data) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.post(
        '$baseUrl$LoginEndpoint',
        data: data.toJson(),
        options: Options(headers: requestHeaders),
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Login Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, List<OfferModel>>> getOffers() async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.get(
        '$baseUrl$OfferEndpoint',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> rawData = response.data;
        Map<String, List<OfferModel>> parsedOffers = {};

        rawData.forEach((sectionName, offersList) {
          if (offersList is List) {
            parsedOffers[sectionName] = offersList
                .map((offerJson) => OfferModel.fromJson(offerJson))
                .toList();
          }
        });

        return parsedOffers;
      } else {
        throw Exception(
          "Failed to load offers. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed fetching offers: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
