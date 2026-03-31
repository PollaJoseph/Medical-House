class BookingRequestModel {
  final String serviceId;
  final String clientId;
  final String bookingTime;

  BookingRequestModel({
    required this.serviceId,
    required this.clientId,
    required this.bookingTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "ServiceID": serviceId,
      "ClientID": clientId,
      "BookingTime": bookingTime,
    };
  }
}
