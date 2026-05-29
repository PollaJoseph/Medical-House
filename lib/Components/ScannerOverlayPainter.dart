import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  final double scanArea;
  final double borderRadius;

  ScannerOverlayPainter({required this.scanArea, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    // The dark overlay color
    final paint = Paint()..color = Colors.black.withOpacity(0.6);

    // Path 1: The full screen
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Path 2: The exact center cutout area
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: scanArea,
            height: scanArea,
          ),
          Radius.circular(borderRadius),
        ),
      );

    // Combine paths by subtracting the cutout from the background
    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
