import 'package:flutter/material.dart';
import 'package:medical_house/Model/BookingRequestModel.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';

class ServiceDetailsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isBooking = false;
  bool get isBooking => _isBooking;

  bool _isLoadingSlots = true;
  bool get isLoadingSlots => _isLoadingSlots;

  List<DateTime> _unavailableSlots = [];
  DateTime? selectedDateTime;

  final int clinicOpenHour = 8;
  final int clinicCloseHour = 24;
  final int slotDurationMinutes = 30;

  Future<void> fetchUnavailableSlots(String serviceId) async {
    _isLoadingSlots = true;
    notifyListeners();

    try {
      List<String> rawSlots = await _apiService.getUnavailableSlots(serviceId);
      // FIXED: Added .toLocal() to correctly handle the +02:00 API offset
      _unavailableSlots = rawSlots
          .map((iso) => DateTime.parse(iso).toLocal())
          .toList();
    } catch (e) {
      debugPrint("Error fetching unavailable slots: $e");
    } finally {
      _isLoadingSlots = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> generateTimeSlotsForDate(DateTime date) {
    List<Map<String, dynamic>> slots = [];
    DateTime currentSlot = DateTime(
      date.year,
      date.month,
      date.day,
      clinicOpenHour,
      0,
    );
    DateTime endSlot = DateTime(
      date.year,
      date.month,
      date.day,
      clinicCloseHour,
      0,
    );

    while (currentSlot.isBefore(endSlot)) {
      bool isAvailable = !isSlotUnavailable(currentSlot);
      // Ensure past times today are also marked unavailable
      if (currentSlot.isBefore(DateTime.now())) isAvailable = false;

      // Format to 12-hour AM/PM string
      int hour12 = currentSlot.hour % 12 == 0 ? 12 : currentSlot.hour % 12;
      String period = currentSlot.hour >= 12 ? 'PM' : 'AM';
      String timeString =
          "$hour12:${currentSlot.minute.toString().padLeft(2, '0')} $period";

      slots.add({
        "timeString": timeString,
        "dateTime": currentSlot,
        "isAvailable": isAvailable,
      });

      currentSlot = currentSlot.add(Duration(minutes: slotDurationMinutes));
    }
    return slots;
  }

  bool isDayFullyBooked(DateTime date) {
    int bookedCount = _unavailableSlots
        .where(
          (dt) =>
              dt.year == date.year &&
              dt.month == date.month &&
              dt.day == date.day,
        )
        .length;
    // Assuming 32 slots a day (8 AM to 24 PM)
    return bookedCount >= 32;
  }

  bool isSlotUnavailable(DateTime dateTime) {
    return _unavailableSlots.any(
      (dt) =>
          dt.year == dateTime.year &&
          dt.month == dateTime.month &&
          dt.day == dateTime.day &&
          dt.hour == dateTime.hour &&
          dt.minute == dateTime.minute,
    );
  }

  void updateSelectedDate(DateTime dt) {
    selectedDateTime = dt;
    notifyListeners();
  }

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

    _isBooking = true;
    notifyListeners();

    final clientId = await StorageService.getUserClientId();
    if (clientId == null) {
      _showSnackBar(
        context,
        "Authentication error. Please log in again.",
        const Color(0xFFFF4B4B),
      );
      _isBooking = false;
      notifyListeners();
      return;
    }

    try {
      final bookingRequest = BookingRequestModel(
        serviceId: service.id,
        clientId: clientId,
        bookingTime: selectedDateTime!
            .toIso8601String(), // Converts local back to ISO for API
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
      _isBooking = false;
      notifyListeners();
    }
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
