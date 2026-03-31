import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medical_house/Components/MainWrapper.dart';
import 'package:medical_house/View/LoginView.dart';
import 'package:medical_house/View/SignUpView.dart';
import 'package:medical_house/View/SplashScreenView.dart';
import 'package:medical_house/ViewModel/OTPViewModel.dart';
import 'package:medical_house/ViewModel/SignUpViewModel.dart';
import 'package:provider/provider.dart';
import 'package:medical_house/Localization/LocaleController.dart';
import 'package:medical_house/Localization/LocaleStrings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "keys.env");
  await GetStorage.init();
  Get.put(LocaleController());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => OTPViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: LocaleStrings(),
          locale: Get.find<LocaleController>().currentLocale,
          fallbackLocale: const Locale('en', 'US'),

          home: SignUpView(),
          //const MainWrapper(),
        );
      },
    );
  }
}
