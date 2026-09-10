import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class IllustratedCityscapePainter extends CustomPainter {
  const IllustratedCityscapePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final backWavePaint = Paint()
      ..color = AppColors.mintHighlight.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    final backWave = Path()
      ..moveTo(0, h * 0.55)
      ..quadraticBezierTo(w * 0.25, h * 0.35, w * 0.5, h * 0.55)
      ..quadraticBezierTo(w * 0.75, h * 0.75, w, h * 0.45)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(backWave, backWavePaint);

    final sunCenter = Offset(w * 0.93, h * 0.28);
    final sunPaint = Paint()
      ..color = const Color(0xFFFDE047).withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, 13, sunPaint);

    final bldg1Paint = Paint()..color = AppColors.primaryTeal;
    final bldg2Paint = Paint()..color = const Color(0xFF38BDF8);
    final bldg3Paint = Paint()..color = const Color(0xFF2DD4BF);
    final windowPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);

    final bldg1Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.895, h * 0.35, 34, h * 0.65),
      const Radius.circular(2),
    );
    canvas.drawRRect(bldg1Rect, bldg1Paint);

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 2; c++) {
        canvas.drawRect(
          Rect.fromLTWH(w * 0.895 + 6 + (c * 13), h * 0.35 + 8 + (r * 11), 7, 6),
          windowPaint,
        );
      }
    }

    final bldg2Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.85, h * 0.52, 26, h * 0.48),
      const Radius.circular(2),
    );
    canvas.drawRRect(bldg2Rect, bldg2Paint);

    final bldg3Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.938, h * 0.48, 28, h * 0.52),
      const Radius.circular(2),
    );
    canvas.drawRRect(bldg3Rect, bldg3Paint);

    final treePaint1 = Paint()..color = const Color(0xFF22C55E);
    final treePaint2 = Paint()..color = const Color(0xFF16A34A);
    canvas.drawCircle(Offset(w * 0.84, h * 0.85), 11, treePaint1);
    canvas.drawCircle(Offset(w * 0.978, h * 0.85), 10, treePaint2);

    final foreWavePaint = Paint()
      ..color = const Color(0xFF0D9488).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final foreWave = Path()
      ..moveTo(0, h * 0.75)
      ..quadraticBezierTo(w * 0.35, h * 0.92, w * 0.65, h * 0.72)
      ..quadraticBezierTo(w * 0.82, h * 0.6, w, h * 0.78)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(foreWave, foreWavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
