import 'package:flutter/material.dart';
import 'package:medical_house/Model/BookingRequestModel.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';

class ServiceDetailsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isBooking = false;
  bool get isBooking => _isBooking;

  DateTime? selectedDateTime;

  Future<void> bookNow({
    required BuildContext context,
    required ServiceModel service,
  }) async {
    if (selectedDateTime == null) {
      _showSnackBar(
        context,
        "Please select a booking date and time",
        const Color(0xFFFF4B4B),
      );
      return;
    }

    _setLoading(true);

    final clientId = await StorageService.getUserClientId();

    try {
      final bookingRequest = BookingRequestModel(
        serviceId: service.id,
        clientId: clientId!,
        bookingTime: selectedDateTime!.toIso8601String(),
      );

      final response = await _apiService.bookService(bookingRequest);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(context, "Booking successful!", Colors.green);
        if (context.mounted) Navigator.pop(context);
      }
    } catch (e) {
      _showSnackBar(
        context,
        e.toString().replaceAll("Exception:", ""),
        const Color(0xFFFF4B4B),
      );
    } finally {
      _setLoading(false);
    }
  }

  // Update the date and notify the UI
  void updateSelectedDate(DateTime dt) {
    selectedDateTime = dt;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isBooking = value;
    notifyListeners();
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
