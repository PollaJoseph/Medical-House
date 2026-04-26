import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/SplashScreenModel.dart';
import 'package:medical_house/View/OnboardingView.dart';
import 'package:medical_house/View/SignUpView.dart';
import 'package:medical_house/ViewModel/SplashScreenViewModel.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel _viewModel;
  late SplashModel _model;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _model = SplashModel(logoAssetPath: Constants.LogoImagePath);
    _viewModel = SplashViewModel();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    _viewModel.loadAppDependencies();
    _viewModel.addListener(_checkNavigationConditions);
  }

  void _checkNavigationConditions() {
    if (_viewModel.isReadyToNavigate && !_navigated) {
      _navigated = true;
      _navigateToHome();
    }
  }

  // Inside _SplashViewState class
  void _navigateToHome() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Widget nextScreen = _viewModel.showOnboarding
          ? const OnboardingView()
          : const SignUpView();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_checkNavigationConditions);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Image.asset(
                _model.logoAssetPath,
                width: 200.w,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}
