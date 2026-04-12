import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medical_house/Model/ArticleDetailModel.dart';
import 'package:medical_house/Model/ArticleModel.dart';
import 'package:medical_house/Model/BookingRequestModel.dart';
import 'package:medical_house/Model/LoginAPIModel.dart';
import 'package:medical_house/Model/OTPVerificationModel.dart';
import 'package:medical_house/Model/PointServiceModel.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Model/ResendOTP.dart';
import 'package:medical_house/Model/SignUpAPIModel.dart';
import 'package:medical_house/Model/UserProfileModel.dart';
import 'package:medical_house/Services/StorageService.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = "https://0e6d-41-42-67-56.ngrok-free.app/";
  //dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String SignUpEndpoint = dotenv.env['SIGN_UP_ENDPOINT'] ?? '';
  final String GoogleSignUpEndpoint =
      dotenv.env['GOOGLE_SIGN_UP_ENDPOINT'] ?? '';
  final String VerifyOtpEndpoint = dotenv.env['VERIFY_OTP_ENDPOINT'] ?? '';
  final String ResendOtpEndpoint = dotenv.env['RESEND_OTP_ENDPOINT'] ?? '';
  final String LoginEndpoint = dotenv.env['LOGIN_ENDPOINT'] ?? '';
  final String OfferEndpoint = dotenv.env['OFFER_ENDPOINT'] ?? '';
  final String DermatologyServiceEndPoint =
      dotenv.env['DERMATOLOGY_SERVICE-ENDPOINT'] ?? '';
  final String BookingEndpoint = dotenv.env['BOOKING_ENDPOINT'] ?? '';
  final String BookingTimeEndpoint =
      dotenv.env['UNAVAILABLE_SLOT_ENDPOINT'] ?? '';
  final String ArticlesMetaEndpoint = dotenv.env['ARTICLES_ENDPOINT'] ?? '';
  final String ArticleDetailsEndpoint =
      dotenv.env['ARTICLES_DETAILS_ENDPOINT'] ?? '';
  final String PointServicesEndpoint =
      dotenv.env['POINT_SERVICES_ENDPOINT'] ?? '';
  final String GetUserEndpoint = dotenv.env['USER_ENDPOINT'] ?? '';
  final String DeleteUserEndpoint = dotenv.env['DELETE_USER_ENDPOINT'] ?? '';
  final String SendPasswordEndpoint =
      dotenv.env['SEND_OTP_FORGET_PASSWORD_ENDPOINT'] ?? '';
  final String ResetPasswordOTPEndpoint =
      dotenv.env['VERIFY_FORGET_PASSWORD_OTP_ENDPOINT'] ?? '';
  final String ResetPasswordEndpoint =
      dotenv.env['RESET_PASSWORD_ENDPOINT'] ?? '';

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

  Future<Map<String, List<ServiceModel>>> getOffers() async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.get(
        '$baseUrl$OfferEndpoint',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> rawData = response.data;
        Map<String, List<ServiceModel>> parsedOffers = {};

        rawData.forEach((sectionName, offersList) {
          if (offersList is List) {
            parsedOffers[sectionName] = offersList
                .map((offerJson) => ServiceModel.fromJson(offerJson))
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

  Future<List<ServiceModel>> getServicesByCategory(String categoryName) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.get(
        '$baseUrl$DermatologyServiceEndPoint$categoryName/',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        List<dynamic> rawData = response.data;
        return rawData.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw Exception(
          "Failed to load services. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed fetching services for $categoryName: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> bookService(BookingRequestModel data) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.post(
        '$baseUrl$BookingEndpoint',
        data: data.toJson(),
        options: Options(headers: requestHeaders),
      );

      return response;
    } on DioException catch (e) {
      throw Exception('Booking Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<String>> getUnavailableSlots(String serviceId) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.get(
        '$baseUrl$BookingTimeEndpoint$serviceId/',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        // The response is a JSON array of strings
        List<dynamic> rawData = response.data;
        return rawData.map((slot) => slot.toString()).toList();
      } else {
        throw Exception(
          "Failed to load time slots. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed fetching booking times: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<ArticleModel>> getArticlesMeta() async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.get(
        '$baseUrl$ArticlesMetaEndpoint',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        List<dynamic> rawData = response.data;

        return rawData.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        throw Exception(
          "Failed to load articles. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed fetching articles: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<ArticleDetailModel> getArticleById(String articleId) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);
      final response = await _dio.get(
        '$baseUrl$ArticleDetailsEndpoint$articleId/',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        return ArticleDetailModel.fromJson(response.data);
      } else {
        throw Exception(
          "Failed to load article details. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed fetching article details: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, List<PointServiceModel>>> getPointsServices() async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.get(
        '$baseUrl$PointServicesEndpoint',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> rawData = response.data;
        Map<String, List<PointServiceModel>> parsedPointsServices = {};

        rawData.forEach((categoryName, servicesList) {
          if (servicesList is List) {
            parsedPointsServices[categoryName] = servicesList
                .map((serviceJson) => PointServiceModel.fromJson(serviceJson))
                .toList();
          }
        });

        return parsedPointsServices;
      } else {
        throw Exception(
          "Failed to load points services. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed fetching points services: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<UserProfileModel> getUserProfile(String clientId) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: true);

      final response = await _dio.get(
        '$baseUrl$GetUserEndpoint$clientId/',
        options: Options(headers: requestHeaders),
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception(
          "Failed to load user profile. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed fetching user profile: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> deleteAccount(String clientId) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: true);
      final response = await _dio.delete(
        '$baseUrl$DeleteUserEndpoint$clientId/',
        options: Options(headers: requestHeaders),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
        'Delete Account Failed: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> sendPassword(String email) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.post(
        '$baseUrl$SendPasswordEndpoint',
        data: {"Email": email},
        options: Options(headers: requestHeaders),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Request Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> verifyResetPasswordOTP(String email, String otp) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.post(
        '$baseUrl$ResetPasswordOTPEndpoint',
        data: {"Email": email, "OTP": otp},
        options: Options(headers: requestHeaders),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Verification Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Response> resetPassword(String email, String newPassword) async {
    try {
      Map<String, String> requestHeaders = getHeaders(includeAuth: false);

      final response = await _dio.post(
        '$baseUrl$ResetPasswordEndpoint',
        data: {"Email": email, "NewPassword": newPassword},
        options: Options(headers: requestHeaders),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Reset Failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
