import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';

class CustomSnackBar {
  static SnackBar _buildSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required Color accentColor,
    required IconData icon,
  }) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(icon, color: accentColor, size: 25.sp),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.lexend(
                            color: Constants.MidnightNavy,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          message,
                          style: TextStyle(
                            color: Colors.blueGrey[600],
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.blueGrey[200],
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title,
      message,
      Constants.PrimaryColor,
      Icons.verified_user_rounded,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title,
      message,
      const Color(0xFFFF4B4B),
      Icons.emergency_rounded,
    ); // Medical variant
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title,
      message,
      const Color(0xFFFFB800),
      Icons.notification_important_rounded,
    );
  }

  static void _show(
    BuildContext context,
    String title,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        title: title,
        context: context,
        message: message,
        accentColor: color,
        icon: icon,
      ),
    );
  }
}
