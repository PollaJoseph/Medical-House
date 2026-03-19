import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';

class SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  const SocialButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Constants.WhiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.blueGrey.shade50, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: icon, // Only the icon is displayed now
        ),
      ),
    );
  }
}
