import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnackBar {
  static SnackBar _buildSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
      content: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border(
            left: BorderSide(color: color, width: 4.w),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        context: context,
        title: title,
        message: message,
        color: Colors.green,
        icon: Icons.check_circle,
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        context: context,
        title: title,
        message: message,
        color: Colors.red,
        icon: Icons.error_outline,
      ),
    );
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        context: context,
        title: title,
        message: message,
        color: Colors.amber,
        icon: Icons.warning_amber_rounded,
      ),
    );
  }
}
