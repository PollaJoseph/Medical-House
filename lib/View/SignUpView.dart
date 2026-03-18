import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Components/CustomMapPicker.dart';
// FIXED: Added specific imports for the map picker
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';
import 'package:medical_house/ViewModel/SignUpViewModel.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color midnightNavy = Color(0xFF0D1B34);
    const Color surgicalTeal = Color(0xFF0CACBB);
    const Color sterileWhite = Color(0xFFF8FAFC);

    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        backgroundColor: sterileWhite,
        body: Consumer<SignUpViewModel>(
          builder: (context, model, _) {
            return Stack(
              children: [
                _buildBackgroundDecor(surgicalTeal),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        _buildCustomAppBar(context, midnightNavy),
                        SizedBox(height: 20.h),
                        _buildBiometricImagePicker(model, surgicalTeal),
                        SizedBox(height: 35.h),
                        _buildModernForm(
                          model,
                          surgicalTeal,
                          midnightNavy,
                          context,
                        ), // FIXED: Added context
                        SizedBox(height: 30.h),
                        _buildConfirmButton(model, midnightNavy, context),
                        _buildSocialDivider(),
                        _buildSocialLogins(model),

                        SizedBox(height: 40.h),
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

  // --- MODERN UI BUILDERS ---

  Widget _buildBackgroundDecor(Color teal) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -50.w,
            child: CircleAvatar(
              radius: 150.r,
              backgroundColor: teal.withOpacity(0.04),
            ),
          ),
          Positioned(
            bottom: 100.h,
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

  Widget _buildCustomAppBar(BuildContext context, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new, color: color, size: 18.sp),
            ),
          ),
          Text(
            "Registration",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildBiometricImagePicker(SignUpViewModel model, Color teal) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 130.r,
            height: 130.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: teal.withOpacity(0.1), width: 2),
            ),
          ),
          GestureDetector(
            onTap: model.pickImage,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 55.r,
                backgroundColor: const Color(0xFFF1F5F9),
                backgroundImage: model.profileImage != null
                    ? FileImage(model.profileImage!)
                    : null,
                child: model.profileImage == null
                    ? Icon(Icons.fingerprint_rounded, size: 45.sp, color: teal)
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: teal,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: Added BuildContext to the parameters
  Widget _buildModernForm(
    SignUpViewModel model,
    Color teal,
    Color navy,
    BuildContext context,
  ) {
    return Column(
      children: [
        _buildInputGroup("Identity", [
          _buildGlassField(
            "First Name",
            Icons.badge_outlined,
            model.firstNameController,
            teal,
          ),
          _buildGlassField(
            "Last Name",
            Icons.badge_outlined,
            model.lastNameController,
            teal,
          ),
        ]),
        SizedBox(height: 20.h),
        _buildInputGroup("Patient Bio", [
          _buildModernGenderToggle(model, teal),
          Row(
            children: [
              Expanded(
                child: _buildGlassField(
                  "Age",
                  Icons.event_note_rounded,
                  model.ageController,
                  teal,
                  keyboard: TextInputType.number,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                flex: 2,
                child: _buildGlassField(
                  "Phone",
                  Icons.phonelink_ring_rounded,
                  model.phoneController,
                  teal,
                  keyboard: TextInputType.phone,
                ),
              ),
            ],
          ),
        ]),
        SizedBox(height: 20.h),
        _buildInputGroup("Security", [
          _buildLocationPickerField(
            context,
            model,
            teal,
          ), // FIXED: Correctly passing context
          _buildGlassField(
            "Email",
            Icons.alternate_email_rounded,
            model.emailController,
            teal,
          ),
          _buildPasswordGlassField(model, teal),
        ]),
      ],
    );
  }

  Widget _buildInputGroup(String label, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: Colors.blueGrey[300],
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...fields,
      ],
    );
  }

  Widget _buildGlassField(
    String hint,
    IconData icon,
    TextEditingController controller,
    Color teal, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
        keyboardType: keyboard,
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

  Widget _buildModernGenderToggle(SignUpViewModel model, Color teal) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          _genderOption("Male", Icons.male_rounded, model, teal),
          _genderOption("Female", Icons.female_rounded, model, teal),
        ],
      ),
    );
  }

  Widget _genderOption(
    String label,
    IconData icon,
    SignUpViewModel model,
    Color teal,
  ) {
    bool isSelected = model.selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => model.setGender(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? teal : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isSelected ? Colors.white : Colors.blueGrey[200],
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blueGrey[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordGlassField(SignUpViewModel model, Color teal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
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

  Widget _buildConfirmButton(
    SignUpViewModel model,
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
        onPressed: () => model.registerUser(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
        ),
        child: Text(
          "Finalize Registration",
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

  Widget _buildLocationPickerField(
    BuildContext context,
    SignUpViewModel model,
    Color teal,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
        controller: model.locationController,
        readOnly: true,
        onTap: () {
          // Prevent opening the sheet if we are currently loading the GPS
          if (!model.isFetchingLocation) {
            _showLocationOptions(context, model, teal);
          }
        },
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          // Change text color slightly if it's showing an error or loading text
          color: model.isFetchingLocation ? teal : const Color(0xFF0D1B34),
        ),
        decoration: InputDecoration(
          hintText: "Clinic/Residential Location",
          hintStyle: TextStyle(color: Colors.blueGrey[200], fontSize: 14.sp),
          prefixIcon: Icon(Icons.location_on_rounded, color: teal, size: 20.sp),

          // MODERN FIX: Show a spinner while loading, otherwise show the arrow
          suffixIcon: model.isFetchingLocation
              ? Padding(
                  padding: EdgeInsets.all(14.w),
                  child: SizedBox(
                    width: 15.w,
                    height: 15.w,
                    child: CircularProgressIndicator(
                      color: teal,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Icon(Icons.expand_more_rounded, color: Colors.blueGrey[100]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 20.w,
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
              "Or register with",
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

  Widget _buildSocialLogins(SignUpViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Button
        _socialButton(
          icon: Text(
            "G",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFDB4437), // Google Red
            ),
          ),
          label: "Google",
          onTap: () {
            // TODO: Call Google Sign In logic from ViewModel
            debugPrint("Google Sign In Tapped");
          },
        ),

        SizedBox(width: 20.w),

        // Apple Button
        _socialButton(
          icon: Icon(Icons.apple, size: 26.sp, color: Colors.black),
          label: "Apple",
          onTap: () {
            // TODO: Call Apple Sign In logic from ViewModel
            debugPrint("Apple Sign In Tapped");
          },
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

  void _showLocationOptions(
    BuildContext context,
    SignUpViewModel model,
    Color teal,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select Address",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D1B34),
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: teal.withOpacity(0.1),
                child: Icon(Icons.my_location, color: teal),
              ),
              title: const Text(
                "Use Current GPS",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                model.getCurrentLocation();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: teal.withOpacity(0.1),
                child: Icon(Icons.map_outlined, color: teal),
              ),
              title: const Text(
                "Select on Map",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                _openMapPicker(context, model);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  void _openMapPicker(BuildContext context, SignUpViewModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomMapPicker(
          onLocationPicked: (address) {
            model.updateLocationString(address);
            Navigator.pop(context); // Close the map picker
          },
        ),
      ),
    );
  }
}
