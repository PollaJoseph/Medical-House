import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Components/ScannerOverlayPainter.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Components/CustomSnackBar.dart';

class AddPointsView extends StatefulWidget {
  const AddPointsView({super.key});

  @override
  State<AddPointsView> createState() => _AddPointsViewState();
}

class _AddPointsViewState extends State<AddPointsView>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoStart: false,
    facing: CameraFacing.back,
    returnImage: false,
  );
  final TextEditingController _pointsController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  String? _scannedPatientId;
  bool _isProcessing = false;
  bool _isPermissionGranted = false;
  bool _isLoadingPermission = true;
  bool _isScannerRunning = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    try {
      _scannerController.stop();
    } catch (_) {}
    _scannerController.dispose();
    _pointsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (mounted) {
      setState(() {
        _isPermissionGranted = status.isGranted;
        _isLoadingPermission = false;
      });

      if (status.isGranted) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          try {
            if (mounted && !_isScannerRunning) {
              await _scannerController.start();
              _isScannerRunning = true;

              if (mounted) setState(() {});
            }
          } catch (e) {
            debugPrint("Delayed Camera Init Failed: $e");
          }
        });
      }
    }
  }

  void _handleQrDetection(BarcodeCapture capture) {
    if (_isProcessing || _scannedPatientId != null) return;
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String rawCode = barcodes.first.rawValue!;
      String? extractedId;

      try {
        final Map<String, dynamic> qrData = jsonDecode(rawCode);
        extractedId =
            (qrData['UserID'] ??
                    qrData['user_id'] ??
                    qrData['id'] ??
                    qrData['clientId'])
                ?.toString();
      } catch (e) {
        extractedId = rawCode;
      }

      if (extractedId != null &&
          extractedId.toLowerCase() != "null" &&
          extractedId.isNotEmpty) {
        setState(() {
          _scannedPatientId = extractedId;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            CustomSnackBar.showError(
              context,
              title: "Invalid QR Code".tr,
              message: "Could not find a valid Patient ID.".tr,
            );
          }
        });
      }
    }
  }

  Future<void> _submitPointsTransaction() async {
    if (_scannedPatientId == null) {
      CustomSnackBar.showWarning(
        context,
        title: "Scan Required".tr,
        message: "Please scan a valid patient QR code first.".tr,
      );
      return;
    }

    if (_pointsController.text.trim().isEmpty) {
      CustomSnackBar.showWarning(
        context,
        title: "Input Empty".tr,
        message: "Please specify the number of points to reward.".tr,
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final String patientId = _scannedPatientId!;

      final int? pointsToCredit = int.tryParse(_pointsController.text.trim());

      if (pointsToCredit == null) {
        CustomSnackBar.showError(
          context,
          title: "Invalid Points".tr,
          message: "Please enter a valid number for points.".tr,
        );
        setState(() => _isProcessing = false);
        return;
      }

      await ApiService().addPoints(patientId, pointsToCredit);

      if (mounted) {
        CustomSnackBar.showSuccess(
          context,
          title: "Points Awarded".tr,
          message: "Successfully added points!".tr,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(
          context,
          title: "Error",
          message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scanArea = MediaQuery.of(context).size.width * 0.70;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isPermissionGranted)
            MobileScanner(
              controller: _scannerController,
              onDetect: _handleQrDetection,
              errorBuilder: (context, error, child) {
                final errorMessage =
                    error.errorDetails?.message ?? error.toString();
                return _buildFallbackMessage(errorMessage);
              },
            )
          else
            _buildPermissionFallbackView(),

          // 2. Custom Painter Cutout Overlay (Fixes the white box bug)
          if (_isPermissionGranted && _scannedPatientId == null)
            Positioned.fill(
              child: CustomPaint(
                painter: ScannerOverlayPainter(
                  scanArea: scanArea,
                  borderRadius: 28.r,
                ),
              ),
            ),

          // 3. Aiming Bracket Box and Pulsing Scan Laser Line View
          if (_isPermissionGranted)
            Center(
              child: Container(
                height: scanArea,
                width: scanArea,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _scannedPatientId != null
                        ? Constants.SeconadryColor
                        : Colors.white.withOpacity(0.4),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.r),
                  child: _scannedPatientId != null
                      ? Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Constants.SeconadryColor,
                            size: 60,
                          ),
                        )
                      : AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Stack(
                              children: [
                                Positioned(
                                  top: _animation.value * (scanArea - 20),
                                  left: 10,
                                  right: 10,
                                  child: Container(
                                    height: 3,
                                    decoration: const BoxDecoration(
                                      color: Constants.SeconadryColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Constants.SeconadryColor,
                                          blurRadius: 8,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ),

          // 4. Floating Header Navigation Controls
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlassIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    "Reward Workspace".tr,
                    style: GoogleFonts.lexend(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildGlassIconButton(
                    icon: Icons.flash_on_rounded,
                    onTap: () => _scannerController.toggleTorch(),
                  ),
                ],
              ),
            ),
          ),

          // 5. Patient Verification Status and Point Credit Form Module Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 28.w,
                right: 28.w,
                top: 24.h,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    24.h, // Dynamic structural padding protection
              ),
              decoration: BoxDecoration(
                color: Constants.MidnightNavy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientStatusHeader(),
                  SizedBox(height: 16.h),
                  _buildPointsInputField(),
                  SizedBox(height: 20.h),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientStatusHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TARGET PATIENT IDENTIFIER".tr,
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _scannedPatientId != null
                  ? "Verified".tr
                  : "Awaiting QR Scan...".tr,
              style: GoogleFonts.lexend(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (_scannedPatientId != null)
          TextButton.icon(
            onPressed: () async {
              setState(() => _scannedPatientId = null);
              try {
                await _scannerController.start();
                _isScannerRunning = true;
              } catch (_) {}
            },
            icon: const Icon(
              Icons.refresh_rounded,
              color: Constants.SeconadryColor,
            ),
            label: Text(
              "Reset".tr,
              style: const TextStyle(
                color: Constants.SeconadryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPointsInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: _pointsController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: "Enter points to credit (e.g. 200)".tr,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.25),
            fontSize: 13.sp,
          ),
          prefixIcon: const Icon(
            Icons.stars_rounded,
            color: Constants.SeconadryColor,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _submitPointsTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.SeconadryColor,
          foregroundColor: Constants.MidnightNavy,
          disabledBackgroundColor: Constants.SeconadryColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: _isProcessing
            ? SizedBox(
                height: 22.h,
                width: 22.h,
                child: const CircularProgressIndicator(
                  color: Constants.MidnightNavy,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Credit Loyalty Points".tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  Widget _buildPermissionFallbackView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: _isLoadingPermission
            ? const CircularProgressIndicator(color: Constants.SeconadryColor)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_enhance_outlined,
                    size: 54,
                    color: Colors.white30,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Camera Feed Required".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: _checkPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.SeconadryColor,
                    ),
                    child: Text(
                      "Grant Camera Permission".tr,
                      style: const TextStyle(color: Constants.MidnightNavy),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFallbackMessage(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
