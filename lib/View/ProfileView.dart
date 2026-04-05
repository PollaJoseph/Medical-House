import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/View/LoginView.dart';
import 'package:medical_house/View/PointServicesView.dart';
import 'package:medical_house/ViewModel/ProfileViewModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..fetchUserData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Consumer<ProfileViewModel>(
          builder: (context, model, _) {
            if (model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Constants.PrimaryColor),
              );
            }

            final user = model.user; //
            if (user == null) return Center(child: Text("User not found".tr));

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildModernHeader(context, user.image, user.username),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        _buildPointsHighlight(user.points, context),
                        SizedBox(height: 32.h),
                        _buildSectionHeader("Account Details".tr),
                        SizedBox(height: 16.h),
                        _buildProfileGrid(user),
                        SizedBox(height: 32.h),
                        _buildSectionHeader("Identification Pass".tr),
                        SizedBox(height: 16.h),
                        _buildPremiumQRCard(user.qrCode),
                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, String image, String name) {
    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: Constants.MidnightNavy,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.1),
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
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: const Color(0xFFFF4B4B).withOpacity(0.15),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                    color: Color(0xFFFF4B4B),
                    size: 20,
                  ),
                  tooltip: "Delete Account".tr,
                  onPressed: () => _showDeleteConfirmation(context), //
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(image, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Constants.MidnightNavy.withOpacity(0.95),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30.h,
              left: 24.w,
              right: 24.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.PrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Constants.PrimaryColor.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      "VERIFIED ACCOUNT".tr,
                      style: TextStyle(
                        color: Constants.PrimaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 10.sp,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    name,
                    style: GoogleFonts.lexend(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsHighlight(int points, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PointServicesView()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Constants.MidnightNavy.withOpacity(0.06),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Point Balance".tr,
                    style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "$points ${"Pts".tr}", //
                    style: GoogleFonts.lexend(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                      color: Constants.MidnightNavy,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Constants.PrimaryColor, const Color(0xFF078D9A)],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Constants.PrimaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                "Redeem".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileGrid(dynamic user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _modernInfoCard(
                "Phone".tr,
                user.phoneNumber,
                Icons.phone_android_rounded,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _modernInfoCard(
                "Gender".tr,
                user.gender,
                Icons.face_retouching_natural_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _modernInfoCard(
                "Age".tr,
                "${user.age} ${"Years".tr}",
                Icons.cake_rounded,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _modernInfoCard(
                "Email Address".tr,
                user.email,
                Icons.alternate_email_rounded,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
        SizedBox(height: 12.h),

        _buildMapPreviewCard(user.location),
      ],
    );
  }

  Widget _buildMapPreviewCard(String locationString) {
    final coords = _parseLocation(locationString);
    final double lat = coords['lat']!;
    final double lng = coords['lng']!;

    final String mapImageUrl =
        "https://static-maps.yandex.ru/1.x/?lang=en_US&ll=$lng,$lat&z=14&l=map&size=600,300&pt=$lng,$lat,pm2rdm";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.blueGrey.shade50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    color: Constants.MidnightNavy,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Home Location".tr,
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 150.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.blueGrey.shade50,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    mapImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.map_outlined),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Future<void> _openMapNavigation(
                          double lat,
                          double lng,
                        ) async {
                          final Uri googleMapsUrl = Uri.parse(
                            "google.navigation:q=$lat,$lng&mode=d",
                          );
                          final Uri appleMapsUrl = Uri.parse(
                            "https://maps.apple.com/?q=$lat,$lng",
                          );

                          try {
                            if (await canLaunchUrl(googleMapsUrl)) {
                              await launchUrl(googleMapsUrl);
                            } else if (await canLaunchUrl(appleMapsUrl)) {
                              await launchUrl(appleMapsUrl);
                            } else {
                              final Uri webUrl = Uri.parse(
                                "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
                              );
                              await launchUrl(
                                webUrl,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          } catch (e) {
                            debugPrint("Could not launch maps: $e");
                          }
                        }

                        _openMapNavigation(lat, lng);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.MidnightNavy.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(100.r),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 10),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.directions_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Open Navigation".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Map<String, double> _parseLocation(String locationStr) {
    try {
      String clean = locationStr
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll("'", "");
      List<String> parts = clean.split(',');

      double lat = double.parse(parts[0].split(':')[1].trim());
      double lng = double.parse(parts[1].split(':')[1].trim());

      return {'lat': lat, 'lng': lng};
    } catch (e) {
      return {'lat': 30.1340406, 'lng': 31.2215063};
    }
  }

  Widget _modernInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.blueGrey.shade50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Constants.MidnightNavy, size: 18.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey[300],
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: Constants.MidnightNavy,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumQRCard(String qrUrl) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.blueGrey.shade50),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Image.network(qrUrl, height: 220.h),
          ),
          SizedBox(height: 24.h),
          Text(
            "LOYALTY REWARDS PASS".tr,
            style: GoogleFonts.lexend(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: Constants.MidnightNavy,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Present this QR code to any medical staff member to add loyalty points to your account after your visit."
                .tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey[400],
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.lexend(
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        color: Constants.MidnightNavy,
        letterSpacing: -0.3,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        title: Text(
          "Are you sure?".tr,
          style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "This will permanently deactivate your account and archive your data. This action cannot be undone."
              .tr,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Cancel".tr, style: TextStyle(color: Colors.blueGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4B4B),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () async {
              final model = Provider.of<ProfileViewModel>(
                context,
                listen: false,
              );
              bool success = await model.deleteUserAccount();

              if (success) {
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
                  );
                }
              } else if (model.blockingBooking != null) {
                if (context.mounted) {
                  Navigator.pop(dialogContext);
                  _showBlockingBookingDialog(context, model.blockingBooking!);
                }
              }
            },
            child: Text(
              "Delete".tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockingBookingDialog(
    BuildContext context,
    Map<String, dynamic> booking,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB800)),
            SizedBox(width: 12.w),
            Text("Action Required".tr),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You cannot delete your account while you have active future bookings."
                  .tr,
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.blueGrey.shade50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['service'] ?? "Medical Service",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.MidnightNavy,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${"Scheduled for:".tr} ${booking['slot_time'].toString().split('T')[0]}",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Please cancel this booking first to proceed with account deletion."
                  .tr,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "I Understand".tr,
              style: TextStyle(
                color: Constants.MidnightNavy,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
