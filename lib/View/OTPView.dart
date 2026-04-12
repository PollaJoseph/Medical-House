import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_house/Components/CustomOTPForm.dart';
import 'package:medical_house/Components/CustomSnackBar.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/ViewModel/OTPViewModel.dart';
import 'package:provider/provider.dart';

class OTPView extends StatefulWidget {
  final String email;
  final String Case;
  const OTPView({super.key, required this.email, required this.Case});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> with SingleTickerProviderStateMixin {
  String _currentOTP = '';
  bool _isLoading = false;

  // Timer
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  // Animations
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  String get _timerText {
    final mins = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  Future<void> _verifyOTP() async {
    if (_currentOTP.length < 6) {
      CustomSnackBar.showError(
        context,
        title: "OTP Failed".tr,
        message: "Please enter the complete 6-digit code".tr,
      );

      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  void _resendOTP() {
    if (!_canResend) return;
    _startTimer();
    CustomSnackBar.showSuccess(
      context,
      title: "OTP Sent".tr,
      message: "A new code has been sent to your email".tr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OTPViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      body: Stack(
        children: [
          // Decorative background circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A73E8).withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34A853).withOpacity(0.07),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.78,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon Badge
                              Container(
                                width: 150.w,
                                height: 150.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Image.asset(
                                  Constants.LogoImagePath,
                                  width: 100.w,
                                  height: 100.h,
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Title
                              Text(
                                'Verify Your Identity'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D1B2A),
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Subtitle with masked email
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    color: Colors.grey.shade600,
                                    height: 1.6,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'A 6-digit code has been sent to\n'
                                          .tr,
                                    ),
                                    TextSpan(
                                      text: _maskEmail(widget.email),
                                      style: const TextStyle(
                                        color: Color(0xFF1A73E8),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 40),

                              // OTP label
                              Text(
                                'ENTER VERIFICATION CODE'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              const SizedBox(height: 14),

                              // OTP Form
                              OTPForm(
                                onOTPChanged: (otp) {
                                  setState(() => _currentOTP = otp);
                                },
                              ),

                              const SizedBox(height: 32),

                              // Timer / Resend section
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                child: _canResend
                                    // ── Resend button (timer done) ──
                                    ? GestureDetector(
                                        key: const ValueKey('resend'),
                                        onTap: viewModel.isResending
                                            ? null
                                            : () {
                                                viewModel.resendCode(
                                                  context,
                                                  widget.email,
                                                );
                                              },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF1A73E8,
                                            ).withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            border: Border.all(
                                              color: const Color(
                                                0xFF1A73E8,
                                              ).withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.refresh_rounded,
                                                color: Color(0xFF1A73E8),
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Resend Code'.tr,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF1A73E8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    // ── Countdown timer ──
                                    : Column(
                                        key: const ValueKey('timer'),
                                        children: [
                                          Text(
                                            "Didn't receive the code?".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                width: 68,
                                                height: 68,
                                                child:
                                                    CircularProgressIndicator(
                                                      value:
                                                          _secondsRemaining /
                                                          60,
                                                      strokeWidth: 4,
                                                      backgroundColor:
                                                          Colors.grey.shade200,
                                                      color: const Color(
                                                        0xFF1A73E8,
                                                      ),
                                                    ),
                                              ),
                                              Text(
                                                _timerText,
                                                style: const TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF0D1B2A),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Resend available soon'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),

                              const SizedBox(height: 36),

                              // Verify Button
                              SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: _currentOTP.length == 6
                                          ? [
                                              const Color(0xFF1A73E8),
                                              const Color(0xFF0D47A1),
                                            ]
                                          : [
                                              Colors.grey.shade300,
                                              Colors.grey.shade300,
                                            ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: _currentOTP.length == 6
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF1A73E8,
                                              ).withOpacity(0.4),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: viewModel.isVerifying
                                          ? null
                                          : () {
                                              if (widget.Case ==
                                                  "Forget Password") {
                                                viewModel.verifyResetCode(
                                                  context,
                                                  widget.email,
                                                  _currentOTP,
                                                );
                                              } else {
                                                viewModel.verifyEmail(
                                                  context,
                                                  widget.email,
                                                  _currentOTP,
                                                );
                                              }
                                            },
                                      child: Center(
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2.5,
                                                    ),
                                              )
                                            : Text(
                                                'Verify & Continue'.tr,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: _currentOTP.length == 6
                                                      ? Colors.white
                                                      : Colors.grey.shade500,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Security Note
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF34A853,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF34A853,
                                        ).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.shield_rounded,
                                        color: Color(0xFF2E7D32),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Your medical data is protected. Never share this code with anyone.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: Colors.green.shade800,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
