import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/View/LoginView.dart';
import 'package:medical_house/ViewModel/ChangePasswordViewModel.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatelessWidget {
  final String email;
  const ChangePasswordView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Constants.MidnightNavy,
            ),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
              (route) => false,
            ),
          ),
        ),
        body: Consumer<ChangePasswordViewModel>(
          builder: (context, model, _) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),

                    // 1. Security Icon Header
                    _buildSecurityHeader(),
                    SizedBox(height: 30.h),

                    // 2. Text Content
                    Text(
                      "Reset Password".tr,
                      style: GoogleFonts.lexend(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: Constants.MidnightNavy,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Create a strong new password for your account.".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blueGrey[400],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // 3. Password Fields
                    _buildPasswordField(
                      controller: model.passwordController,
                      hint: "New Password".tr,
                      isVisible: model.isPasswordVisible,
                      onToggle: model.togglePasswordVisibility,
                    ),
                    SizedBox(height: 20.h),
                    _buildPasswordField(
                      controller: model.confirmPasswordController,
                      hint: "Confirm Password".tr,
                      isVisible: model.isConfirmVisible,
                      onToggle: model.toggleConfirmVisibility,
                    ),

                    SizedBox(height: 40.h),

                    // 4. Action Button
                    _buildSubmitButton(context, model),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSecurityHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Constants.PrimaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_reset_rounded,
        color: Constants.PrimaryColor,
        size: 50.sp,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueGrey[200], fontSize: 14.sp),
          prefixIcon: const Icon(
            Icons.shield_outlined,
            color: Constants.PrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: Colors.blueGrey[100],
            ),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 20.w,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    ChangePasswordViewModel model,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: model.isLoading
            ? null
            : () => model.updatePassword(
                context,
                email,
                model.passwordController.text,
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.MidnightNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
        ),
        child: model.isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Change Password".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
