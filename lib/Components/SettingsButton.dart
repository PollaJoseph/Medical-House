import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsButton extends StatelessWidget {
  final String text;
  final Color iconColor;
  final Color textColor;
  final IconData? icon;
  final String? imagePath;
  final void Function() onClick;
  final bool hideArrow; // NEW: To hide the arrow on buttons like Logout

  const SettingsButton({
    super.key,
    required this.text,
    this.icon,
    this.imagePath,
    required this.onClick,
    required this.iconColor,
    required this.textColor,
    this.hideArrow = false,
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(
              16.w,
            ), // Switched to .w for consistent layout
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: icon != null
                      ? Icon(icon, color: iconColor, size: 20.sp)
                      : Image.asset(
                          imagePath!,
                          width: 20.w,
                          height: 20.h,
                          color: iconColor,
                        ),
                ),
                SizedBox(width: 16.w),

                // Text
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3, // Modern typography
                    ),
                  ),
                ),

                // Optional Forward Arrow
                if (!hideArrow)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.blueGrey[200],
                    size: 16.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
