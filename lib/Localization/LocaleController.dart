import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LocaleController extends GetxController {
  final GetStorage storage = GetStorage();
  var isArabic = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved locale if exists
    String? savedLocale = storage.read('selectedLocale');
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      if (parts.length == 2) {
        Get.updateLocale(Locale(parts[0], parts[1]));
        isArabic.value = (parts[0] == 'ar');
      }
    } else {
      isArabic.value = storage.read('isArabic') ?? false;
      updateLocale();
    }
  }

  void toggleLanguage(bool value) {
    isArabic.value = value;
    storage.write('isArabic', value);
    updateLocale();
  }

  void updateLocale() {
    var locale = isArabic.value ? Locale('ar', 'EG') : Locale('en', 'US');
    Get.updateLocale(locale);
    storage.write(
      'selectedLocale',
      '${locale.languageCode}_${locale.countryCode}',
    );
    update();
  }

  void changeLanguage(Locale locale) {
    Get.updateLocale(locale);
    storage.write(
      'selectedLocale',
      '${locale.languageCode}_${locale.countryCode}',
    );
    isArabic.value = (locale.languageCode == 'ar');
    storage.write('isArabic', isArabic.value);
    update(); // Trigger GetBuilder rebuild
  }

  Locale get currentLocale => Get.locale ?? Locale('en', 'US');
}
