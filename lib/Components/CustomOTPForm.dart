import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import '../Constants.dart';

class OTPForm extends StatefulWidget {
  final Function(String) onOTPChanged;

  const OTPForm({super.key, required this.onOTPChanged});

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  String otpCode = '';

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void updateOTP() {
    otpCode = '';
    for (var controller in controllers) {
      otpCode += controller.text;
    }
    widget.onOTPChanged(otpCode);
  }

  void _handleChange(String value, int index) {
    // Handle paste operation - if multiple digits are pasted
    if (value.length > 1) {
      _handlePaste(value, index);
      return;
    }

    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    updateOTP();
  }

  void _handlePaste(String pastedText, int startIndex) {
    // Remove any non-digit characters
    String cleanedText = pastedText.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 6 digits maximum
    if (cleanedText.length > 6) {
      cleanedText = cleanedText.substring(0, 6);
    }

    // Clear all fields first
    for (var controller in controllers) {
      controller.clear();
    }

    // Fill the fields with the pasted digits
    for (int i = 0; i < cleanedText.length && i < 6; i++) {
      controllers[i].text = cleanedText[i];
    }

    // Focus on the next empty field or the last field if all are filled
    int nextFocusIndex = cleanedText.length < 6 ? cleanedText.length : 5;
    if (nextFocusIndex < 6) {
      FocusScope.of(context).requestFocus(focusNodes[nextFocusIndex]);
    }

    updateOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return SizedBox(
            height: Constants.screenHeight(context) * 0.08,
            width: Constants.screenWidth(context) * 0.14,
            child: TextFormField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              autofocus: index == 0,
              onChanged: (value) => _handleChange(value, index),
              decoration: InputDecoration(
                counterText: '',
                hintStyle: TextStyle(
                  fontFamily: Get.locale == const Locale('ar', 'EG')
                      ? 'ar_font'
                      : 'en_font_bold',
                  fontSize: Constants.screenWidth(context) * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                hintText: "0",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.screenWidth(context) * 0.02,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.screenWidth(context) * 0.02,
                  ),
                  borderSide: BorderSide(
                    color: Constants.PrimaryColor,
                    width: Constants.screenWidth(context) * 0.01,
                  ),
                ),
              ),
              style: TextStyle(
                fontFamily: Get.locale == const Locale('ar', 'EG')
                    ? 'ar_font'
                    : 'en_font_bold',
                fontSize: Constants.screenWidth(context) * 0.07,
                fontWeight: FontWeight.bold,
                color: Constants.PrimaryColor,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          );
        }),
      ),
    );
  }
}
