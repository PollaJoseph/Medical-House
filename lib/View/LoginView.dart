import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:medical_house/ViewModel/LoginViewModel.dart';
import 'package:medical_house/View/SignUpView.dart'; // Ensure this points to your file

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // High-End Medical Palette
    const Color midnightNavy = Color(0xFF0D1B34);
    const Color surgicalTeal = Color(0xFF0CACBB);
    const Color sterileWhite = Color(0xFFF8FAFC);

    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: sterileWhite,
        body: Consumer<LoginViewModel>(
          builder: (context, model, _) {
            return Stack(
              children: [
                // 1. Background Organic Shapes (Matching Sign Up)
                _buildBackgroundDecor(surgicalTeal),

                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),

                        // 2. Medical Security Header
                        _buildHeaderIcon(surgicalTeal, midnightNavy),
                        SizedBox(height: 30.h),

                        // 3. Welcome Text
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w900,
                            color: midnightNavy,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Access your secure patient portal",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.blueGrey[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // 4. Login Form
                        _buildGlassField(
                          "Email Address",
                          Icons.alternate_email_rounded,
                          model.emailController,
                          surgicalTeal,
                        ),
                        _buildPasswordGlassField(model, surgicalTeal),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to Forgot Password
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: surgicalTeal,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // 5. Main Login Button
                        _buildLoginButton(model, midnightNavy, context),

                        // 6. Social Logins
                        _buildSocialDivider(),
                        _buildSocialLogins(model),

                        SizedBox(height: 40.h),

                        // 7. Footer: Navigate to Sign Up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to Medical House? ",
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontSize: 14.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpView(),
                                  ),
                                );
                              },
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  color: midnightNavy,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
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

  // --- UI COMPONENTS ---

  Widget _buildBackgroundDecor(Color teal) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -50.h,
            right: -80.w,
            child: CircleAvatar(
              radius: 180.r,
              backgroundColor: teal.withOpacity(0.04),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -80.w,
            child: CircleAvatar(
              radius: 200.r,
              backgroundColor: teal.withOpacity(0.03),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(Color teal, Color navy) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: teal.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        "lib/Assets/Images/logo.png",
        width: 120.w,
        height: 120.h,
      ),
    );
  }

  Widget _buildGlassField(
    String hint,
    IconData icon,
    TextEditingController controller,
    Color teal,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueGrey[200], fontSize: 14.sp),
          prefixIcon: Icon(icon, color: teal, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 20.w,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordGlassField(LoginViewModel model, Color teal) {
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
        controller: model.passwordController,
        obscureText: !model.isPasswordVisible,
        decoration: InputDecoration(
          hintText: "Security Password",
          prefixIcon: Icon(Icons.lock_person_rounded, color: teal, size: 20.sp),
          suffixIcon: IconButton(
            icon: Icon(
              model.isPasswordVisible
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: Colors.blueGrey[100],
            ),
            onPressed: model.togglePasswordVisibility,
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

  Widget _buildLoginButton(
    LoginViewModel model,
    Color navy,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: model.isLoading ? null : () => model.loginUser(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
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
                "Access Portal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.blueGrey[100], thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              "Or access with",
              style: TextStyle(
                color: Colors.blueGrey[300],
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.blueGrey[100], thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildSocialLogins(LoginViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(
          icon: Text(
            "G",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFDB4437),
            ),
          ),
          label: "Google",
          onTap: () => debugPrint("Google Login Tapped"),
        ),
        SizedBox(width: 20.w),
        _socialButton(
          icon: Icon(Icons.apple, size: 26.sp, color: Colors.black),
          label: "Apple",
          onTap: () => debugPrint("Apple Login Tapped"),
        ),
      ],
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 55.h,
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF0D1B34),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
