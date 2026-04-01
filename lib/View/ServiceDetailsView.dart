import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/ViewModel/ServiceDetailsViewModel.dart';
import 'package:provider/provider.dart';

class ServiceDetailsView extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailsView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ServiceDetailsViewModel()..fetchUnavailableSlots(service.id),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ServiceDetailsViewModel>(
          builder: (context, model, _) => Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleSection(),
                          SizedBox(height: 24.h),
                          _buildSchedulePicker(context, model),
                          SizedBox(height: 24.h),
                          _buildDescriptionSection(),
                          SizedBox(height: 120.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildBottomBar(context, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 350.h,
      backgroundColor: Constants.MidnightNavy,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.r)),
          child: service.imageUrl.startsWith('http')
              ? Image.network(service.imageUrl, fit: BoxFit.cover)
              : Image.asset(service.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4B4B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            service.discountTag.toUpperCase(),
            style: TextStyle(
              color: const Color(0xFFFF4B4B),
              fontWeight: FontWeight.w900,
              fontSize: 10.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          service.title,
          style: GoogleFonts.lexend(
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: Constants.MidnightNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Service",
          style: GoogleFonts.lexend(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Constants.MidnightNavy,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          service.description,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.blueGrey[400],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, ServiceDetailsViewModel model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 35.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  "${service.price} SAR",
                  style: TextStyle(
                    color: Constants.PrimaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.MidnightNavy,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                onPressed: model.isBooking
                    ? null
                    : () => model.bookNow(context: context, service: service),
                child: model.isBooking
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Book Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulePicker(
    BuildContext context,
    ServiceDetailsViewModel model,
  ) {
    if (model.isLoadingSlots) {
      return Container(
        height: 150.h,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Constants.PrimaryColor),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Schedule Appointment",
          style: GoogleFonts.lexend(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Constants.MidnightNavy,
          ),
        ),
        SizedBox(height: 16.h),

        GestureDetector(
          onTap: () => _showNativeDateTimePicker(context, model),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Constants.MidnightNavy.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: Colors.blueGrey.shade50, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Constants.PrimaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: Constants.PrimaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.selectedDateTime == null
                            ? "Select Date & Time"
                            : _formatDate(model.selectedDateTime!),
                        style: TextStyle(
                          color: Constants.MidnightNavy,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        model.selectedDateTime == null
                            ? "Tap to schedule"
                            : _formatTime(model.selectedDateTime!),
                        style: TextStyle(
                          color: Colors.blueGrey[400],
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey[300],
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showNativeDateTimePicker(
    BuildContext context,
    ServiceDetailsViewModel model,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: model.selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) => !model.isDayFullyBooked(day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Constants.PrimaryColor,
              onPrimary: Colors.white,
              onSurface: Constants.MidnightNavy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && context.mounted) {
      _showTimeSlotBottomSheet(context, model, pickedDate);
    }
  }

  void _showTimeSlotBottomSheet(
    BuildContext context,
    ServiceDetailsViewModel model,
    DateTime pickedDate,
  ) {
    final slots = model.generateTimeSlotsForDate(pickedDate);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Text(
                "Select Time for ${_formatDate(pickedDate)}",
                style: GoogleFonts.lexend(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Constants.MidnightNavy,
                ),
              ),
              SizedBox(height: 20.h),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: slots.map((slot) {
                      final bool isAvailable = slot['isAvailable'];
                      final DateTime slotTime = slot['dateTime'];
                      final String timeString = slot['timeString'];

                      return GestureDetector(
                        onTap: isAvailable
                            ? () {
                                model.updateSelectedDate(slotTime);
                                Navigator.pop(context);
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? Colors.white
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isAvailable
                                  ? Colors.blueGrey.shade200
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            timeString,
                            style: TextStyle(
                              color: isAvailable
                                  ? Constants.MidnightNavy
                                  : Colors.grey.shade400,
                              decoration: isAvailable
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${dt.day} ${months[dt.month - 1]}, ${dt.year}";
  }

  String _formatTime(DateTime dt) {
    String period = dt.hour >= 12 ? "PM" : "AM";
    int hour12 = dt.hour % 12;
    if (hour12 == 0) hour12 = 12;
    String minute = dt.minute.toString().padLeft(2, '0');
    return "$hour12:$minute $period";
  }
}
