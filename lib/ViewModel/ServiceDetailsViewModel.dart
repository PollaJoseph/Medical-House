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

  // Stores ALL available slots returned from API
  List<DateTime> _availableSlotsFromApi = [];

  // Selected state
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  String? _selectedTimeSlot;
  String? get selectedTimeSlot => _selectedTimeSlot;

  DateTime? selectedDateTime;

  final int clinicOpenHour = 9;
  final int clinicCloseHour = 21;
  final int slotDurationMinutes = 30;

  // 2. NEW: Generate ALL slots for the selected date and check availability
  List<Map<String, dynamic>> get allTimesForSelectedDate {
    List<Map<String, dynamic>> slots = [];

    // Start at opening time
    DateTime currentSlot = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      clinicOpenHour,
      0,
    );

    DateTime endSlot = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      clinicCloseHour,
      0,
    );

    while (currentSlot.isBefore(endSlot)) {
      bool isAvailable = _availableSlotsFromApi.any(
        (apiDate) =>
            apiDate.year == currentSlot.year &&
            apiDate.month == currentSlot.month &&
            apiDate.day == currentSlot.day &&
            apiDate.hour == currentSlot.hour &&
            apiDate.minute == currentSlot.minute,
      );

      // Don't show slots in the past if looking at today
      if (currentSlot.isBefore(DateTime.now())) {
        isAvailable = false;
      }

      String timeString =
          "${currentSlot.hour.toString().padLeft(2, '0')}:${currentSlot.minute.toString().padLeft(2, '0')}";

      slots.add({"time": timeString, "isAvailable": isAvailable});

      // Move to next slot (e.g., add 30 mins)
      currentSlot = currentSlot.add(Duration(minutes: slotDurationMinutes));
    }

    return slots;
  }

  Future<void> fetchAvailableSlots(String serviceId) async {
    _isLoadingSlots = true;
    notifyListeners();

    try {
      List<String> rawSlots = await _apiService.getUnavailableSlots(serviceId);
      _availableSlotsFromApi = rawSlots
          .map((iso) => DateTime.parse(iso))
          .toList();

      if (_availableSlotsFromApi.isNotEmpty) {
        _selectedDate = _availableSlotsFromApi.first;
      }
    } catch (e) {
      debugPrint("Error fetching slots: $e");
    } finally {
      _isLoadingSlots = false;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTimeSlot = null;
    _combineDateTime();
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTimeSlot = time;
    _combineDateTime();
    notifyListeners();
  }

  void _combineDateTime() {
    if (_selectedTimeSlot != null) {
      final parts = _selectedTimeSlot!.split(':');
      selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } else {
      selectedDateTime = null;
    }
  }

  void updateSelectedDate(DateTime dt) {
    selectedDateTime = dt;
    _selectedDate = dt;
    _selectedTimeSlot =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

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
