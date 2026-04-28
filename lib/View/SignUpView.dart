import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_house/Components/CustomMapPicker.dart';
import 'package:medical_house/Components/SocialButton.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/View/LoginView.dart';
import 'package:provider/provider.dart';
import 'package:medical_house/ViewModel/SignUpViewModel.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color sterileWhite = Color(0xFFF8FAFC);

    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        backgroundColor: sterileWhite,
        body: Consumer<SignUpViewModel>(
          builder: (context, model, _) {
            return Stack(
              children: [
                _buildBackgroundDecor(Constants.SeconadryColor),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        _buildBiometricImagePicker(
                          context,
                          model,
                          Constants.SeconadryColor,
                        ),
                        SizedBox(height: 35.h),
                        _buildModernForm(
                          model,
                          Constants.SeconadryColor,
                          Constants.MidnightNavy,
                          context,
                        ), // FIXED: Added context
                        SizedBox(height: 30.h),
                        _buildConfirmButton(
                          model,
                          Constants.MidnightNavy,
                          context,
                        ),

                        // _buildSocialDivider(),
                        //_buildSocialLogins(model, context),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have you visited us before? ".tr,
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontSize: 14.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login".tr,
                                style: TextStyle(
                                  color: Constants.MidnightNavy,
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

  Widget _buildBiometricImagePicker(
    BuildContext context,
    SignUpViewModel model,
    Color teal,
  ) {
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
            // OPEN THE NEW BOTTOM SHEET HERE
            onTap: () => _showImageSourceActionSheet(context, model, teal),
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
                    ? Icon(Icons.person_rounded, size: 45.sp, color: teal)
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => _showImageSourceActionSheet(context, model, teal),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: teal,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded, // Changed icon to match the action
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceActionSheet(
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
              "Profile Photo".tr,
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
                child: Icon(Icons.camera_alt_rounded, color: teal),
              ),
              title: Text(
                "Take a Photo".tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close sheet first
                model.pickImage(ImageSource.camera); // Open Camera
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: teal.withOpacity(0.1),
                child: Icon(Icons.photo_library_rounded, color: teal),
              ),
              title: Text(
                "Choose from Gallery".tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context); // Close sheet first
                model.pickImage(ImageSource.gallery); // Open Gallery
              },
            ),
            // Optional: Add a remove button if an image is already selected
            if (model.profileImage != null) ...[
              Divider(color: Colors.blueGrey.shade50, height: 20.h),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.redAccent,
                  ),
                ),
                title: Text(
                  "Remove Photo".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  model.profileImage = null; // Clear image
                  model.notifyListeners();
                },
              ),
            ],
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildModernForm(
    SignUpViewModel model,
    Color teal,
    Color navy,
    BuildContext context,
  ) {
    return Column(
      children: [
        _buildInputGroup("Identity".tr, [
          _buildGlassField(
            "First Name".tr,
            keyboard: TextInputType.name,
            Icons.badge_outlined,
            model.firstNameController,
            teal,
          ),
          _buildGlassField(
            "Last Name".tr,
            keyboard: TextInputType.name,
            Icons.badge_outlined,
            model.lastNameController,
            teal,
          ),
        ]),
        SizedBox(height: 20.h),
        _buildInputGroup("Patient Bio".tr, [
          _buildModernGenderToggle(model, teal),
          Row(
            children: [
              Expanded(
                child: _buildGlassField(
                  "Age".tr,
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
                  "Phone".tr,
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
        _buildInputGroup("Security".tr, [
          _buildLocationPickerField(
            context,
            model,
            teal,
          ), // FIXED: Correctly passing context
          _buildGlassField(
            "Email".tr,
            keyboard: TextInputType.emailAddress,
            Icons.alternate_email_rounded,
            model.emailController,
            teal,
          ),
          _buildPasswordGlassField(model, teal),
          SizedBox(height: 20.h),
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
          _genderOption("Male".tr, Icons.male_rounded, model, teal),
          _genderOption("Female".tr, Icons.female_rounded, model, teal),
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
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.blueGrey[200],
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          hintText: "Security Password".tr,
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
        // Disable the button if it is currently loading
        onPressed: model.isLoading ? null : () => model.registerUser(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
        ),
        // Show the spinner if loading, otherwise show the text
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
                "Finalize Registration".tr,
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
          hintText: "Clinic/Residential Location".tr,
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
              "Or register with".tr,
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

  Widget _buildSocialLogins(SignUpViewModel model, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // GOOGLE BUTTON
        model.isGoogleLoading
            ? const CircularProgressIndicator(color: Color(0xFF0CACBB))
            : SocialButton(
                icon: Image.asset(
                  Constants.GoogleIconPath,
                  width: 26.w,
                  height: 26.h,
                ),
                onTap: () => model.signInWithGoogle(context),
              ),

        SizedBox(width: 30.w),

        // APPLE BUTTON
        SocialButton(
          icon: Image.asset(Constants.AppleIconPath, width: 26.w, height: 26.h),
          onTap: () => debugPrint("Apple Login Tapped"),
        ),

        SizedBox(width: 30.w),

        // FACEBOOK BUTTON
        SocialButton(
          icon: Image.asset(
            Constants.FacebookIconPath,
            width: 26.w,
            height: 26.h,
          ),
          onTap: () => debugPrint("Facebook Login Tapped"),
        ),
      ],
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
              "Select Address".tr,
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
              title: Text(
                "Use Current GPS".tr,
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
              title: Text(
                "Select on Map".tr,
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
          // 3. THE FIX: Catch the lat and lng variables coming from the map
          onLocationPicked: (address, lat, lng) {
            // Pass the coordinates into the ViewModel's update function
            model.updateLocationString(
              address,
              lat: lat.toString(),
              lng: lng.toString(),
            );
            Navigator.pop(context); // Close the map picker
          },
        ),
      ),
    );
  }
}
